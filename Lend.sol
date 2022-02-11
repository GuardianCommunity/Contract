// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./library/Math.sol";

import "./Oracle.sol";

import "./utility/Ownable.sol";
import "./utility/WhiteList.sol";
import "./utility/VaultArray.sol";

import "./interface/IBEP20.sol";
import "./interface/AggregatorV3Interface.sol";

contract Lend is Ownable, Oracle, WhiteList
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

    function Credit() public view returns (uint256 Result)
    {
        (address[] memory Token, uint256[] memory Value) = Storage[msg.sender].Deposit.Balance();

        for (uint256 I = 0; I < Token.length; I++)
        {
            int256 Price = Oracle.Price(Token[I]);

        }
    }
}
