// Risk Pool Initialization Module
// This module is used to initialize the risk pool

module gas_futures::init_risk_pool {
    use sui::tx_context::TxContext;
    use gas_futures::risk_pool::{Self, RiskPool};

    fun init(ctx: &mut TxContext) {
        let pool = risk_pool::new(ctx);
        // Register the pool in global storage
        risk_pool::share(pool);
    }

    // Entry function to create and share the risk pool
    public entry fun create_and_share_risk_pool(ctx: &mut TxContext) {
        let pool = risk_pool::new(ctx);
        risk_pool::share(pool);
    }
} 