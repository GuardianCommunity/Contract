// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

interface IPoolAsset
{
    function Price() external view returns (int256);
    function Balance() external view returns (uint256);
    function InterestRate() external view returns (uint256);

    function Stake(uint256) external;
    function UnStake(uint256) external;

    event Staked(address indexed Owner, uint256 Amount);
    event UnStaked(address indexed Owner, uint256 Amount);
}
