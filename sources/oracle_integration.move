module gas_futures::oracle_integration {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::TxContext;
    use sui::dynamic_field;
    use gas_futures::emergency::{Self, EmergencySwitch};

    public struct GasOracle has key {
        id: UID,
        oracle_id: ID,
        last_update: u64,
        fallback_price: u64, // Price to use if the oracle fails
    }

    // Error codes
    const E_ORACLE_STALE: u64 = 1;
    const E_CONTRACT_PAUSED: u64 = 2;

    // Get real-time gas price (with oracle integration)
    public fun get_current_gas_price(
        oracle: &GasOracle,
        emergency_switch: &EmergencySwitch
    ): u64 {
        assert!(!emergency::is_paused(emergency_switch), E_CONTRACT_PAUSED);
        
        // Simulate fetching price from oracle
        // In a real implementation, the oracle API would be called here
        
        // Check if the oracle is up-to-date (5 minutes)
        // Note: In a real implementation, current_time would be passed as a parameter
        if (oracle.last_update > 0) {
            // Fetch price from oracle (simulation)
            // In a real implementation: price_oracle::get_price(&oracle.oracle_id, "SUI/USD")
            oracle.fallback_price + (oracle.fallback_price * 10) / 100 // 10% volatility
        } else {
            // If the oracle is not up-to-date, use the fallback price
            oracle.fallback_price
        }
    }

    // Update the oracle (admin function)
    public entry fun update_oracle_price(
        oracle: &mut GasOracle,
        new_price: u64,
        emergency_switch: &EmergencySwitch,
        ctx: &mut TxContext
    ) {
        assert!(!emergency::is_paused(emergency_switch), E_CONTRACT_PAUSED);
        oracle.fallback_price = new_price;
        oracle.last_update = tx_context::epoch_timestamp_ms(ctx);
    }

    // Create oracle
    public fun new(
        oracle_id: ID,
        fallback_price: u64,
        ctx: &mut TxContext
    ): GasOracle {
        GasOracle {
            id: object::new(ctx),
            oracle_id,
            last_update: tx_context::epoch_timestamp_ms(ctx),
            fallback_price
        }
    }

    // Oracle creation entry function
    public entry fun create_gas_oracle(
        fallback_price: u64,
        ctx: &mut TxContext
    ) {
        let dummy_id = object::id_from_address(tx_context::sender(ctx));
        let oracle = new(dummy_id, fallback_price, ctx);
        sui::transfer::transfer(oracle, tx_context::sender(ctx));
    }

    // Public getters
    public fun get_oracle_id(oracle: &GasOracle): ID { oracle.oracle_id }
    public fun get_fallback_price(oracle: &GasOracle): u64 { oracle.fallback_price }
    public fun get_last_update(oracle: &GasOracle): u64 { oracle.last_update }
}