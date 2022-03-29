// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "./ICollateralAsset.sol";

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

contract CollateralAsset is ICollateralAsset
{
    address private immutable CONTRACT_ASSET;
    address private immutable CONTRACT_ORACLE;
    uint256 private immutable CONTRACT_COLLATERAL;
    address private immutable CONTRACT_ADMINISTRATOR;

    constructor(address asset, address oracle, uint256 collateral, address administrator)
    {
        CONTRACT_ASSET = asset;
        CONTRACT_ORACLE = oracle;
        CONTRACT_COLLATERAL = collateral;
        CONTRACT_ADMINISTRATOR = administrator;
    }

    bool private IsDisable;
    mapping(address => uint256) private AssetBalance;

    function Price() override external view returns (int256 Result)
    {
        (, Result, , ,) = AggregatorV3Interface(CONTRACT_ORACLE).latestRoundData();
    }

    function Balance() override external view returns (uint256)
    {
        return AssetBalance[msg.sender];
    }

    function Collateral() override external view returns (uint256)
    {
        return CONTRACT_COLLATERAL;
    }

    function BalanceAsUSD() override external view returns (uint256)
    {
        if (AssetBalance[msg.sender] == 0)
            return 0;

        (, int256 Result, , ,) = AggregatorV3Interface(CONTRACT_ORACLE).latestRoundData();

        return AssetBalance[msg.sender] * uint256(Result);
    }

    function Enable() override external AdminOnly
    {
        IsDisable = false;
    }

    function Disable() override external AdminOnly
    {
        IsDisable = true;
    }

    function Deposit(uint256 amount) override external
    {
        require(!IsDisable, "Deposit: Disable");

        require(IBEP20(CONTRACT_ASSET).allowance(msg.sender, address(this)) >= amount, "Deposit: Approve");

        IBEP20(CONTRACT_ASSET).transferFrom(msg.sender, address(this), amount);

        AssetBalance[msg.sender] += amount;

        emit Deposited(msg.sender, amount);
    }

    function Withdraw(uint256 amount) override external
    {
        require(AssetBalance[msg.sender] >= amount, "Withdraw: Amount");

        // QQ

        IBEP20(CONTRACT_ASSET).transfer(msg.sender, amount);

        unchecked
        {
            AssetBalance[msg.sender] -= amount;
        }

        emit Withdrawn(msg.sender, amount);
    }

    modifier AdminOnly()
    {
        require(IAdministrator(CONTRACT_ADMINISTRATOR).IsAdmin(msg.sender), "AdminOnly: Admin Only");

        _;
    }
}
