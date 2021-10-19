const main = async () => {
  const FundMe = await ethers.getContractFactory("FundMe");

  // Start deployment, returning a promise that resolves to a contract object
  const fundMe = await FundMe.deploy();
  console.log("Contract deployed to address:", fundMe.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

//0x3869D75EC32DB9F3936A889f5F7E469b59841DF3