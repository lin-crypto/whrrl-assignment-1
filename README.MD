# Assignment from Whrrl Fintech Solutions (Task 1)

Create a simple ERC721 token on Ethereum, deploy it on Rinkeby and then bridge the same with MATIC’s Mumbai testnet.

## Deploy Contracts

Rename `.env.example` with `.env`.

Add PRIVATE_KEY, ETHERSCAN_API_KEY and POLYGONSCAN_API_KEY in `.env`.

### Deploy on Goerli
`npx hardhat run ./scripts/deploy.js --network goerli`

`npx hardhat verify --network goerli [BridgeAddress] [NFTAddress]`

https://goerli.etherscan.io/address/0xb5583B545bc113163a531B5448358e24fdAa9AD5#code

### Deploy on Mumbai

`npx hardhat run ./scripts/deploy.js --network mumbai`

`npx hardhat verify --network mumbai [BridgeAddress] [NFTAddress]`

https://mumbai.polygonscan.com/address/0x658840e03f390c928B68373A09516Ad13E562B4C#code