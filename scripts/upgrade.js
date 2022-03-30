// scripts/prepare_upgrade.js
async function main() {
    const proxyAddress = '0xa1a0bcffcbe114462986a6c177ab617dd9b1c77c';
   
    const promethium_v2 = await ethers.getContractFactory("MonstersOnTheWayCards");
    console.log("Preparing upgrade...");
    const boxV2Address = await upgrades.prepareUpgrade(proxyAddress, promethium_v2);
    console.log("PromethiumV2 at:", boxV2Address);
  }
   
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });