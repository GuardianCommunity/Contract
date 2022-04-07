// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface AggregatorV3Interface
{
    function decimals() external view returns (uint8);
    function version() external view returns (uint256);
    function description() external view returns (string memory);
    function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
    function getRoundData(uint80 RoundID) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}
