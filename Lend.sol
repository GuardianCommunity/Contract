// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./library/Math.sol";

import "./utility/Array.sol";
import "./utility/Ownable.sol";

import "./interface/IBEP20.sol";
import "./interface/AggregatorV3Interface.sol";

contract Lend is Ownable
{
    using Math for uint256;

    struct Vault
    {
        Array Supply;
    }

    mapping(address => Vault) private Storage;

    function Deposit(address token, uint256 amount) public
    {
        require(amount > 0, "Deposit: Amount");

        require(IBEP20(token).allowance(msg.sender, address(this)) >= amount, "Deposit: Approve");

        IBEP20(token).transferFrom(msg.sender, address(this), amount);

        Storage[msg.sender].Supply.Increase(token, amount);
    }

    function Credit() public view returns (uint256)
    {
        (address[] memory Token, uint256[] memory Value) = Storage[msg.sender].Supply.Balance();

        uint256 Result = 0;

        for (uint256 I = 0; I < Token.length; I++)
        {
            int256 Price = AggregatorPrice(Token[I]);

            if (Price == -1)
                continue;

            Result += uint256(Price) * Value[I]; // Fix the correct calculation
        }

        return Result;
    }

    // ChainLink Aggregator Map
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
    event RemovedFromBorrowMap(address indexed token);
}
