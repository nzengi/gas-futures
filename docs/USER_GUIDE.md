# Gas Futures Protocol - User Guide

## Introduction

Welcome to the Gas Futures Protocol! This guide will help you understand how to use our DeFi protocol to hedge gas price volatility on the SUI blockchain. Whether you're a developer, business, or individual user, this protocol allows you to secure predictable gas costs for future transactions.

## What is Gas Futures?

Gas futures are financial derivatives that allow you to lock in gas prices for future use. Similar to how oil futures work in traditional markets, gas futures help you:

- **Hedge against volatility**: Protect against sudden gas price spikes
- **Budget planning**: Predict and plan for future transaction costs
- **Cost efficiency**: Secure better rates during low volatility periods
- **Risk management**: Reduce exposure to gas price fluctuations

## Getting Started

### Prerequisites

1. **SUI Wallet**: Install a SUI-compatible wallet (Sui Wallet, Suiet, etc.)
2. **SUI Tokens**: Have SUI tokens for purchasing gas futures
3. **Network Access**: Connect to SUI testnet or mainnet

### Installation

```bash
# Clone the repository (for developers)
git clone https://github.com/nzengi/gas-futures.git
cd gas-futures

# Install dependencies
sui move build
```

## Core Features

### 1. Purchasing Gas Futures

#### Step 1: Connect Your Wallet

- Open your SUI wallet
- Connect to the Gas Futures Protocol interface
- Ensure you have sufficient SUI balance

#### Step 2: Select Gas Futures

- Choose the amount of gas units you want to purchase
- Select the expiry date (1 week, 1 month, 3 months, etc.)
- Review the strike price and premium

#### Step 3: Complete Purchase

```bash
# Example: Purchase 1000 gas units for 1 month
sui client call \
    --package $PACKAGE_ID \
    --module futures_token \
    --function mint \
    --args $TREASURY_CAP $YOUR_ADDRESS 1000 100 1735689600 \
    --gas-budget 10000000
```

### 2. Managing Your Gas Futures

#### View Your Tokens

- Check your wallet for `GasFutureToken` objects
- Each token shows:
  - Gas units available
  - Strike price
  - Expiry date
  - Current market value

#### Token Details

```move
struct GasFutureToken {
    expiry: u64,        // Unix timestamp
    gas_units: u64,     // Amount of gas
    strike_price: u64,  // Fixed price in SUI
}
```

### 3. Redeeming Gas Futures

#### Step 1: Prepare Transaction

- Ensure your token hasn't expired
- Verify the transaction you want to execute
- Check current gas prices

#### Step 2: Execute Sponsored Transaction

```bash
# Redeem token for sponsored transaction
sui client call \
    --package $PACKAGE_ID \
    --module redemption \
    --function redeem \
    --args $TOKEN_ID $RISK_POOL_ID $CLOCK_ID \
    --gas-budget 10000000
```

#### Step 3: Transaction Execution

- Your transaction executes without gas cost
- Token is automatically burned
- Gas is deducted from your futures balance

## Advanced Features

### 1. Risk Pool Participation

#### Becoming a Liquidity Provider

- Deposit SUI into the risk pool
- Earn fees from gas futures trading
- Help provide liquidity to the protocol

```bash
# Deposit SUI into risk pool
sui client call \
    --package $PACKAGE_ID \
    --module risk_pool \
    --function deposit \
    --args $RISK_POOL_ID $SUI_COIN \
    --gas-budget 10000000
```

#### Risk Pool Benefits

- **Fee Sharing**: Earn a portion of trading fees
- **Volatility Premium**: Benefit from price volatility
- **Protocol Governance**: Participate in protocol decisions

### 2. Pricing Models

#### Understanding Premiums

The protocol uses a Black-Scholes variant for pricing:

```
Premium = Current Gas Price × (1 + Volatility Factor)
Volatility Factor = (Volatility × √Time to Expiry) / 1000
```

#### Factors Affecting Price

- **Time to Expiry**: Longer periods = higher premiums
- **Market Volatility**: Higher volatility = higher premiums
- **Current Gas Price**: Base price for calculations
- **Risk Pool Capacity**: Available liquidity affects pricing

### 3. Oracle Integration

#### Real-Time Price Feeds

- Multiple oracle sources for price accuracy
- Automatic price updates
- Manipulation-resistant pricing

#### Price Sources

- SUI network gas price
- External oracle networks
- Community price feeds

## Use Cases

### 1. Business Applications

#### E-commerce Platforms

- Lock in gas costs for high-volume transactions
- Predictable operational costs
- Better customer pricing

#### DeFi Protocols

