// migrations/2_deploy_box.js
const Promethium = artifacts.require('Promethium');
 
const { deployProxy } = require('@openzeppelin/truffle-upgrades');
 
module.exports = async function (deployer) {
    let trx = await deployProxy(Promethium, ["0xeac9852225Aa941Fa8EA2E949e733e2329f42195"], { deployer, initializer: 'initialize' });
    console.log(trx);
};