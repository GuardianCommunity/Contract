// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "./IFactory.sol";
import "./ICollateralAsset.sol";

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";

contract Factory is IFactory
{
    address private immutable CONTRACT_ADMINISTRATOR;

    constructor(address administrator)
    {
        CONTRACT_ADMINISTRATOR = administrator;
    }

    address[] private CollateralAssetMap;

    function CreditAsUSD() external view returns(uint256 Result)
    {
        for (uint256 I = 0; I < CollateralAssetMap.length; I++)
        {
            Result += ICollateralAsset(CollateralAssetMap[I]).BalanceAsUSD();
        }
    }

    function AssetAdd(address asset) external AdminOnly
    {
        bool IsAvailable = true;

        for (uint256 I = 0; I < CollateralAssetMap.length; I++)
        {
            if (CollateralAssetMap[I] == asset)
            {
                IsAvailable = false;

                break;
            }
        }

        if (IsAvailable)
        {
            CollateralAssetMap.push(asset);

            emit AssetAdded(asset);
        }
    }

    function AssetRemove(address asset) external AdminOnly
    {
        for (uint256 I = 0; I < CollateralAssetMap.length; I++)
        {
            if (CollateralAssetMap[I] == asset)
            {
                CollateralAssetMap[I] = CollateralAssetMap[CollateralAssetMap.length - 1];

                CollateralAssetMap.pop();

                emit AssetRemoved(asset);

                break;
            }
        }
    }

    modifier AdminOnly()
    {
        require(IAdministrator(CONTRACT_ADMINISTRATOR).IsAdmin(msg.sender), "AdminOnly: Admin Only");

        _;
    }
}
