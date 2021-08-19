import { ethers } from 'hardhat'
import { BigNumber, Contract, Signer } from 'ethers'
import { expect } from 'chai'
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import { Interface } from 'ethers/lib/utils'

describe('Trie', function () {
  let Trie: Contract
  let owner: SignerWithAddress
  let iface: Interface

  before(async () => {
    const signers = await ethers.getSigners()
    owner = signers[0]

    const TrieFactory = await ethers.getContractFactory('Trie')
    Trie = await TrieFactory.deploy()
    const TrieInterface = TrieFactory.interface
    await Trie.deployed()

    iface = TrieInterface
  })

  it('should complete round', async function () {
    for (let i = 0; i < 32; i++) {
      let transaction = await Trie.find(30)
      let receipt = await transaction.wait()
    }

    const filter = Trie.filters.Found(null)
    const query = await Trie.queryFilter(filter)
    // console.log(query)
    for (const log of query) {
      console.log(iface.parseLog(log).args.m.toString())
    }
    expect(true).to.be.true
  })
})
