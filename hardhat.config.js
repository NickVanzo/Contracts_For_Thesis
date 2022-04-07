/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-etherscan");


module.exports = {
  solidity: "0.8.2",
  networks: {
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
      accounts: {mnemonic: process.env.MNEMONIC_WALLET},
      gas: 210000000,
      gasPrice: 90000000000
    },
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY_WALLET_RINKEBY]
    }
  },
  etherscan: {
    apiKey: process.env.POLYGON_API_KEY
  }
};
