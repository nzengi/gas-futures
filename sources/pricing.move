module gas_futures::pricing {
    use sui::math;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    public struct PricingModel has key {
        id: UID,
        base_volatility: u64,  // Base volatility percentage (e.g., 50 = 50%)
        risk_free_rate: u64,   // Risk-free rate in basis points (e.g., 500 = 5%)
    }

    const PRECISION: u64 = 1000000; // 6 decimal places
    const MAX_VOLATILITY: u64 = 1000; // 1000% max volatility
    const MIN_VOLATILITY: u64 = 10;   // 10% min volatility

    // Entry function to create a pricing model
    public entry fun create_pricing_model(
        base_volatility: u64,
        risk_free_rate: u64,
        ctx: &mut TxContext
    ) {
        let model = PricingModel {
            id: object::new(ctx),
            base_volatility,
            risk_free_rate
        };
        sui::transfer::transfer(model, tx_context::sender(ctx));
    }

    // Black-Scholes inspired pricing model
    public fun calculate_premium(
        current_price: u64,
        volatility: u64,
        expiry_days: u64,
        model: &PricingModel
    ): u64 {
        // Ensure volatility is within bounds
        let adjusted_volatility = if (volatility > MAX_VOLATILITY) {
            MAX_VOLATILITY
        } else if (volatility < MIN_VOLATILITY) {
            MIN_VOLATILITY
        } else {
            volatility
        };

        // Time value component (square root of time)
        let time_factor = math::sqrt(expiry_days * PRECISION);
        
        // Volatility component
        let vol_factor = (adjusted_volatility * model.base_volatility) / 100;
        
        // Risk-free rate component
        let rate_factor = (model.risk_free_rate * expiry_days) / 36500; // Convert to daily rate
        
        // Premium calculation: price * volatility * sqrt(time) * (1 + risk_rate)
        let premium = (current_price * vol_factor * time_factor) / (PRECISION * 100);
        let adjusted_premium = premium + (premium * rate_factor) / PRECISION;
        
        adjusted_premium
    }

    // Calculate total cost including premium
    public fun calculate_total_cost(
        gas_units: u64,
        current_price: u64,
        volatility: u64,
        expiry_days: u64,
        model: &PricingModel
    ): u64 {
        let premium = calculate_premium(current_price, volatility, expiry_days, model);
        let total_price = current_price + premium;
        gas_units * total_price
    }

    // Dynamic volatility adjustment based on market conditions
    public fun adjust_volatility(
        base_volatility: u64,
        market_stress: u64,  // 0-100, higher = more stress
        historical_vol: u64
    ): u64 {
        let stress_multiplier = (100 + market_stress) / 100;
        let adjusted_vol = (base_volatility * stress_multiplier) / 100;
        
        // Blend with historical volatility
        let blended_vol = (adjusted_vol * 70 + historical_vol * 30) / 100;
        
        if (blended_vol > MAX_VOLATILITY) {
            MAX_VOLATILITY
        } else {
            blended_vol
        }
    }

    // Create new pricing model
    public fun new(
        base_volatility: u64,
        risk_free_rate: u64,
        ctx: &mut TxContext
    ): PricingModel {
        PricingModel {
            id: object::new(ctx),
            base_volatility,
            risk_free_rate
        }
    }

    // Public getters
    public fun get_base_volatility(model: &PricingModel): u64 { model.base_volatility }
    public fun get_risk_free_rate(model: &PricingModel): u64 { model.risk_free_rate }
} 