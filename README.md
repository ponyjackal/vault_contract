# Vault

[gitpod]: https://gitpod.io/#https://github.com/PonyJackal/foundry-template
[gitpod-badge]: https://img.shields.io/badge/Gitpod-Open%20in%20Gitpod-FFB45B?logo=gitpod
[gha]: https://github.com/PonyJackal/foundry-template/actions
[gha-badge]: https://github.com/PonyJackal/foundry-template/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

A Solidity project for managing and interacting with a Vault contract, which allows for depositing, withdrawing, and
managing whitelisted ERC20 tokens.

## Overview

The Vault contract is designed to provide a secure and efficient way to handle ERC20 token transactions. It offers
features like depositing and withdrawing tokens, pausing and unpausing contract interactions, and managing a list of
whitelisted tokens.

## Contracts

- `Vault.sol`: Main contract allowing for deposits, withdrawals, and administrative functions.
- `MockERC20.sol`: A mock ERC20 token used for testing purposes.
- Other dependencies and libraries as per project requirements.

### Git Hooks

This template uses [Husky](https://github.com/typicode/husky) to run automated checks on commit messages, and
[Lint Staged](https://github.com/okonet/lint-staged) to automatically format the code with Prettier when making a git
commit.

## Usage

Here's a list of the most frequently needed commands.

### Build

Build the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Deploy

Deploy to Goerli:

```sh
$ make deploy-goerli contract=Vault
```

For instructions on how to deploy to a testnet or mainnet, check out the
[Solidity Scripting tutorial](https://book.getfoundry.sh/tutorials/solidity-scripting.html).

### Format

Format the contracts with Prettier:

```sh
$ yarn prettier
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

### Lint

Lint the contracts:

```sh
$ yarn lint
```

### Test

Run the tests:

```sh
$ forge test
```
