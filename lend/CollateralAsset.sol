// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "./ICollateralAsset.sol";

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

contract CollateralAsset is ICollateralAsset
{
    address private constant ASSET = address(0);
    uint256 private constant COLLATERAL_RATE = 10;
    address private constant PRICE_ORACLE = address(0);

    bool private AssetState;
    mapping(address => uint256) private AssetBalanceMap;

    function Enable() external AdminOnly
    {
        AssetState = true;

        emit Enabled();
    }

    function Disable() external AdminOnly
    {
        AssetState = false;

        emit Disabled();
    }

    function Price() external view returns (int256 Result)
    {
        (, Result, , ,) = AggregatorV3Interface(PRICE_ORACLE).latestRoundData();
    }

    function Collateral() external pure returns (uint256)
    {
        return COLLATERAL_RATE;
    }

    function Deposit(uint256 amount) external
    {
        require(AssetState, "Deposit: Disable");

        require(IBEP20(ASSET).allowance(msg.sender, address(this)) >= amount, "Deposit: Approve");

        IBEP20(ASSET).transferFrom(msg.sender, address(this), amount);

        AssetBalanceMap[msg.sender] += amount;

        emit Deposited(amount);
    }

    function Withdraw(uint256) external
    {

    }

    // Modifier
    modifier AdminOnly()
    {
        // Administrator Contract Address
        require(IAdministrator(address(0)).IsAdmin(msg.sender), "AdminOnly: Admin Only");

        _;
    }
}
