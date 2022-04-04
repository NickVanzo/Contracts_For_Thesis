// scripts/prepare_upgrade.js
async function main(deployer) {
    const proxyAddress = '0x44a1ba61618d9218e6afe75ad1a14729e9325e5a';
   
    const promethium_v2 = await ethers.getContractFactory("MonstersOnTheWayCardsV2");
    console.log("Preparing upgrade...");
    const boxV2Address = await upgrades.upgradeProxy(proxyAddress, promethium_v2, { deployer });
    console.log("Updated contract at:", boxV2Address.address);
  }
   
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });