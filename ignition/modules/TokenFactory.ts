const hre = require('hardhat')

async function main() {
  const [deployer] = await hre.ethers.getSigners()
  console.log("🚀 ~ main ~ deployer:", deployer)

  console.log("Deploying contracts with the account:", deployer.address)

  const TokenFactory = await hre.ethers.getContractFactory('TokenFactory')
  const tokenFactory = await TokenFactory.deploy()

  await tokenFactory.waitForDeployment()
  console.log('TokenFactory deployed to:', tokenFactory.target)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
