// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./ICollateralAsset.sol";

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

contract CollateralAsset is ICollateralAsset
{
    uint256 private constant CONTRACT_COLLATERAL = 65;
    address private constant CONTRACT_ASSET = address(0);
    address private constant CONTRACT_ORACLE = address(0);
    address private constant CONTRACT_FACTORY = address(0);
    address private constant CONTRACT_ADMINISTRATOR = address(0);

    bool private AssetStatus;

    mapping(address => uint256) private AssetBalance;

    function Price() override external view returns (int256 Result)
    {
        (, Result, , ,) = AggregatorV3Interface(CONTRACT_ORACLE).latestRoundData();
    }

    function Balance() override external view returns (uint256)
    {
        return AssetBalance[msg.sender];
    }

    function Collateral() override external pure returns (uint256)
    {
        return CONTRACT_COLLATERAL;
    }

    function BalanceAsUSD() override external view returns (uint256)
    {
        (, int256 Result, , ,) = AggregatorV3Interface(CONTRACT_ORACLE).latestRoundData();

        return AssetBalance[msg.sender] * uint256(Result);
    }

    function Enable() override external AdminOnly
    {
        AssetStatus = true;

        emit Enabled();
    }

    function Disable() override external AdminOnly
    {
        AssetStatus = false;

        emit Disabled();
    }

    function Deposit(uint256 amount) override external
    {
        require(AssetStatus, "Deposit: Status Disable");

        require(IBEP20(CONTRACT_ASSET).allowance(msg.sender, address(this)) >= amount, "Deposit: Approve");

        IBEP20(CONTRACT_ASSET).transferFrom(msg.sender, address(this), amount);

        unchecked
        {
            AssetBalance[msg.sender] += amount;
        }

        emit Deposited(msg.sender, amount);
    }

    function Withdraw(uint256 amount) override external
    {
        require(AssetBalance[msg.sender] >= amount, "Withdraw: Amount");

        // CHECK FACTORY

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