- Hedge gas costs for automated operations
- Reduce protocol overhead
- Improve user experience

### 2. Individual Users

#### Regular Traders

- Hedge against gas price spikes
- Optimize trading costs
- Better portfolio management

#### Developers

- Predictable deployment costs
- Testing environment stability
- Project budget planning

### 3. Institutional Users

#### Investment Funds

- Large-scale gas hedging
- Portfolio risk management
- Cost optimization strategies

## Risk Management

### 1. Understanding Risks

#### Market Risks

- **Price Volatility**: Gas prices can fluctuate significantly
- **Liquidity Risk**: Limited pool capacity during high demand
- **Oracle Risk**: Price feed accuracy and availability

#### Protocol Risks

- **Smart Contract Risk**: Code vulnerabilities
- **Governance Risk**: Protocol parameter changes
- **Emergency Pause**: Temporary protocol suspension

### 2. Risk Mitigation

#### Diversification

- Don't put all funds in one expiry period
- Use multiple risk pools
- Monitor market conditions

#### Monitoring

- Track token expiry dates
- Monitor risk pool health
- Stay informed about protocol updates

## Troubleshooting

### Common Issues

#### 1. Transaction Failures

**Problem**: Transaction fails with gas error
**Solution**:

- Check token expiry
- Verify sufficient gas units
- Ensure proper object ownership

#### 2. Token Expiry

**Problem**: Token has expired
**Solution**:

- Expired tokens are automatically burned
- Purchase new tokens for future use
- Monitor expiry dates proactively

#### 3. Insufficient Liquidity

**Problem**: Cannot purchase desired amount
**Solution**:

- Check risk pool capacity
- Try smaller amounts
- Wait for more liquidity

### Error Messages

| Error                   | Description           | Solution                   |
| ----------------------- | --------------------- | -------------------------- |
| `ETOKEN_EXPIRED`        | Token has expired     | Purchase new token         |
| `EINSUFFICIENT_BALANCE` | Not enough gas units  | Check token balance        |
| `EPOOL_FULL`            | Risk pool at capacity | Wait or try smaller amount |
| `ECONTRACT_PAUSED`      | Protocol is paused    | Wait for resume            |

## Best Practices

### 1. Token Management

- **Monitor Expiry Dates**: Set reminders for token expiry
- **Diversify Holdings**: Spread across multiple expiry periods
- **Regular Review**: Check token performance regularly

### 2. Risk Management

- **Start Small**: Begin with small amounts to learn
- **Monitor Markets**: Stay informed about gas price trends
- **Emergency Plan**: Have backup gas sources

### 3. Cost Optimization

- **Timing**: Purchase during low volatility periods
- **Amount**: Buy appropriate amounts for your needs
- **Expiry**: Choose expiry periods that match usage

## Integration Examples

### Web3 Integration

```javascript
// Example: Purchase gas futures via web3
const purchaseGasFutures = async (gasUnits, strikePrice, expiry) => {
  const txb = new TransactionBlock();

  txb.moveCall({
    target: `${PACKAGE_ID}::futures_token::mint`,
    arguments: [
      txb.object(TREASURY_CAP),
      txb.pure(buyerAddress),
      txb.pure(gasUnits),
      txb.pure(strikePrice),
      txb.pure(expiry),
    ],
  });

  return await suiClient.signAndExecuteTransactionBlock({
    transactionBlock: txb,
    requestType: "WaitForLocalExecution",
  });
};
```

### Mobile App Integration

```typescript
// Example: Mobile app integration
class GasFuturesManager {
  async purchaseToken(gasUnits: number, expiry: number): Promise<string> {
    // Implementation for mobile apps
  }

  async redeemToken(tokenId: string): Promise<boolean> {
    // Implementation for token redemption
  }
}
```

## Support and Resources

### Documentation

- [API Reference](API.md) - Technical documentation
- [Architecture Guide](ARCHITECTURE.md) - System design
- [Developer Guide](DEVELOPER_GUIDE.md) - Integration guide

### Community

- **Discord**: Join our community for support
- **GitHub**: Report issues and contribute
- **Twitter**: Follow for updates and announcements

### Tools

- **Dashboard**: Web interface for token management
- **Analytics**: Real-time protocol statistics
- **API**: REST API for integrations

## Conclusion

The Gas Futures Protocol provides a powerful tool for managing gas price risk on the SUI blockchain. By understanding the features, risks, and best practices outlined in this guide, you can effectively use gas futures to optimize your blockchain operations.

For additional support or questions, please reach out to our community channels or refer to the technical documentation.

---

**Happy Hedging! 🚀**

_This guide is part of the SUI Foundation Gas Futures Functionality RFP solution._
 