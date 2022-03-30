// scripts/deploy.js
//last deploy address: 
async function main() {
    const Cards = await ethers.getContractFactory("MonstersOnTheWayCardsV2");
    console.log("Deploying Cards...");
    const cards = await upgrades.deployProxy(Cards, ["0x198a84433369E807E6E9b6987C0934057647279C", "0xeac9852225Aa941Fa8EA2E949e733e2329f42195"], { initializer: 'initialize' });
    console.log("Cards deployed to:", cards.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });