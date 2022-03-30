// scripts/prepare_upgrade.js
async function main(deployer) {
    const proxyAddress = '0x198a84433369E807E6E9b6987C0934057647279C';
   
    const promethium_v2 = await ethers.getContractFactory("Promethium");
    console.log("Preparing upgrade...");
    const boxV2Address = await upgrades.upgradeProxy(proxyAddress, promethium_v2, { deployer });
    console.log("Updated contract at:", boxV2Address);
  }
   
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });