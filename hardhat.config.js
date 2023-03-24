const chai = require("chai")
const eth = require("ethereum-waffle")
require('@nomiclabs/hardhat-waffle');

chai.use(eth.solidity);

module.exports = {
  solidity: '0.8.0',
  networks: {
    sepolia: {
      url: 'https://eth-sepolia.g.alchemy.com/v2/rMlBxpd3_3GTFrypMWfp4kjPNQgmr6Pk',
      accounts: ['9406eb97ace8d76d7958a310051ecf9989f56f568c05012fa0b376add952e84b'],
    },
    goreli: {
      url: 'https://eth-goerli.g.alchemy.com/v2/ezFT7gurVy9OCsrKYwKnbb0PI6JgSUiI',
      accounts: ['9406eb97ace8d76d7958a310051ecf9989f56f568c05012fa0b376add952e84b'],
    },
  },
};