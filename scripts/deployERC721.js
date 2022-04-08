// scripts/deploy.js
async function main() {
    const Box = await ethers.getContractFactory("MonstersOnTheWayCardsV2");
    console.log("Deploying ERC721 contract...");
    const opn = require('opn');
    const trx = await upgrades.deployProxy(Box, ["0x09849b1ca45d647800f2c8f95e6adef132983000", "0xeac9852225Aa941Fa8EA2E949e733e2329f42195"], { initializer: 'initialize' });
    opn(`https://rinkeby.etherscan.io/tx/${trx.deployTransaction.hash}`);
    console.log("ERC721 contract trx...", trx);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });