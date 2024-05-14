# Smart Contract Mastery: The Complete Solidity Guide

This resource contains three projects introduced in the Udemy course [Smart Contract Mastery: The Complete Solidity Guide.](https://www.udemy.com/course/smart-contract-mastery-the-complete-solidity-guide-for-2023/)

## Projects

1. **Voting Project**
   - Description: A decentralized voting application built on the Ethereum blockchain, allowing users to create proposals, vote, and delegate their voting power to other users.

2. **Create Your Own Cryptocurrency**
   - Description: A project that demonstrates how to create your own cryptocurrency token on the Ethereum blockchain, including features like minting, burning, and transferring tokens.

3. **Crypto Bank**
   - Description: A decentralized banking application built on the Ethereum blockchain, enabling users to deposit, withdraw, and transfer funds securely.

## Getting Started

To get started with any of the projects, follow these steps:

- Navigate to the project directory after cloning the repository:
  ```bash
  cd Solidity-Learning-Resources/smart-contract-mastery-the-complete-solidity-guide/<project-directory>
  ```
- Install the project dependencies:
  ```bash
  npm install
  ```
- Compile the Solidity contracts:
  ```bash
  npx hardhat compile
  ```

- Run the tests (if available):
  ```bash
  npx hardhat test
  ```

## Deploying Contracts

To deploy the contracts to a specific network, you'll need to configure the network settings in the `hardhat.config.ts` file. Once the network is configured, you can deploy the contracts using the following command:
  ```bash
  npx hardhat run scripts/deploy.ts --network <network-name>
  ```
Copy code
Replace `<network-name>` with the name of the network you want to deploy to (e.g., `localhost`, `goerli`, `mainnet`).


## License

This project is licensed under the [MIT License](LICENSE).