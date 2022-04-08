// scripts/prepare_upgrade.js
async function main() {
  const proxyAddress = '0xa60c65d55bb67174cd84a5d3fdf69cb6501309e1';
  const opn = require('opn');
  const BoxV2 = await ethers.getContractFactory("MonstersOnTheWayCardsV2");
  console.log("Preparing upgrade...");
  const boxV2Address = await upgrades.upgradeProxy(proxyAddress, BoxV2);
  opn(`https://rinkeby.etherscan.io/tx/${boxV2Address.deployTransaction.hash}`);
  console.log("ERC721 transaction at:", boxV2Address.deployTransaction.hash);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });