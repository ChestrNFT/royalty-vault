//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import {IRoyaltyVault} from "../interfaces/IRoyaltyVault.sol";
import {RoyaltyVault} from "./RoyaltyVault.sol";

contract RoyaltyVaultFactory {
    
    address[] public vaults;
    
    // **** Events ****

    event VaultCreated(address vault);

    /**
     * @dev Create RoyaltyVault
     * @param _collectionContract address of the collection contract.
     * @param _wethAddress address of the WETH contract.
     * @return address of the newly created RoyaltyVault.
     */

    function createVault(address _collectionContract, address _wethAddress) public returns (address) {
        RoyaltyVault newVault = new RoyaltyVault(_collectionContract,_wethAddress);
        vaults.push(address(newVault));
        emit VaultCreated(address(newVault));
        return address(newVault);
    }

    /**
    * @dev set splitter for vault.
    * @param _vault address to vault to set splitter.
    * @param _splitter address which needs to be set.
    */
    function setSpliter(address _vault, address _splitter) public {
        IRoyaltyVault(_vault).setSplitter(_splitter);
    }

}