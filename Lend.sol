// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./interface/IBEP20.sol";
import "./interface/IAdministrator.sol";
import "./interface/AggregatorV3Interface.sol";

import "./library/Math.sol";

contract Lend
{
    using Math for uint256;

    uint256 private immutable FACTOR;

    address private immutable TOKEN;
    address private immutable ORACLE;
    address private immutable TREASUERY;

    constructor()
    {
        FACTOR = 10;

        TOKEN = address(0);
        ORACLE = address(0);
        TREASUERY = address(0);
    }

    mapping(address => uint256) private SupplyStorage;

    function Supply(uint256 amount) external
    {
        require(IBEP20(TOKEN).allowance(msg.sender, address(this)) >= amount, "Supply: Approve");

        SupplyStorage[msg.sender] = SupplyStorage[msg.sender].Add(amount);

        IBEP20(TOKEN).transferFrom(msg.sender, address(this), amount);
    }

    function SupplyAsUSD() public view returns (uint256)
    {
        (, int256 Price, , ,) = AggregatorV3Interface(ORACLE).latestRoundData();

        return uint256(Price) * SupplyStorage[msg.sender]; 
    }




















/*
    // Status
    bool private BorrowStatus;

    function SetBorrowStatus(bool status) external OnlyOwner
    {
        BorrowStatus = status;

        emit BorrowStatusChanged(status);
    }

    event BorrowStatusChanged(bool status);

    // Aggregator Map
    mapping(address => address) private AggregatorMap;

    function AddToAggregatorMap(address token, address oracle) external OnlyOwner
    {
        AggregatorMap[token] = oracle;

        emit AddedToAggregatorMap(token, oracle);
    }

    function RemoveFromAggregator(address token) external OnlyOwner
    {
        delete AggregatorMap[token];

        emit RemovedFromAggregatorMap(token);
    }

    function AggregatorPrice(address token) public view returns (int256 Result)
    {
        address oracle = AggregatorMap[token];

        if (oracle == address(0))
            return -1;

        (, Result, , ,) = AggregatorV3Interface(oracle).latestRoundData();
    }

    event RemovedFromAggregatorMap(address indexed oracle);
    event AddedToAggregatorMap(address indexed token, address indexed oracle);

    // Borrow Map
    mapping(address => bool) private BorrowMap;

    function AddToBorrowMap(address token) external OnlyOwner
    {
        BorrowMap[token] = true;

        emit AddedToBorrowMap(token);
    }

    function RemoveFromBorrowMap(address token) external OnlyOwner
    {
        BorrowMap[token] = false;

        emit RemovedFromBorrowMap(token);
    }

    function IsInBorrowMap(address token) public view returns(bool)
    {
        return BorrowMap[token];
    }

    event AddedToBorrowMap(address indexed token);
    event RemovedFromBorrowMap(address indexed token);*/
}
