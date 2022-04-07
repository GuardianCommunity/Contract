// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "./IPoolAsset.sol";

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

contract PoolAsset is IPoolAsset
{
    uint256 private constant CONTRACT_INTEREST_RATE = 65;
    address private constant CONTRACT_ASSET = address(0);
    address private constant CONTRACT_ORACLE = address(0);
    address private constant CONTRACT_FACTORY = address(0);
    address private constant CONTRACT_ADMINISTRATOR = address(0);

    uint256 private AssetSupply;
    uint256 private AssetBorrow;

    mapping(address => uint256) private AssetBalance;

    function Price() override external view returns (int256 Result)
    {
        (, Result, , ,) = AggregatorV3Interface(CONTRACT_ORACLE).latestRoundData();
    }

    function Balance() override external view returns (uint256)
    {
        return AssetBalance[msg.sender];
    }

    function InterestRate() override external view returns (uint256)
    {
        return CONTRACT_INTEREST_RATE - (((AssetSupply - AssetBorrow ) / 100) * CONTRACT_INTEREST_RATE);
    }

    function Stake(uint256 amount) override external
    {
        require(IBEP20(CONTRACT_ASSET).allowance(msg.sender, address(this)) >= amount, "Stake: Approve");

        IBEP20(CONTRACT_ASSET).transferFrom(msg.sender, address(this), amount);

        AssetBalance[msg.sender] += amount;

        emit Staked(msg.sender, amount);
    }

    function UnStake(uint256 amount) override external
    {
        require(AssetBalance[msg.sender] >= amount, "UnStake: Amount");

        require((AssetSupply - AssetBorrow) >= amount, "UnStake: Low Supply");

        IBEP20(CONTRACT_ASSET).transfer(msg.sender, amount);



        unchecked
        {
            AssetBalance[msg.sender] -= amount;
        }

        emit UnStaked(msg.sender, amount);
    }

    modifier FactoryOnly()
    {
        require(CONTRACT_FACTORY == msg.sender, "FactoryOnly: Factory Only");

        _;
    }

    modifier AdminOnly()
    {
        require(IAdministrator(CONTRACT_ADMINISTRATOR).IsAdmin(msg.sender), "AdminOnly: Admin Only");

        _;
    }
}
