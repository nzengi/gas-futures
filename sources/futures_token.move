module gas_futures::futures_token {
    use sui::coin::{Self, TreasuryCap, Coin};
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::clock::{Self, Clock};
    use sui::sui::SUI;
    use sui::balance::{Self, Balance};
    use gas_futures::risk_pool::{Self, RiskPool};
    use gas_futures::pricing::{Self, PricingModel};
    use gas_futures::oracle_integration::{Self, GasOracle};
    use gas_futures::emergency::{Self, EmergencySwitch};

    public struct GasFutureToken has key, store {
        id: UID,
        expiry: u64,        // Unix timestamp
        gas_units: u64,     // Pre-purchased gas units
        strike_price: u64,  // Fixed price in SUI
        premium_paid: u64,  // Paid premium amount
    }

    // Events
    public struct TokenMinted has copy, drop, store {
        buyer: address,
        gas_units: u64,
        strike_price: u64,
        premium_paid: u64,
        expiry: u64
    }

    public struct TokenBurned has copy, drop, store {
        gas_units: u64,
        strike_price: u64
    }

    // Error codes
    const E_INSUFFICIENT_PAYMENT: u64 = 1;
    const E_CONTRACT_PAUSED: u64 = 2;
    const E_TOKEN_EXPIRED: u64 = 3;

    // Token minting function (with risk pool integration)
    public entry fun mint(
        pool: &mut RiskPool,
        oracle: &GasOracle,
        pricing_model: &PricingModel,
        emergency_switch: EmergencySwitch,
        gas_units: u64,
        expiry: u64,
        payment: Coin<SUI>,
        ctx: &mut TxContext
    ) {
        assert!(!emergency::is_paused(&emergency_switch), E_CONTRACT_PAUSED);
        
        // Get the current gas price
        let current_gas_price = oracle_integration::get_current_gas_price(oracle, &emergency_switch);
        
        // Check adequacy
        assert!(risk_pool::can_mint_token(pool, gas_units, current_gas_price, &emergency_switch), E_INSUFFICIENT_PAYMENT);
        
        // Calculate premium
        let current_time = tx_context::epoch_timestamp_ms(ctx);
        let days_to_expiry = if (expiry > current_time) {
            (expiry - current_time) / (24 * 60 * 60 * 1000)
        } else {
            0
        };
        let volatility = risk_pool::get_volatility_index(pool);
        let premium = pricing::calculate_premium(current_gas_price, volatility, days_to_expiry, pricing_model);
        
        // Calculate total cost
        let total_cost = gas_units * (current_gas_price + premium);
        let payment_value = coin::value(&payment);
        assert!(payment_value >= total_cost, E_INSUFFICIENT_PAYMENT);
        
        // Pay to the risk pool (use the coin directly)
        risk_pool::add_coin(pool, payment);
        
        // Return the EmergencySwitch
        emergency::return_switch(emergency_switch, ctx);
        
        // Mint the token
        let token = GasFutureToken {
            id: object::new(ctx),
            expiry,
            gas_units,
            strike_price: current_gas_price,
            premium_paid: premium
        };
        
        // Transfer the token to the buyer
        sui::transfer::transfer(token, tx_context::sender(ctx));
    }

    // Burn expired tokens
    public entry fun burn_expired(
        token: GasFutureToken,
        clock: &Clock,
        pool: &mut RiskPool
    ) {
        assert!(clock.timestamp_ms() > token.expiry * 1000, E_TOKEN_EXPIRED);
        
        // Reduce liabilities
        let liability_amount = token.gas_units * token.strike_price;
        risk_pool::reduce_liabilities(pool, liability_amount);
        
        let GasFutureToken { id, expiry: _, gas_units: _, strike_price: _, premium_paid: _ } = token;
        object::delete(id);
    }

    // Burn token (for other modules)
    public fun burn(token: GasFutureToken) {
        let GasFutureToken { id, expiry: _, gas_units: _, strike_price: _, premium_paid: _ } = token;
        object::delete(id);
    }

    // Public getter functions
    public fun get_expiry(token: &GasFutureToken): u64 { token.expiry }
    public fun get_gas_units(token: &GasFutureToken): u64 { token.gas_units }
    public fun get_strike_price(token: &GasFutureToken): u64 { token.strike_price }
    public fun get_premium_paid(token: &GasFutureToken): u64 { token.premium_paid }

    #[test]
    public fun test_getters_and_burn() {
        let sender = @0x0;
        let tx_hash = vector[
            0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0
        ];
        let mut ctx = sui::tx_context::new(sender, tx_hash, 0, 0, 0);
        let token = GasFutureToken {
            id: sui::object::new(&mut ctx),
            expiry: 12345,
            gas_units: 100,
            strike_price: 42,
            premium_paid: 5
        };
        assert!(get_expiry(&token) == 12345, 100);
        assert!(get_gas_units(&token) == 100, 101);
        assert!(get_strike_price(&token) == 42, 102);
        assert!(get_premium_paid(&token) == 5, 103);
        burn(token);
    }
}