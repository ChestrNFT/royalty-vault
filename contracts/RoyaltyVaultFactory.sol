//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import {IRoyaltyVault} from "../interfaces/IRoyaltyVault.sol";
import {RoyaltyVault} from "./RoyaltyVault.sol";

contract RoyaltyVaultFactory {
    address[] public vaults;
    
    event VaultCreated(address vault);

    function createVault(address _collectionContract, address _wethAddress) public returns (address) {
        RoyaltyVault newVault = new RoyaltyVault(_collectionContract,_wethAddress);
        vaults.push(address(newVault));
        emit VaultCreated(address(newVault));
        return address(newVault);
    }

    function setSpliter(address _vault, address _spliter) public {
        IRoyaltyVault(_vault).setSplitter(_spliter);
    }

}