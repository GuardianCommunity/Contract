// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

abstract contract WhiteList
{
    mapping(address => bool) private Storage;

    function Add(address account) internal
    {
        Storage[account] = true;

        emit AddToWhiteList(account);
    }

    function Remove(address account) internal
    {
        Storage[account] = false;

        emit RemoveFromWhiteList(account);
    }

    function IsInWhiteList(address account) internal view returns(bool)
    {
        return Storage[account];
    }

    event AddToWhiteList(address indexed account);
    event RemoveFromWhiteList(address indexed account);
}
