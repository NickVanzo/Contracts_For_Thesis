// scripts/deploy.js
//last deploy address: 
async function main() {
    const Cards = await ethers.getContractFactory("MonstersOnTheWayCards");
    console.log("Deploying Cards...");
    const cards = await upgrades.deployProxy(Cards, ["0x9E1536De3b891eCCD666295D8576082250Ad97E5", "0xeac9852225Aa941Fa8EA2E949e733e2329f42195"], { initializer: 'initialize' });
    console.log("Cards deployed to:", cards.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });