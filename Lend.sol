// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./library/Math.sol";

import "./utility/Ownable.sol";
import "./utility/VaultArray.sol";

import "./interface/IBEP20.sol";
import "./interface/AggregatorV3Interface.sol";


contract Lend is Ownable
{
    using Math for uint256;

    struct Vault
    {
        VaultArray Deposit;
    }


    mapping(address => Vault) private Storage;

    function Deposit(address token, uint256 amount) public
    {
        require(amount > 0, "Deposit: Amount");

        require(IBEP20(token).allowance(msg.sender, address(this)) >= amount, "Deposit: Approve");

        IBEP20(token).transferFrom(msg.sender, address(this), amount);

        Storage[msg.sender].Deposit.Increase(token, amount);
    }

    function Credit() public view returns (uint256)
    {
        (address[] memory Token, int256[] memory Value) = Storage[msg.sender].Deposit.Balance();

        uint256 Result = 0;

        for (uint256 I = 0; I < Token.length; I++)
        {
            int256 Price = AggregatorPrice(Token[I]);

            if (Price == -1)
                continue;

            Result = Result + (uint256) (Price * Value[I]);
        }

        return Result;
    }

    // ChainLink Aggregator
    mapping(address => address) private AggregatorMap;

    function AddToAggregator(address token, address oracle) external
    {
        require(token != address(0), "AddToAggregator: Token");
        require(oracle != address(0), "AddToAggregator: Oracle");

        AggregatorMap[token] = oracle;

        emit AddedToAggregator(token, oracle);
    }

    function RemoveFromAggregator(address token) external
    {
        require(token != address(0), "RemoveFromAggregator: Token");

        delete AggregatorMap[token];

        emit RemovedFromAggregator(token);
    }

    function AggregatorPrice(address token) public view returns (int256 Result)
    {
        address oracle = AggregatorMap[token];

        if (oracle == address(0))
        {
            return -1;
        }

        (, Result, , ,) = AggregatorV3Interface(oracle).latestRoundData();
    }

    event RemovedFromAggregator(address indexed Oracle);
    event AddedToAggregator(address indexed Token, address indexed Oracle);

    // Oracle
    mapping(address => bool) private OracleMap;

    function AddToOracle(address account) external
    {
        OracleMap[account] = true;

        emit AddedToOracle(account);
    }

    function RemoveFromOracle(address account) external
    {
        OracleMap[account] = false;

        emit RemovedFromOracle(account);
    }

    function IsInOracle(address account) public view returns(bool)
    {
        return OracleMap[account];
    }

    event AddedToOracle(address indexed account);
    event RemovedFromOracle(address indexed account);
}
