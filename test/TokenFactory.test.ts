const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('BittensorTokenFactory', function () {
  let TokenFactory, tokenFactory, owner

  beforeEach(async function () {
    ;[owner] = await ethers.getSigners()

    TokenFactory = await ethers.getContractFactory('BittensorTokenFactory')
    tokenFactory = await TokenFactory.deploy()
  })

  it('Should create a new token', async function () {
    const tx = await tokenFactory.createToken(
      'Test Token',
      'TST',
      ethers.utils.parseEther('1000'),
      true, // mintable
      true // burnable
    )

    const receipt = await tx.wait()
    const tokenCreatedEvent = receipt.events?.find(
      (e) => e.event === 'TokenCreated'
    )

    expect(tokenCreatedEvent).to.exist
    expect(tokenCreatedEvent.args.creator).to.equal(owner.address)
  })
})
