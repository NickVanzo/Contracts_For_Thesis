// scripts/deploy.js
//last deploy address: 
async function main() {
    const Cards = await ethers.getContractFactory("MonstersOnTheWayCards");
    console.log("Deploying Cards...");
    const cards = await upgrades.deployProxy(Cards, ["0x80860D8d26ccd5E225A5fF9bA8031B41bD484E2F"], { initializer: 'initialize' });
    console.log("Cards deployed to:", cards.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });