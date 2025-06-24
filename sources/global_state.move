module gas_futures::global_state {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::TxContext;
    use sui::transfer;

    public struct GlobalState has key {
        id: UID,
        risk_pool_id: ID,
        oracle_id: ID,
        emergency_switch_id: ID,
        pricing_model_id: ID,
        admin: address,
    }

    // Events
    public struct StateUpdated has copy, drop, store {
        timestamp: u64,
        component: vector<u8>
    }

    // Error codes
    const E_NOT_ADMIN: u64 = 1;
    const E_INVALID_ID: u64 = 2;

    // Create new global state
    public fun new(
        risk_pool_id: ID,
        oracle_id: ID,
        emergency_switch_id: ID,
        pricing_model_id: ID,
        ctx: &mut TxContext
    ): GlobalState {
        GlobalState {
            id: object::new(ctx),
            risk_pool_id,
            oracle_id,
            emergency_switch_id,
            pricing_model_id,
            admin: tx_context::sender(ctx)
        }
    }

    // Update risk pool ID (admin only)
    public entry fun update_risk_pool(
        state: &mut GlobalState,
        new_pool_id: ID,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == state.admin, E_NOT_ADMIN);
        state.risk_pool_id = new_pool_id;
    }

    // Update oracle ID (admin only)
    public entry fun update_oracle(
        state: &mut GlobalState,
        new_oracle_id: ID,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == state.admin, E_NOT_ADMIN);
        state.oracle_id = new_oracle_id;
    }

    // Update emergency switch ID (admin only)
    public entry fun update_emergency_switch(
        state: &mut GlobalState,
        new_switch_id: ID,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == state.admin, E_NOT_ADMIN);
        state.emergency_switch_id = new_switch_id;
    }

    // Update pricing model ID (admin only)
    public entry fun update_pricing_model(
        state: &mut GlobalState,
        new_model_id: ID,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == state.admin, E_NOT_ADMIN);
        state.pricing_model_id = new_model_id;
    }

    // Transfer admin rights
    public entry fun transfer_admin(
        state: &mut GlobalState,
        new_admin: address,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == state.admin, E_NOT_ADMIN);
        state.admin = new_admin;
    }

    // Public getters
    public fun get_risk_pool_id(state: &GlobalState): ID { state.risk_pool_id }
    public fun get_oracle_id(state: &GlobalState): ID { state.oracle_id }
    public fun get_emergency_switch_id(state: &GlobalState): ID { state.emergency_switch_id }
    public fun get_pricing_model_id(state: &GlobalState): ID { state.pricing_model_id }
    public fun get_admin(state: &GlobalState): address { state.admin }

    // Share global state
    public fun share(state: GlobalState) {
        transfer::share_object(state);
    }
} 