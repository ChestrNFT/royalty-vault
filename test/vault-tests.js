const { expect } = require("chai");
const { ethers } = require("hardhat");

const deployRoyaltyFactory = async () => {
    const RoyaltyVaultFactoryContract = await ethers.getContractFactory("RoyaltyVaultFactory");
    const royaltyVaultFactory = await RoyaltyVaultFactoryContract.deploy();
    return await royaltyVaultFactory.deployed();
};

const deployWeth = async () => {
    const myWETHContract = await ethers.getContractFactory("WETH");
    const myWETH = await myWETHContract.deploy();
    return await myWETH.deployed();
};

const createVault =async (royaltyFactory,collectionContract,wEth)=>{
    royaltyVaultAddress=await royaltyFactory.createVault(collectionContract,wEth);
    return await (await ethers.getContractAt("RoyaltyVault", royaltyVaultAddress)).deployed();
}
  
describe("Creating Royalty Vault", function () {

    let royaltyFactory,wEth,royaltyVault,collectionContract,funder,account1,account2;

    before( async function() {
        [
          funder,
          account1,
          account2,
          collectionContract,
        ] = await ethers.getSigners();
    
        claimers = [account1, account2];
    
        wEth = await deployWeth();
        royaltyFactory = await deployRoyaltyFactory();

        royaltyTx = await royaltyFactory.createVault(collectionContract.address,wEth.address);
        const royaltyVaultTx = await royaltyTx.wait(1)
        const event = royaltyVaultTx.events.find(event => event.event === 'VaultCreated');
        [royaltyVault] = event.args;

    });

  it("Should return correct RoyaltVault balance", async function () {
    
    await wEth
          .connect(funder)
          .transfer(royaltyVault, ethers.utils.parseEther("1"));
    const balance = await wEth.balanceOf(royaltyVault);

    expect(await balance).to.eq(
        ethers.utils.parseEther("1").toString()
    );

  });

  it("Should return correct RoyaltVault balance", async function () {
    
    await wEth
          .connect(funder)
          .transfer(royaltyVault, ethers.utils.parseEther("1"));
    const balance = await wEth.balanceOf(royaltyVault);

    expect(await balance).to.eq(
        ethers.utils.parseEther("1").toString()
    );
    
  });

});