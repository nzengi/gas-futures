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
   git clone https://github.com/nzengi/gas-futures.git
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
