// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./Math.sol";

library Iterator
{
    using Math for uint256;

    struct Map
    {
        address[] K;
        mapping(address => bool) E;
        mapping(address => uint256) V;
    }

    function Increase(Map storage map, address key, uint256 value) internal
    {
        if (map.E[key])
        {
            map.V[key] = map.V[key].Add(value);
        }
        else
        {
            map.K.push(key);

            map.E[key] = true;
            map.V[key] = value;
        }
    }

    function Decrease(Map storage map, address key, uint256 value) internal
    {
        if (map.E[key])
        {
            map.V[key] = map.V[key].Sub(value);
        }
    }

    function ValueMap(Map storage map) internal view returns (address[] memory T, uint256[] memory V)
    {
        for (uint256 I = 0; I < map.K.length; I++)
        {
            T[I] = map.K[I];
            V[I] = map.V[map.K[I]];
        }
    }

    function Value(Map storage map, address key) internal view returns (uint256)
    {
        return map.V[key];
    }
}
