// test/Box.js
// Load dependencies
const { expect } = require('chai');
 
let Box;
let box;
 
// Start test block
describe('Box', function () {
  beforeEach(async function () {
    Box = await ethers.getContractFactory("Promethium");
    box = await upgrades.deployProxy(Box, ["0xeac9852225Aa941Fa8EA2E949e733e2329f42195"], {initializer: 'initialize'});
    await box.deployed();
  });
 
  // Test case
  it('retrieve returns a value previously stored', async function () {
    // Test if the returned value is the same one
    // Note that we need to use strings to compare the 256 bit integers
    expect((await box.decimals())).to.equal(6);
  });
});