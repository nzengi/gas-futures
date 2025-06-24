module gas_futures::redemption {
    use sui::clock::Clock;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    // use sui::programmable_transactions; // Not available in current Sui version
    use gas_futures::futures_token::{Self, GasFutureToken};
    use gas_futures::emergency::{Self, EmergencySwitch};

    const E_TOKEN_EXPIRED: u64 = 1;
    const E_CONTRACT_PAUSED: u64 = 2;
    const E_INSUFFICIENT_GAS: u64 = 3;

    // Token redemption (with sponsored transaction)
    public entry fun redeem(
        token: GasFutureToken,
        clock: &Clock,
        emergency_switch: &EmergencySwitch,
        ptb: vector<vector<u8>>, // Programmable transaction bytes
        ctx: &mut TxContext
    ) {
        assert!(!emergency::is_paused(emergency_switch), E_CONTRACT_PAUSED);
        assert!(clock.timestamp_ms() < futures_token::get_expiry(&token) * 1000, E_TOKEN_EXPIRED);
        
        let gas_units = futures_token::get_gas_units(&token);
        let strike_price = futures_token::get_strike_price(&token);
        
        // Calculate gas budget
        let gas_budget = gas_units * strike_price;
        
        // Execute programmable transaction
        // Note: In a real implementation, sponsored transaction logic would be here
        // programmable_transactions::execute(gas_budget, ptb);
        
        // Burn the token
        futures_token::burn(token);
    }

    // Simple redemption (without sponsored transaction)
    public entry fun simple_redeem(
        token: GasFutureToken,
        clock: &Clock,
        emergency_switch: &EmergencySwitch,
        ctx: &mut TxContext
    ) {
        assert!(!emergency::is_paused(emergency_switch), E_CONTRACT_PAUSED);
        assert!(clock.timestamp_ms() < futures_token::get_expiry(&token) * 1000, E_TOKEN_EXPIRED);
        
        // Burn the token
        futures_token::burn(token);
    }

    // Calculate gas units
    public fun calculate_gas_units(
        token: &GasFutureToken,
        current_gas_price: u64
    ): u64 {
        let strike_price = futures_token::get_strike_price(token);
        let gas_units = futures_token::get_gas_units(token);
        
        // Calculate gas units according to strike price
        if (current_gas_price <= strike_price) {
            gas_units
        } else {
            // If current price is higher than strike price, less gas units
            (gas_units * strike_price) / current_gas_price
        }
    }
}