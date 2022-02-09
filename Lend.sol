// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./library/Math.sol";

import "./utility/Ownable.sol";
import "./utility/WhiteList.sol";
import "./utility/VaultArray.sol";

import "./interface/IBEP20.sol";
import "./interface/AggregatorV3Interface.sol";

contract Lend is Ownable, WhiteList
{
    using Math for uint256;

    // Structure
    struct Vault
    {
        VaultArray Deposit;
    }

    // Storage
    mapping(address => Vault) private Storage;

    // Function
    function Deposit(address token, uint256 amount) public
    {
        require(amount > 0, "Deposit: Amount");

        require(IBEP20(token).allowance(msg.sender, address(this)) >= amount, "Deposit: Approve");

        IBEP20(token).transferFrom(msg.sender, address(this), amount);

        Storage[msg.sender].Deposit.Increase(token, amount);
    }
}

/*
    function PriceBTC() external view returns (uint80 roundID, int price, uint startedAt, uint timeStamp, uint80 answeredInRound)
    {
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x5741306c21795FdCBb9b265Ea0255F499DFe515C);


        (roundID, price, startedAt, timeStamp, answeredInRound) = PriceFeed.latestRoundData();
    }
*/
