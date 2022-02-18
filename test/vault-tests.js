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
    let royaltyVault;
    royaltyTx = await royaltyFactory.createVault(collectionContract,wEth);
    const royaltyVaultTx = await royaltyTx.wait(1)
    const event = royaltyVaultTx.events.find(event => event.event === 'VaultCreated');
    [royaltyVault] = event.args;
    return royaltyVault;
}
  
describe("Creating Royalty Vault", function () {

    let royaltyFactory,wEth,royaltyVault,collectionContract,funder,account1,account2;

    before( async function() {
        [
          funder,
          collectionContract,
        ] = await ethers.getSigners();
    
        wEth = await deployWeth();
        royaltyFactory = await deployRoyaltyFactory();
        royaltyVault = await createVault(royaltyFactory,collectionContract.address,wEth.address);

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

    it("Owner of RoyaltyVault must be RoyaltyFactory", async function () {

        royaltyVaultContract = await (
            await ethers.getContractAt("RoyaltyVault", royaltyVault)
          ).deployed();

        const owner = await royaltyVaultContract.owner();
        expect(owner).to.eq(
            royaltyFactory.address
        );

    });


});