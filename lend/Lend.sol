// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "../library/Math.sol";
import "../library/Ownable.sol";
import "../library/WhiteList.sol";

import "../interface/IBEP20.sol";
import "../interface/AggregatorV3Interface.sol";

contract Core is Ownable, WhiteList
{
    using Math for uint256;

    struct Vault
    {
        mapping(IBEP20 => uint256) Borrow;
        mapping(IBEP20 => uint256) Deposit;
    }

    mapping(address => Vault) private Storage;

    function Deposit(IBEP20 token, uint256 amount) public
    {
        require(amount > 0, "Deposit: Amount");
        require(token.allowance(msg.sender, address(this)) >= amount, "Deposit: Approve");

        token.transferFrom(msg.sender, address(this), amount);

        Storage[msg.sender].Deposit[token] = Storage[msg.sender].Deposit[token].Add(amount);
    }

/*
    function Borrow(IBEP20 token, uint256 amount) public
    {
        require(amount > 0, "Borrow: Amount");
        require(IsInWhiteList(address(token)), "Borrow: WhiteList");
    }
*/

    function PriceBTC() external view returns (uint80 roundID, int price, uint startedAt, uint timeStamp, uint80 answeredInRound)
    {
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x5741306c21795FdCBb9b265Ea0255F499DFe515C);


        (roundID, price, startedAt, timeStamp, answeredInRound) = PriceFeed.latestRoundData();
    }
}
