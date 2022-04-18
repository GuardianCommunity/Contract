// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "../interface/IBEP20.sol";

/*
    Error: 1 Roulette is not enable
    Error: 2 Roulette has ended
*/

contract Roulette
{
    IBEP20 private constant TOKEN = IBEP20(address(0));

    uint256 private immutable Time;
    uint256 private immutable Price;
    uint256 private immutable Chance;

    uint256 private Hash;
    address[] private Storage;

    constructor()
    {
        Chance = 10;
        Price = 1000;
        Time = block.timestamp + 24 hours;
    }

    function Join() external
    {
        require(Hash == 0, "1");

        TOKEN.transferFrom(msg.sender, address(this), Price);

        Storage.push(msg.sender);
    }

    function Finish() external
    {
        require(Hash == 0, "1");

        require(block.timestamp > Time, "3");

        Hash = uint256(keccak256(abi.encodePacked(block.difficulty, address(this), block.timestamp, block.number, block.basefee)));
    }

    function GetWinner(address Winner) external view returns (uint256[] memory Result)
    {
        address[] memory StorageTemp = Storage;

        for (uint256 I = 0; I < StorageTemp.length; I++)
        {
            uint256 N = I + Hash % (StorageTemp.length - I);
            address T = StorageTemp[N];

            StorageTemp[N] = StorageTemp[I];
            StorageTemp[I] = T;
        }

        uint256 J;
        uint256 Max = (Chance > StorageTemp.length) ? StorageTemp.length : Chance;

        for (uint256 I = 0; I < Max; I++)
        {
            if (StorageTemp[I] == Winner)
            {
                Result[J] = I;

                J++;
            }
        }
    }

    function GetStorage() external view returns (address[] memory)
    {
        return Storage;
    }

    function GetPrice() external view returns (uint256)
    {
        return Price;
    }

    function GetChance() external view returns (uint256)
    {
        return Chance;
    }

    function GetTime() external view returns (uint256)
    {
        return Time;
    }
}

/*
    for (uint256 I = 0; I < Storage.length; I++)
    {
        uint256 N = I + Hash % (Storage.length - I);
        address T = Storage[N];

        Storage[N] = Storage[I];
        Storage[I] = T;
    }
*/