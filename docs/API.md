# Gas Futures Protocol - API Reference

## Overview

This document provides comprehensive API documentation for the Gas Futures Protocol smart contracts. All functions are designed to work with the SUI blockchain and follow Move language conventions.

## Core Modules

### 1. Futures Token Module (`futures_token`)

#### Structs

```move
public struct GasFutureToken has key, store {
    id: UID,
    expiry: u64,
    gas_units: u64,
    strike_price: u64,
}
```

#### Functions

##### `mint`

Mint new gas futures tokens.

```move
public entry fun mint(
    treasury: &mut TreasuryCap<GasFutureToken>,
    buyer: address,
    gas_units: u64,
    strike_price: u64,
    expiry: u64,
    ctx: &mut TxContext
)
```

**Parameters:**

- `treasury`: Treasury capability for minting tokens
- `buyer`: Address of the token buyer
- `gas_units`: Amount of gas units to purchase
- `strike_price`: Fixed price in SUI per gas unit
- `expiry`: Token expiry timestamp
- `ctx`: Transaction context

**Example:**

```bash
sui client call \
    --package $PACKAGE_ID \
    --module futures_token \
    --function mint \
    --args $TREASURY_CAP $BUYER_ADDRESS 1000 100 1735689600 \
    --gas-budget 10000000
```

##### `burn_expired`

Burn expired tokens.

```move
public entry fun burn_expired(
    treasury: &mut TreasuryCap<GasFutureToken>,
    token: GasFutureToken,
    clock: &Clock,
    ctx: &mut TxContext
)
```

**Parameters:**

- `treasury`: Treasury capability
- `token`: Token to burn
- `clock`: SUI clock object
- `ctx`: Transaction context

### 2. Risk Pool Module (`risk_pool`)

#### Structs

```move
public struct RiskPool has key {
    id: UID,
    collateral: Balance<SUI>,
    volatility_index: u64,
    total_deposits: u64,
}
```

#### Functions

##### `init_risk_pool`

Initialize a new risk pool.

```move
public entry fun init_risk_pool(ctx: &mut TxContext)
```

**Example:**

```bash
sui client call \
    --package $PACKAGE_ID \
    --module risk_pool \
    --function init_risk_pool \
    --gas-budget 10000000
```

##### `deposit`

Deposit SUI into the risk pool.

```move
public entry fun deposit(
    pool: &mut RiskPool,
    payment: Coin<SUI>,
    ctx: &mut TxContext
)
```

**Parameters:**

- `pool`: Risk pool object
- `payment`: SUI coin to deposit
- `ctx`: Transaction context

**Example:**

```bash
sui client call \
    --package $PACKAGE_ID \
    --module risk_pool \
    --function deposit \
    --args $RISK_POOL_ID $SUI_COIN \
    --gas-budget 10000000
```

##### `calculate_premium`

Calculate premium for gas futures.

```move
public fun calculate_premium(
    pool: &RiskPool,
    gas_units: u64,
    time_to_expiry: u64,
    current_gas_price: u64
): u64
```

**Parameters:**

- `pool`: Risk pool object
- `gas_units`: Amount of gas units
- `time_to_expiry`: Time until expiry
- `current_gas_price`: Current gas price

**Returns:** Premium amount in SUI

### 3. Redemption Module (`redemption`)

#### Functions

##### `redeem`

Redeem gas futures token for sponsored transaction.

```move
public entry fun redeem(
    token: GasFutureToken,
    pool: &mut RiskPool,
    clock: &Clock,
    ctx: &mut TxContext
)
```

**Parameters:**

- `token`: Gas futures token to redeem
- `pool`: Risk pool object
- `clock`: SUI clock object
- `ctx`: Transaction context

**Example:**

```bash
sui client call \
    --package $PACKAGE_ID \
    --module redemption \
    --function redeem \
    --args $TOKEN_ID $RISK_POOL_ID $CLOCK_ID \
    --gas-budget 10000000
```

### 4. Oracle Integration Module (`oracle_integration`)

#### Structs

```move
public struct GasOracle has key {
    id: UID,
    oracle_id: ID,
    last_update: u64,
}
```

#### Functions

##### `init_oracle`

Initialize gas oracle.

```move
public entry fun init_oracle(
    oracle_id: ID,
    ctx: &mut TxContext
)
```

##### `get_current_gas_price`

Get current gas price from oracle.

```move
public fun get_current_gas_price(oracle: &GasOracle): u64
```

### 5. Emergency Module (`emergency`)

#### Structs

