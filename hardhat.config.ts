/**
 * @type import('hardhat/config').HardhatUserConfig
 */

import * as dotenv from 'dotenv'
dotenv.config()

import '@nomiclabs/hardhat-waffle'
import '@nomiclabs/hardhat-ethers'
import 'hardhat-gas-reporter'
import './tasks'

module.exports = {
  solidity: '0.8.0',
  networks: {
    // rinkeby: {
    //   url: process.env.INFURA_ENDPOINT,
    //   accounts: [process.env.RINKEBY_PRIVATE_KEY]
    // }
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 5
    }
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts'
  }
}
