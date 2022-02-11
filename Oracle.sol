// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./interface/AggregatorV3Interface.sol";

abstract contract Oracle
{
    mapping(address => address) private Storage;

    function Add(address token, address oracle) internal
    {
        require(token != address(0), "Add: Token");
        require(oracle != address(0), "Add: Oracle");

        Storage[token] = oracle;

        emit AddToOracle(token, oracle);
    }

    function Remove(address token) internal
    {
        require(token != address(0), "Remove: Token");

        Storage[token] = address(0);

        emit RemoveFromOracle(token);
    }

    function Price(address token) internal view returns (int256 Result)
    {
        address oracle = Storage[token];

        if (oracle == address(0))
        {
            return -1;
        }

        (, Result, , ,) = AggregatorV3Interface(oracle).latestRoundData();
    }

    event RemoveFromOracle(address indexed Oracle);
    event AddToOracle(address indexed Token, address indexed Oracle);
}
