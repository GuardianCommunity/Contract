// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

import "../library/Math.sol";
import "../library/Iterator.sol";

// ChainLink BTC/USD: 0x264990fbd0A4796A3E3d8E37C4d5F87a3aCa5Ebf

contract Factory
{
    using Math for uint256;
    using Iterator for Iterator.Map;

    uint256 public REVERSE_CURRENT;
    uint256 public constant REVERSE_MIN = 2000;
    uint256 public constant REVERSE_MAX = 7500;

    mapping(address => address) private OracleMap;
    mapping(address => Iterator.Map) private SupplyMap;

    function Supply(address token, uint256 amount) external
    {
        require(IBEP20(token).allowance(msg.sender, address(this)) >= amount, "Supply: Approve");

        IBEP20(token).transferFrom(msg.sender, address(this), amount);

        SupplyMap[msg.sender].Increase(token, amount);
    }

    function SupplyAsUSD() internal view returns (uint256 Result)
    {
        (address[] memory T, uint256[] memory V) = SupplyMap[msg.sender].ValueMap();

        for (uint256 I = 0; I < T.length; I++)
        {
            (, int256 Price, , ,) = AggregatorV3Interface(OracleMap[T[I]]).latestRoundData();

            Result += uint256(Price) * V[I];
        }
    }

    function Borrow(address token, uint256 amount) external
    {
        uint256 MaxBorrowUSD = SupplyAsUSD() * REVERSE_CURRENT;

    }

    function Withdraw(address token, uint256 amount) external
    {
        require(SupplyMap[msg.sender].Value(token) >= amount, "Withdraw: Amount");

        // Check Borrow Amount

        SupplyMap[msg.sender].Decrease(token, amount);

        IBEP20(token).transfer(msg.sender, amount);
    }





}
