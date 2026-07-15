# Fhish Contracts

![Solidity](https://img.shields.io/badge/Solidity-0.8.20-363636?style=flat-square&logo=solidity)
![Hardhat](https://img.shields.io/badge/Hardhat-3.x-fff100?style=flat-square)

> Solidity building blocks for an fhEVM-style confidential-computation flow — encrypted integer types, a decryption gateway, and ciphertext access control.

## Overview

**Fhish Contracts** is an early-stage set of Solidity contracts that sketch out the on-chain pieces of a Fully Homomorphic Encryption (FHE) workflow, in the spirit of fhEVM-style designs. It provides an encrypted-integer type library, an asynchronous decryption gateway backed by a trusted relayer, and a simple per-ciphertext permission registry.

This is a prototype / lab scaffold: the `FHE` library defines the encrypted-type interface (`euint32`, `ebool`) and the operations a confidential contract would call, but the arithmetic currently runs on the wrapped values rather than on real ciphertexts. It is meant as a starting point for experimenting with the surrounding contract architecture — not a production FHE runtime.

## Features

- **Encrypted integer types** — `euint32` and `ebool` user-defined value types (`FHE.sol`) wrapping `uint256`, with `add`, `sub`, `eq`, `gte`, `asEuint32` (from raw ciphertext bytes), and `decrypt` helpers.
- **Asynchronous decryption gateway** (`FhishGateway.sol`) — `requestDecrypt` records a decryption request (ciphertext handle + callback contract + selector) and emits an event; an off-chain relayer calls `fulfillDecrypt` to deliver the plaintext back to the requesting contract via a callback.
- **Relayer / owner roles** — the gateway owner sets the authorized relayer address; only the relayer may fulfill requests, with a `fulfilled` flag guarding against double-execution.
- **Ciphertext access control** (`FhishAccessControl.sol`) — a per-user, per-ciphertext-handle permission map with `grantPermission`, `revokePermission`, and `hasPermission`.

## Tech Stack

- **Solidity** `0.8.20`
- **Hardhat** `3.x` with `@nomicfoundation/hardhat-toolbox`
- **TypeScript** + `ts-node`
- ESM (`"type": "module"`)

## Getting Started

```bash
# clone
git clone https://github.com/nickthelegend/fhish-contracts.git
cd fhish-contracts

# install dependencies
npm install

# compile the contracts
npx hardhat compile
```

## Project Structure

```
contracts/
  base/
    FhishAccessControl.sol   # per-user / per-ciphertext permission registry
    FhishGateway.sol         # async decryption gateway + relayer callbacks
  lib/
    FHE.sol                  # euint32 / ebool types and mock FHE operations
hardhat.config.js            # Hardhat config (solidity 0.8.20)
package.json                 # deps and project metadata
```

## Status

Work in progress. The contracts capture the intended interface surface; the FHE operations are placeholders and the gateway relayer flow is a reference implementation for further development.

---

Built by [**nickthelegend**](https://github.com/nickthelegend) · [nickthelegend.tech](https://nickthelegend.tech)
