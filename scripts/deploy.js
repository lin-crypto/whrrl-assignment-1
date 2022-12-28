const { ethers } = require("hardhat");

async function main() {
  let factory = await ethers.getContractFactory("WhrrlNFT");
  const contractNFT = await factory.deploy();
  await contractNFT.deployed();
  console.log(contractNFT.address);

  factory = await ethers.getContractFactory("WhrrlNFTBridge");
  const contractBridge = await factory.deploy(contractNFT.address);
  await contractBridge.deployed();
  console.log(contractBridge.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
