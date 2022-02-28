// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IVaultFactory {
    function royaltyVault() external returns (address);

    function splitterProxy() external returns (address);

    function royaltyAsset() external returns (address);
}
