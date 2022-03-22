// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

interface ICollateralAsset
{
    function Enable() external;
    function Disable() external;

    function Deposit(uint256 Amount) external;
    function Withdraw(uint256 Amount) external;

    function Price() external view returns (int256);
    function Collateral() external view returns (uint256);

    event Enabled();
    event Disabled();

    event Deposited(uint256 Amount);
    event Withdrawn(uint256 Amount);
}
