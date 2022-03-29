// scripts/deploy.js
//last deploy address: 
async function main() {
    const Promethium = await ethers.getContractFactory("Promethium");
    console.log("Deploying Promethium...");
    const promethium = await upgrades.deployProxy(Promethium, { initializer: 'initialize' });
    console.log("Promethium deployed to:", promethium.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });