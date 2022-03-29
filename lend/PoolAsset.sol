// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "./IPoolAsset.sol";

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

contract PoolAsset is IPoolAsset
{
    address private immutable CONTRACT_ASSET;
    address private immutable CONTRACT_ORACLE;
    address private immutable CONTRACT_FACTORY;
    uint256 private immutable CONTRACT_INTEREST_RATE;
    address private immutable CONTRACT_ADMINISTRATOR;

    constructor(address asset, address oracle, address factory, uint256 interestRate, address administrator)
    {
        CONTRACT_ASSET = asset;
        CONTRACT_ORACLE = oracle;
        CONTRACT_FACTORY = factory;
        CONTRACT_INTEREST_RATE = interestRate;
        CONTRACT_ADMINISTRATOR = administrator;
    }

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
        return CONTRACT_INTEREST_RATE;
    }

    function BalanceAsUSD() override external view returns (uint256)
    {
        if (AssetBalance[msg.sender] == 0)
            return 0;

        (, int256 Result, , ,) = AggregatorV3Interface(CONTRACT_ORACLE).latestRoundData();

        return AssetBalance[msg.sender] * uint256(Result);
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
