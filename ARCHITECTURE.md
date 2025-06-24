# Gas Futures Project - Architecture Analysis

## 📋 Project Overview

This project develops a comprehensive DeFi protocol for gas futures tokens on the SUI blockchain. Users can lock in future gas costs and manage volatility risk.

## 🏗️ System Architecture

### 1. **Futures Token Module** (`futures_token.move`)

#### Structure and Features:

- **GasFutureToken Struct**: Main token structure
  - `expiry`: Token validity period (Unix timestamp)
  - `gas_units`: Amount of pre-purchased gas units
  - `strike_price`: Fixed price in SUI

#### Functions:

- **`mint()`**: Mint new gas futures tokens
- **`burn_expired()`**: Burn expired tokens

#### Technical Details:

```move
// Token minting process
public entry fun mint(
    treasury: &mut TreasuryCap<GasFutureToken>,
    buyer: address,
    gas_units: u64,
    strike_price: u64,
    expiry: u64,
    ctx: &mut TxContext
)
```

### 2. **Risk Pool Module** (`risk_pool.move`)

#### Structure and Features:

- **RiskPool Struct**: Risk management pool
  - `collateral`: Collateral balance in SUI
  - `volatility_index`: Historical volatility index

#### Functions:

- **`deposit()`**: Add SUI to the pool
- **`calculate_premium()`**: Dynamic pricing (Black-Scholes variant)

#### Pricing Algorithm:

```move
// Black-Scholes variant formula
let v_sqrt_t = (volatility * sqrt(time_to_expiry)) / 1000;
(current_gas_price * (10000 + v_sqrt_t)) / 10000
```

### 3. **Redemption Module** (`redemption.move`)

#### Structure and Features:

- **Sponsored Transaction**: Execute transactions without gas cost
- **Programmable Transaction Block**: For complex operations

#### Functions:

- **`redeem()`**: Execute a sponsored transaction using the token

#### Process Flow:

1. Token validity check
2. GasCoin creation (simulated)
3. Programmable transaction execution
4. Token burn

### 4. **Oracle Integration Module** (`oracle_integration.move`)

#### Structure and Features:

- **GasOracle Struct**: Price oracle integration
  - `oracle_id`: Oracle source ID

#### Functions:

- **`get_current_gas_price()`**: Fetch real-time gas price

#### Oracle Integration:

```move
// Fetch SUI/USD price
price_oracle::get_price(&price_obj, "SUI/USD")
```

### 5. **Emergency Module** (`emergency.move`)

#### Structure and Features:

- **EmergencySwitch Struct**: Emergency control
- **Pause Mechanism**: Ability to pause the contract

#### Functions:

- **`pause_contract()`**: Temporarily pause the contract

## 🔄 System Flow

### 1. **Token Purchase Process**

```
User → Risk Pool → Premium Calculation → Token Minting → Transfer to User
```

### 2. **Token Usage Process**

```
Token → Validity Check → Oracle Price Check → Sponsored Transaction → Token Burn
```

### 3. **Risk Management Process**

```
Volatility Calculation → Premium Update → Collateral Management → Risk Pool Balancing
```

## 🛡️ Security Features

### 1. **Time-Based Security**

- Token expiry check
- Clock-based validation
- Automatic token burning

### 2. **Price Manipulation Protection**

- Oracle integration
- Real-time price validation
- Volatility-based premium calculation

### 3. **Emergency Mechanisms**

- Contract pause capability
- Emergency switch
- Event logging

## 📊 Economic Model

### 1. **Premium Calculation**

- **Base Formula**: `current_gas_price * (1 + volatility_factor)`
- **Volatility Factor**: `(volatility * sqrt(time_to_expiry)) / 1000`
- **Risk Adjustment**: Historical volatility index

### 2. **Risk Pool Economics**

- **Collateral Management**: SUI collateral management
- **Volatility Index**: Dynamic risk calculation
- **Liquidity Provision**: Incentives for liquidity providers

### 3. **Token Valuation**

- **Strike Price**: Fixed price guarantee
- **Time Value**: Time value calculation
- **Intrinsic Value**: Intrinsic value calculation

## 🔧 Technical Requirements

### 1. **SUI Framework Dependencies**

- `sui::coin`: Token management
- `sui::balance`: Balance operations
- `sui::object`: Object management
- `sui::clock`: Time control
- `sui::programmable_transaction`: Complex transactions
- `sui::price_oracle`: Price data

### 2. **Mathematical Calculations**

- Square root calculation
- Volatility calculation
- Premium formulation

### 3. **Event System**

- Pause events
- Token mint/burn events
- Risk pool events

## 🚀 Deployment and Testing

### 1. **Testnet Deployment**

- `deploy_testnet.sh`: Automated deployment script
- `init_risk_pool.move`: Risk pool initialization script

### 2. **Test Coverage**

- `futures_token_test.move`: Token module tests
- `redemption_test.move`: Redemption module tests

### 3. **Test Scenarios**

- Token minting and burning
- Risk pool deposit and withdrawal
- Oracle price update
- Emergency pause and resume
- Redemption with sponsored transaction

---

This architecture provides a modular, secure, and extensible foundation for gas futures trading and risk management on the SUI blockchain.