```move
public struct EmergencySwitch has key {
    id: UID,
    is_paused: bool,
    admin: address,
}
```

#### Functions

##### `init_emergency_switch`

Initialize emergency switch.

```move
public entry fun init_emergency_switch(ctx: &mut TxContext)
```

##### `pause_contract`

Pause contract operations.

```move
public entry fun pause_contract(
    switch: &mut EmergencySwitch,
    ctx: &mut TxContext
)
```

##### `resume_contract`

Resume contract operations.

```move
public entry fun resume_contract(
    switch: &mut EmergencySwitch,
    ctx: &mut TxContext
)
```

### 6. Pricing Module (`pricing`)

#### Structs

```move
public struct PricingModel has key {
    id: UID,
    base_price: u64,
    volatility_factor: u64,
    time_decay: u64,
}
```

#### Functions

##### `init_pricing_model`

Initialize pricing model.

```move
public entry fun init_pricing_model(
    base_price: u64,
    ctx: &mut TxContext
)
```

##### `calculate_price`

Calculate token price.

```move
public fun calculate_price(
    model: &PricingModel,
    time_to_expiry: u64,
    volatility: u64
): u64
```

### 7. Global State Module (`global_state`)

#### Structs

```move
public struct GlobalState has key {
    id: UID,
    total_tokens_minted: u64,
    total_volume: u64,
    active_pools: u64,
}
```

#### Functions

##### `init_global_state`

Initialize global state.

```move
public entry fun init_global_state(ctx: &mut TxContext)
```

##### `update_stats`

Update global statistics.

```move
public entry fun update_stats(
    state: &mut GlobalState,
    tokens_minted: u64,
    volume: u64,
    ctx: &mut TxContext
)
```

## Error Codes

| Code                    | Description              |
| ----------------------- | ------------------------ |
| `ENOT_AUTHORIZED`       | Unauthorized access      |
| `EINSUFFICIENT_BALANCE` | Insufficient balance     |
| `ETOKEN_EXPIRED`        | Token has expired        |
| `EPOOL_FULL`            | Risk pool is at capacity |
| `EINVALID_PRICE`        | Invalid price data       |
| `ECONTRACT_PAUSED`      | Contract is paused       |

## Events

### Token Events

```move
public struct TokenMinted has copy, drop {
    buyer: address,
    gas_units: u64,
    strike_price: u64,
    expiry: u64,
}

public struct TokenBurned has copy, drop {
    token_id: ID,
    reason: vector<u8>,
}
```

### Pool Events

```move
public struct PoolDeposit has copy, drop {
    depositor: address,
    amount: u64,
    pool_id: ID,
}

public struct PoolWithdrawal has copy, drop {
    withdrawer: address,
    amount: u64,
    pool_id: ID,
}
```

### Emergency Events

```move
public struct ContractPaused has copy, drop {
    paused_by: address,
    timestamp: u64,
}

public struct ContractResumed has copy, drop {
    resumed_by: address,
    timestamp: u64,
}
```

## Integration Examples

### DeepBook Integration

```move
use deepbook::pool::Pool;
use deepbook::order_book::OrderBook;

// Create gas futures market on DeepBook
public entry fun create_gas_futures_market(
    pool: &mut Pool,
    base_coin: TypeName,
    quote_coin: TypeName,
    ctx: &mut TxContext
) {
    // Implementation for DeepBook integration
}
```

### Wallet Integration

```move
// Standard SUI wallet integration
public entry fun transfer_token(
    token: GasFutureToken,
    recipient: address,
    ctx: &mut TxContext
) {
    transfer::transfer(token, recipient);
}
```

## Testing

### Unit Tests

```bash
# Run all tests
sui move test

# Run specific module tests
sui move test --filter futures_token
sui move test --filter risk_pool
```

### Integration Tests

```bash
# Test complete workflow
sui move test --filter integration
```

## Security Considerations

1. **Access Control**: All critical functions require proper authorization
2. **Input Validation**: All parameters are validated before processing
3. **Reentrancy Protection**: Functions are protected against reentrancy attacks
4. **Emergency Controls**: Pause mechanism for emergency situations
5. **Oracle Security**: Multiple oracle support for price validation

## Performance

- **Gas Optimization**: Efficient Move code for minimal gas costs
- **Batch Operations**: Support for batch token operations
- **Lazy Loading**: On-demand data loading for better performance
- **Caching**: Strategic caching for frequently accessed data

---

For more information, see the [Architecture Documentation](ARCHITECTURE.md) and [User Guide](USER_GUIDE.md).
