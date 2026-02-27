# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Foundry-based Ethereum smart contract project implementing a provably random raffle contract. The contract uses Chainlink VRF (Verifiable Random Function) for randomness and Chainlink Automation for triggering the draw.

## Development Environment

### Foundry Commands
- **Build**: `forge build`
- **Test**: `forge test` (use `-vvv` for verbose output as shown in CI)
- **Format**: `forge fmt`
- **Gas Snapshots**: `forge snapshot`
- **Local Node**: `anvil`
- **Deploy**: `forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>`
- **Cast**: Use `cast` for interacting with contracts and chain data

### CI/CD
The project uses GitHub Actions with a workflow (`.github/workflows/test.yml`) that:
- Runs `forge fmt --check` for formatting
- Runs `forge build --sizes` for compilation
- Runs `forge test -vvv` for testing with verbose output

## Project Structure

### Key Directories
- `src/` - Contains the main smart contract `Raffle.sol`
- `test/` - Test directory (currently empty)
- `script/` - Deployment scripts directory (currently empty)
- `lib/` - Dependencies including:
  - `forge-std/` - Foundry standard library
  - `chainlink-brownie-contracts/` - Chainlink contracts with remapping `@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/`

### Configuration
- `foundry.toml` - Foundry configuration with remappings for Chainlink contracts
- `.gitignore` - Ignores cache/, out/, and development broadcast logs

## Smart Contract Architecture

### Raffle Contract (`src/Raffle.sol`)
The main contract implements a raffle system with the following key components:

**State Variables:**
- `i_entranceFee` - Immutable entrance fee (currently hardcoded to 0.01 ether in constructor)
- `i_interval` - Time interval between raffle draws
- `i_vrfCoordinator` - Chainlink VRF coordinator interface
- `s_players` - Array of player addresses
- `s_lastTimeStamp` - Timestamp of last draw

**Key Functions:**
- `enterRaffle()` - Allows users to enter by paying the entrance fee
- `pickWinner()` - Picks a random winner using Chainlink VRF (currently incomplete)
- `getEntranceFee()` - Getter for entrance fee

**Chainlink Integration:**
- Uses `VRFCoordinatorV2Interface` for verifiable randomness
- Constants: `REQUEST_CONFIRMATIONS = 3`, `NUM_WORDS = 1`
- VRF parameters: `i_gasLane`, `i_subscriptionId`, `i_callbackGasLimit`

**Events:**
- `EnteredRaffle(address indexed player)` - Emitted when a player enters

**Errors:**
- `Raffle_NotEnoughEthSent()` - Reverts if insufficient ETH sent

## Development Notes

### Contract Layout
The contract follows a structured layout:
1. SPDX license and pragma
2. Imports
3. Errors
4. Interfaces, libraries, contracts
5. Type declarations
6. State variables
7. Events
8. Modifiers
9. Functions (constructor, receive, fallback, external, public, internal, private, view/pure)

### Current Implementation Status
Based on git history and current code:
- Basic raffle entry functionality is implemented
- Chainlink VRF integration is started but incomplete (missing callback function)
- Chainlink Automation integration is planned but not implemented
- Test suite is not yet created

### Dependencies
- Chainlink contracts are imported via remapping: `@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/`
- Uses Solidity ^0.8.19

## Common Tasks

### Running Tests
```bash
forge test
forge test -vvv  # Verbose output (used in CI)
```

### Building and Formatting
```bash
forge build
forge fmt
```

### Deployment
Follow the pattern in README.md:
```bash
forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Working with Local Node
```bash
anvil  # Start local Ethereum node
```

## Important Considerations

1. The contract currently has a hardcoded `i_entranceFee = 0.01 ether` in the constructor that overrides the parameter
2. The `pickWinner()` function is incomplete - it requests random words but doesn't handle the callback
3. No tests exist yet - test files should be created in the `test/` directory
4. Deployment scripts should be created in the `script/` directory
5. Chainlink Automation integration needs to be implemented for automatic draw triggering