// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IRoyaltyVault {
    function getCollectionContract() external view returns (address);
    function getSplitter() external view returns (address);
    function getVaultBalance() external view returns (uint256);
    function sendToSplitter() external ;
    function setSplitter(address _splitter) external;
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
