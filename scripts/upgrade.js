// scripts/prepare_upgrade.js
async function main() {
    const proxyAddress = '0x0cf7522b72d3eF0FAE78e43DCffF3EaEB033a14a';
   
    const promethium_v2 = await ethers.getContractFactory("MonstersOnTheWayCards");
    console.log("Preparing upgrade...");
    const boxV2Address = await upgrades.prepareUpgrade(proxyAddress, promethium_v2, ["0xc9315D92Fa99FA76047e16D194b6c5CccE128df7"]);
    console.log("PromethiumV2 at:", boxV2Address);
  }
   
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });