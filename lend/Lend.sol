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

    /*
    struct TokenFactor
    {
        address Oracle;
        uint256 Collateral;
    }

    mapping(address => TokenFactor) private TokenMap;
    

    uint256 public constant MIN_COLLATERAL = 20; // 20% Min Collateral Borrow
    uint256 public constant MAX_COLLATERAL = 70; // 70% Max Collateral Borrow



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

    
    // Lend
    mapping(address => Iterator.Map) private SupplyMap;
    mapping(address => Iterator.Map) private BorrowMap;

    function Supply(address token, uint256 amount) external
    {
        require(IBEP20(token).allowance(msg.sender, address(this)) >= amount, "Supply: Approve");

        IBEP20(token).transferFrom(msg.sender, address(this), amount);

        SupplyMap[msg.sender].Increase(token, amount);
    }

    function Borrow(address asset, uint256 amount) external
    {
        require(AssetIsInMap(asset), "Borrow: Invalid Asset");

        require(AssetBalanceMap[asset] >= amount, "Borrow: Asset Amount");

        uint256 RequestValue = 100; // Requested amount must be equal or lower than colleteral amount + Old Borrowed Amount

        IBEP20(asset).transfer(msg.sender, amount);

        BorrowMap[msg.sender][asset].Add(amount);
    }


    */

    // Asset Stake
    mapping(address => uint256) private AssetBalanceMap;
    mapping(address => mapping(address => uint256)) private AssetStakeMap;

    function AssetStake(address asset, uint256 amount) external
    {
        require(IBEP20(asset).allowance(msg.sender, address(this)) >= amount, "AssetStake: Allowance");

        IBEP20(asset).transferFrom(msg.sender, address(this), amount);

        AssetStakeMap[msg.sender][asset].Add(amount);

        AssetBalanceMap[asset].Add(amount);
    }

    function AssetUnstake(address asset, uint256 amount) external
    {
        require(AssetBalanceMap[asset] >= amount, "AssetUnstake: Amount");

        AssetStakeMap[msg.sender][asset].Sub(amount);

        IBEP20(asset).transfer(msg.sender, amount);

        AssetBalanceMap[asset].Sub(amount);
    }

    function AssetBalance(address asset) external view returns(uint256)
    {
        return AssetBalanceMap[asset];
    }

    // Asset Map
    struct AssetFactor
    {
        address Oracle;
        uint32 InterestRate;
        uint256 CollateralRate;
    }

    mapping(address => AssetFactor) private AssetMap;

    function AssetMapUpdate(address asset, address oracle, uint32 interestRate, uint256 collateralRate) external AdminOnly
    {
        AssetMap[asset].Oracle = oracle;
        AssetMap[asset].InterestRate = interestRate;
        AssetMap[asset].CollateralRate = collateralRate;

        emit AssetMapUpdated(asset, oracle, interestRate, collateralRate);
    }

    function AssetIsInMap(address asset) internal view returns(bool)
    {
        return AssetMap[asset].Oracle != address(0);
    }

    event AssetMapUpdated(address indexed Asset, address Oracle, uint32 InterestRate, uint256 CollateralRate);

    // Modifier
    address private constant ADMINISTRATOR = address(0);

    modifier AdminOnly()
    {
        require(IAdministrator(ADMINISTRATOR).IsAdmin(msg.sender), "AdminOnly: Admin Only");

        _;
    }
}
