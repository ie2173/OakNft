# Oakland Community ERC721 NFT Project

## Overview

The Oakland Community ERC721 NFT Project aims to raise funds for the Oakland community by minting non-fungible tokens (NFTs) created by talented artists from Oakland. This documentation provides a step-by-step guide on how to create and deploy the ERC721 smart contract, mint NFTs, and manage the project.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Smart Contract Development](#smart-contract-development)
- [Testing](#Testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before you begin, make sure you have the following prerequisites:

#### Foundry

Foundryup is the Foundry toolchain installer. You can find more about it here.

Open your terminal and run the following command:

`curl -L https://foundry.paradigm.xyz | bash`

## Getting Started

To get started with the Oakland Community ERC721 NFT Project, follow these steps:

1. Clone the project repository: `git clone <repository-url>`
2. Install project dependencies: `forge install`
3. compile the smart contracts `forge build`
4. Configure the project settings in the `foundry.toml` file.

## Smart Contract Development

The smart contract development process involves creating an ERC721 contract that supports the creation and management of NFTs. The following steps outline the development process:

1. Define the contract structure, including the necessary data structures and functions.
2. Implement the ERC721 standard functions, such as `balanceOf`, `safeTranfer`, `TransferFrom`, etc.
3. Add additional project-specific functionality, such as metadata management, royalty distribution, etc.
4. Test the smart contract using a local development environment or testnet.
5. Optimize and secure the contract code as needed.

## Deployment

To deploy the ERC721 smart contract, follow these steps:

1. Compile the smart contract code.
2. Select the desired Ethereum network for deployment (testnet or mainnet).
3. Deploy the smart contract using a deployment script
4. Verify the contract on the chosen blockchain explorer.
5. Record the deployed contract address for future reference.

## Testing
To run tests for your ERC721 project using Foundry and Truffle, follow these steps:

1. Open a terminal or command prompt.

2. Navigate to the root directory of your ERC721 project, where the `Foundry.toml` file is located.

3. Use the following Foundry command to execute the tests:
   ` forge test`

## Contributing

Contributions to the Oakland Community ERC721 NFT Project are welcome! To contribute, follow these steps:

1. Fork the project repository.
2. Create a new branch for your contribution: `git checkout -b my-contribution`.
3. Make the necessary changes and additions.
4. Commit and push your changes: `git commit -am 'Add my contribution' && git push origin my-contribution`.
5. Open a pull request in the original repository.

## License

The Oakland Community ERC721 NFT Project is licensed under the [MIT License](LICENSE).
