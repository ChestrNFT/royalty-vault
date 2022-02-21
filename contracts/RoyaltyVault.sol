//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import {IRoyaltyVault} from "../interfaces/IRoyaltyVault.sol";
import {ISplitter} from "../interfaces/ISplitter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RoyaltyVault is IRoyaltyVault, ERC165, Ownable {

    address private splitter;
    address public collectionContract;
    address public wethAddress;

    event SentToSplitter(address indexed splitter, uint256 amount);
    
    /**
     * @dev RoyaltyVault Constructor
     * @param _collectionContract address of the collection contract
     * @param _wethAddress address of the WETH contract
     */
    constructor(
        address _collectionContract, 
        address _wethAddress
    ) {
        collectionContract = _collectionContract;
        wethAddress = _wethAddress;
    }

    /**
     * @dev Getting Collection Contract of Vault.
     */
    function getCollectionContract() public view override returns (address) {
        return collectionContract;
    }

    /**
     * @dev Getting Splitter for Vault.
     */
    function getSplitter() public view override returns (address){
        return splitter;
    }
    /**
     * @dev Getting WETH balance of Vault.
     */
    function getVaultBalance() public view override returns (uint256){
        return IERC20(wethAddress).balanceOf(address(this));
    }

    /**
     * @dev Send accumulated royalty to splitter.
     */
    function sendToSplitter() external override {
        uint256 balanceOfVault = getVaultBalance();

        require(balanceOfVault > 0,"Vault has no WETH to send");
        require(splitter != address(0),"Splitter is not set");
        require(IERC20(wethAddress).transfer(splitter, balanceOfVault) == true, "Failed to transfer WETH to splitter");
        require(ISplitter(splitter).incrementWindow(balanceOfVault) == true, "Failed to increment splitter window");
        
        emit SentToSplitter(splitter, balanceOfVault);
    }

    /**
     * @dev Set Splitter address to RoyaltyVault.
     * @param _splitter Address of Splitter.
     */
    function setSplitter(address _splitter) external override onlyOwner {
        splitter = _splitter;
    }

    /**
     * @dev Checks for support of IRoyaltyVault.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IRoyaltyVault,ERC165) returns (bool) {
        return interfaceId == type(IRoyaltyVault).interfaceId;
    }
    
}