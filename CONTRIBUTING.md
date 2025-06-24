# Contributing to Gas Futures Protocol

Thank you for your interest in contributing to the Gas Futures Protocol! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Guidelines](#contributing-guidelines)
- [Code Style](#code-style)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)
- [Security](#security)
- [Community](#community)

## Code of Conduct

This project is committed to providing a welcoming and inclusive environment for all contributors. By participating in this project, you agree to abide by our Code of Conduct.

### Our Standards

- Be respectful and inclusive
- Use welcoming and inclusive language
- Be collaborative and open to feedback
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

- [Sui CLI](https://docs.sui.io/build/install) (latest version)
- [Move](https://move-language.github.io/move/) development environment
- [Git](https://git-scm.com/) for version control
- A SUI-compatible wallet for testing

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/gas-futures.git
   cd gas-futures
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/original-owner/gas-futures.git
   ```

## Development Setup

### Environment Setup

1. **Install Dependencies**:

   ```bash
   # Install Sui CLI
   curl -L https://github.com/MystenLabs/sui/releases/latest/download/sui-install.sh | sh

   # Verify installation
   sui --version
   ```

2. **Configure Network**:

   ```bash
   # Set up testnet
   sui client switch --env testnet

   # Get testnet SUI from faucet
   sui client faucet
   ```

3. **Build the Project**:
   ```bash
   sui move build
   ```

### Development Workflow

1. **Create a Feature Branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**:

   - Write your code
   - Add tests
   - Update documentation

3. **Test Your Changes**:

   ```bash
   # Run all tests
   sui move test

   # Run specific tests
   sui move test --filter your_module
   ```

4. **Commit Your Changes**:
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

## Contributing Guidelines

### Types of Contributions

We welcome various types of contributions:

#### 🐛 Bug Fixes

- Fix bugs in existing functionality
- Improve error handling
- Add missing validations

#### ✨ New Features

- Add new smart contract modules
- Implement new pricing models
- Create new integration patterns

#### 📚 Documentation

- Improve existing documentation
- Add code examples
- Create tutorials and guides

#### 🧪 Tests

- Add unit tests
- Create integration tests
- Improve test coverage

#### 🔧 Infrastructure

- Improve build scripts
- Add CI/CD pipelines
- Enhance deployment processes

### Contribution Areas

#### Smart Contracts

- **Core Modules**: `futures_token`, `risk_pool`, `redemption`
- **Support Modules**: `oracle_integration`, `emergency`, `pricing`
- **State Management**: `global_state`

#### Frontend/Web3

- **React Components**: UI components for gas futures
- **Web3 Integration**: Wallet connections and transactions
- **Analytics**: Dashboard and monitoring tools

#### Backend/API

- **REST APIs**: Backend services for gas futures
- **Event Processing**: Real-time event handling
- **Data Analytics**: Market data and statistics

## Code Style

### Move Language Guidelines

#### Naming Conventions

```move
// Modules: snake_case
module gas_futures::futures_token

// Structs: PascalCase
public struct GasFutureToken

// Functions: snake_case
public entry fun mint_token()

// Constants: UPPER_SNAKE_CASE
const EINSUFFICIENT_BALANCE: u64 = 0;
```

#### Code Structure

```move
module gas_futures::example {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    // Constants first
    const EERROR_CODE: u64 = 0;

    // Structs
    public struct ExampleStruct has key {
        id: UID,
        data: u64,
    }

    // Functions
    public entry fun init(ctx: &mut TxContext) {
        // Implementation
    }

    // Private functions
    fun helper_function(): u64 {
        0
    }
}
```

#### Error Handling

```move
// Use descriptive error constants
const EINSUFFICIENT_BALANCE: u64 = 0;
const ETOKEN_EXPIRED: u64 = 1;
const EINVALID_PRICE: u64 = 2;

// Validate inputs early
public entry fun safe_function(
    input: u64,
    ctx: &mut TxContext
) {
    assert!(input > 0, EINVALID_INPUT);
    // Function implementation
}
```

### TypeScript/JavaScript Guidelines

#### Naming Conventions

```typescript
// Classes: PascalCase
class GasFuturesClient

// Functions: camelCase
async function purchaseToken()

// Variables: camelCase
const gasUnits = 1000;

// Constants: UPPER_SNAKE_CASE
const DEFAULT_GAS_BUDGET = 10000000;
```

#### Code Structure

```typescript
// Imports first
import { SuiClient } from "@mysten/sui.js/client";

// Interfaces
interface TokenPurchaseParams {
  gasUnits: number;
  strikePrice: number;
  expiry: number;
}

// Classes
export class GasFuturesClient {
  private client: SuiClient;

  constructor(client: SuiClient) {
    this.client = client;
  }

  // Public methods
  async purchaseToken(params: TokenPurchaseParams) {
    // Implementation
  }

  // Private methods
  private validateParams(params: TokenPurchaseParams) {
    // Validation logic
  }
}
```

## Testing

### Writing Tests

#### Move Tests

```move
#[test_only]
module gas_futures::test_example {
    use sui::test_scenario::{Self, Scenario};
    use gas_futures::futures_token::{Self, GasFutureToken};

    #[test]
    fun test_token_minting() {
        let scenario = test_scenario::begin(@0x1);

        // Setup
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            // Test setup code
        };

        // Test execution
        test_scenario::next_tx(&mut scenario, @0x2);
        {
            // Test implementation
        };

        test_scenario::end(scenario);
    }
}
```

#### TypeScript Tests

```typescript
import { GasFuturesClient } from "../src/GasFuturesClient";

describe("GasFuturesClient", () => {
  let client: GasFuturesClient;

  beforeEach(() => {
    client = new GasFuturesClient(mockSuiClient);
  });

  test("should purchase token successfully", async () => {
    const result = await client.purchaseToken({
      gasUnits: 1000,
      strikePrice: 100,
      expiry: Date.now() + 30 * 24 * 60 * 60 * 1000,
    });

    expect(result.success).toBe(true);
  });
});
```

### Running Tests

```bash
# Run all Move tests
sui move test

# Run specific module tests
sui move test --filter futures_token

# Run TypeScript tests
npm test

# Run tests with coverage
npm run test:coverage
```

## Pull Request Process

### Before Submitting

1. **Ensure Tests Pass**:

   ```bash
   sui move test
   npm test
   ```

2. **Check Code Style**:

   ```bash
   # Format Move code (if formatter available)
   sui move format

   # Lint TypeScript code
   npm run lint
   ```

3. **Update Documentation**:
   - Update README if needed
   - Add API documentation
   - Update user guides

### Creating a Pull Request

1. **Push Your Changes**:

   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**:

   - Go to GitHub and create a new PR
   - Use the PR template
   - Fill in all required information

3. **PR Template**:

   ```markdown
   ## Description

   Brief description of changes

   ## Type of Change

   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Test addition

   ## Testing

   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed

   ## Checklist

   - [ ] Code follows style guidelines
   - [ ] Documentation updated
   - [ ] Tests added/updated
   - [ ] No breaking changes
   ```

### Review Process

1. **Code Review**: All PRs require at least one review
2. **CI/CD Checks**: Automated tests must pass
3. **Security Review**: Security-sensitive changes require additional review
4. **Merge**: Approved PRs are merged by maintainers

## Reporting Issues

### Bug Reports

When reporting bugs, please include:

1. **Environment Information**:

   - Sui CLI version
   - Operating system
   - Network (testnet/mainnet)

2. **Steps to Reproduce**:

   - Clear, step-by-step instructions
   - Expected vs actual behavior

3. **Error Messages**:

   - Full error logs
   - Stack traces if available

4. **Additional Context**:
   - Screenshots if applicable
   - Related issues or PRs

### Feature Requests

For feature requests, please include:

1. **Problem Statement**: What problem does this solve?
2. **Proposed Solution**: How should it work?
3. **Use Cases**: Who would benefit?
4. **Implementation Ideas**: Any technical suggestions?

## Security

### Security Issues

If you discover a security vulnerability, please:

1. **DO NOT** create a public issue
2. **DO** email security@gasfuturesprotocol.com
3. **DO** include detailed information about the vulnerability
4. **DO** wait for acknowledgment before public disclosure

### Security Best Practices

- Follow secure coding practices
- Validate all inputs
- Use proper access controls
- Implement proper error handling
- Avoid exposing sensitive information

## Community

### Getting Help

- **Discord**: Join our community for real-time discussions
- **GitHub Issues**: For bug reports and feature requests
- **Documentation**: Check our comprehensive guides

### Recognition

Contributors will be recognized in:

- **Contributors List**: GitHub contributors page
- **Release Notes**: Mentioned in release announcements
- **Documentation**: Credited in relevant documentation

### Becoming a Maintainer

To become a maintainer:

1. Make significant contributions
2. Demonstrate technical expertise
3. Show commitment to the project
4. Get approval from existing maintainers

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the Gas Futures Protocol! 🚀

_This contributing guide is part of the SUI Foundation Gas Futures Functionality RFP solution._
