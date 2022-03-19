// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";
import "../interface/AggregatorV3Interface.sol";

import "../library/Math.sol";
import "../library/Iterator.sol";

contract Lend
{
    using Math for uint256;
    using Iterator for Iterator.Map;

    /*
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
   
    mapping(address => Iterator.Map) private BorrowMap;

    function AssetBorrow(address asset, uint256 amount) external
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
    mapping(address => Iterator.Map) private AssetSupplyMap;
    mapping(address => mapping(address => uint256)) private AssetStakeMap;

    function AssetDeposit(address asset, uint256 amount) external
    {
        require(AssetIsInMap(asset), "AssetDeposit: Invalid Asset");

        require(IBEP20(asset).allowance(msg.sender, address(this)) >= amount, "AssetDeposit: Approve");

        IBEP20(asset).transferFrom(msg.sender, address(this), amount);

        AssetSupplyMap[msg.sender].Increase(asset, amount);
    }

    function AssetWithdrawal(address asset, uint256 amount) external
    {
        require(AssetIsInMap(asset), "AssetWithdrawal: Invalid Asset");

        require(AssetSupplyMap[msg.sender].Value(asset) >= amount, "AssetWithdrawal: Amount");

        AssetSupplyMap[msg.sender].Decrease(asset, amount);

        IBEP20(asset).transfer(msg.sender, amount);
    }

    function AssetStake(address asset, uint256 amount) external
    {
        require(AssetIsInMap(asset), "AssetStake: Invalid Asset");

        require(IBEP20(asset).allowance(msg.sender, address(this)) >= amount, "AssetStake: Allowance");

        IBEP20(asset).transferFrom(msg.sender, address(this), amount);

        AssetStakeMap[msg.sender][asset].Add(amount);

        AssetBalanceMap[asset].Add(amount);

        emit AssetStaked(asset, amount);
    }

    function AssetUnstake(address asset, uint256 amount) external
    {
        require(AssetIsInMap(asset), "AssetUnstake: Invalid Asset");

        require(AssetBalanceMap[asset] >= amount, "AssetUnstake: Amount");

        AssetStakeMap[msg.sender][asset].Sub(amount);

        IBEP20(asset).transfer(msg.sender, amount);

        AssetBalanceMap[asset].Sub(amount);

        emit AssetUnstaked(asset, amount);
    }

    function AssetBalance(address asset) external view returns(uint256)
    {
        return AssetBalanceMap[asset];
    }

    event AssetStaked(address indexed Asset, uint256 Amount);
    event AssetUnstaked(address indexed Asset, uint256 Amount);

    // Asset Map
    uint32 private constant INTEREST_RATE_MIN = 1; // 1% Min Interest Rate
    uint32 private constant INTEREST_RATE_MAX = 100; // 100% Max Interest Rate
    uint32 private constant COLLATERAL_RATE_MIN = 10; // 10% Min Collateral Rate
    uint32 private constant COLLATERAL_RATE_MAX = 70; // 70% Max Collateral Rate

    struct AssetFactor
    {
        address Oracle;
        uint32 InterestRate;
        uint32 CollateralRate;
    }

    mapping(address => AssetFactor) private AssetMap;

    function AssetMapUpdate(address asset, address oracle, uint32 interestRate, uint32 collateralRate) external AdminOnly
    {
        require(interestRate > INTEREST_RATE_MIN && interestRate < INTEREST_RATE_MAX, "AssetMapUpdate: Interest Rate");

        require(collateralRate > COLLATERAL_RATE_MIN && collateralRate < COLLATERAL_RATE_MAX, "AssetMapUpdate: Collateral Rate");

        AssetMap[asset].Oracle = oracle;
        AssetMap[asset].InterestRate = interestRate;
        AssetMap[asset].CollateralRate = collateralRate;

        emit AssetMapUpdated(asset, oracle, interestRate, collateralRate);
    }

    function AssetIsInMap(address asset) internal view returns(bool)
    {
        return AssetMap[asset].Oracle != address(0);
    }

    event AssetMapUpdated(address indexed Asset, address Oracle, uint32 InterestRate, uint32 CollateralRate);

    // Modifier
    modifier AdminOnly()
    {
        // Administrator Contract Address
        require(IAdministrator(address(0)).IsAdmin(msg.sender), "AdminOnly: Admin Only");

        _;
    }
}
