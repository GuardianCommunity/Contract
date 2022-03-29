// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

interface ICollateralAsset
{
    function Price() external view returns (int256);
    function Balance() external view returns (uint256);
    function Collateral() external view returns (uint256);
    function BalanceAsUSD() external view returns (uint256);

    function Enable() external;
    function Disable() external;

    function Deposit(uint256) external;
    function Withdraw(uint256) external;

    event Deposited(address indexed Owner, uint256 Amount);
    event Withdrawn(address indexed Owner, uint256 Amount);
}
