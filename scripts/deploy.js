const main = async () => {
  let transactionsFactory = await hre.ethers.getContractFactory("CertificateStore");
  let transactionsContract = await transactionsFactory.deploy();

  await transactionsContract.deployed();

  console.log("Certificate Contract Deployed address: ", transactionsContract.address);
  // transactionsFactory = await hre.ethers.getContractFactory("SemesterStore");
  // transactionsContract = await transactionsFactory.deploy();

  // await transactionsContract.deployed();

  // console.log("Semester Contract Deployed address: ", transactionsContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();