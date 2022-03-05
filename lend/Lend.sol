// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

import "../library/Math.sol";
import "../library/Iterator.sol";

// ChainLink BTC/USD: 0x264990fbd0A4796A3E3d8E37C4d5F87a3aCa5Ebf

contract Lend
{
    using Math for uint256;
    using Iterator for Iterator.Map;

    struct TokenFactor
    {
        address Oracle;
        uint256 Collateral;
    }

    mapping(address => bool) private PoolMap;
    mapping(address => TokenFactor) private TokenMap;
    mapping(address => Iterator.Map) private SupplyMap;

    uint256 public constant MIN_COLLATERAL = 20; // 20% Min Collateral Borrow
    uint256 public constant MAX_COLLATERAL = 70; // 70% Max Collateral Borrow

    function Supply(address token, uint256 amount) external
    {
        require(IBEP20(token).allowance(msg.sender, address(this)) >= amount, "Supply: Approve");

        IBEP20(token).transferFrom(msg.sender, address(this), amount);

        SupplyMap[msg.sender].Increase(token, amount);
    }

    function Withdrawal(address token, uint256 amount) external
    {
        require(SupplyMap[msg.sender].Value(token) >= amount, "Withdrawal: Amount");

        SupplyMap[msg.sender].Decrease(token, amount);

        IBEP20(token).transfer(msg.sender, amount);
    }



    function SupplyAsCollateral() internal view returns (uint256 Result)
    {
        (address[] memory Key, uint256[] memory Value) = SupplyMap[msg.sender].ValueMap();

        for (uint256 I = 0; I < Key.length; I++)
        {
            address Oracle = TokenMap[Key[I]].Oracle;

            if (Oracle != address(0))
            {
                (, int256 Price, , ,) = AggregatorV3Interface(Oracle).latestRoundData();

                Result += (uint256(Price) * Value[I]) * TokenMap[Key[I]].Collateral;
            }
        }
    }

    function Borrow(address token, uint256 amount) external
    {
        require(IsInAssetMap(token), "Borrow: Invalid Token");

        IBEP20(token).transfer(msg.sender, amount);
    }

    // Asset Map
    mapping(address => bool) private AssetMap;

    function AddToAssetMap(address token) external OnlyAdmin
    {
        AssetMap[token] = true;

        emit AddedToAssetMap(token);
    }

    function RemoveFromAssetMap(address token) external OnlyAdmin
    {
        AssetMap[token] = false;

        emit RemovedFromAssetMap(token);
    }

    function IsInAssetMap(address token) internal view returns(bool)
    {
        return AssetMap[token];
    }

    event AddedToAssetMap(address indexed token);
    event RemovedFromAssetMap(address indexed token);

    // Modifier
    address private constant ADMINISTRATOR = address(0);

    modifier OnlyAdmin()
    {
        require(IAdministrator(ADMINISTRATOR).IsAdmin(msg.sender), "OnlyAdmin: Only Admin");

        _;
    }
}
