// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "./Ownable.sol";

contract WhiteList is Ownable
{
    mapping(address => bool) private Storage;

    function Add(address account) internal OnlyOwner
    {
        Storage[account] = true;

        emit AddToWhiteList(account);
    }

    function Remove(address account) internal OnlyOwner
    {
        Storage[account] = false;

        emit RemoveFromWhiteList(account);
    }

    function IsInWhiteList(address account) public view returns(bool)
    {
        return Storage[account];
    }

    event AddToWhiteList(address indexed account);
    event RemoveFromWhiteList(address indexed account);
}
