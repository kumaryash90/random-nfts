require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.7",
  paths: {
    sources: './src'
  },
  networks: {
    rinkeby: {
      url: process.env.ALCHEMY_RINKEBY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
