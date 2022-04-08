// scripts/deploy.js
async function main() {
    const Box = await ethers.getContractFactory("Promethium");
    console.log("Deploying ERC20 contract...");
    const opn = require('opn');
    const trx = await upgrades.deployProxy(Box, ["0xeac9852225Aa941Fa8EA2E949e733e2329f42195"], { initializer: 'initialize' });
    opn(`https://rinkeby.etherscan.io/tx/${trx.deployTransaction.hash}`);
    console.log("ERC20 contract trx...", trx);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });