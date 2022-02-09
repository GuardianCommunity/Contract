// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

contract VaultArray
{
    struct Entity
    {
        address Token;
        uint256 Index;
        uint256 Value;
    }

    Entity[] private Storage;

    function Increase(address token, uint256 amount) public
    {
        (uint256 Index, bool Result) = IsAvailable(token);

        if (Result)
        {
            Storage[Index].Value += amount;
        }
        else
        {
            Entity storage entity = Storage.push();

            entity.Index = Storage.length;
            entity.Value = amount;
            entity.Token = token;
        }
    }

    function Decrease(address token, uint256 amount) public
    {
        (uint256 Index, bool Result) = IsAvailable(token);

        if (Result)
        {
            Storage[Index].Value -= amount;
        }
    }

    function IsAvailable(address token) public view returns (uint256 Index, bool Result)
    {
        for (uint256 I = 0; I < Storage.length; I++)
        {
            if (Storage[I].Token == token)
            {
                Result = true;

                Index = I;

                break;
            }
        }
    }

    function Balance(address token) public view returns (uint256 Value, bool Result)
    {
        for (uint256 I = 0; I < Storage.length; I++)
        {
            if (Storage[I].Token == token)
            {
                Value = Storage[I].Value;

                Result = true;

                break;
            }
        }
    }
}
