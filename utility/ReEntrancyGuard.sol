// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

contract ReEntrancyGuard
{
    bool internal IsLock;

    modifier noReentrant()
    {
        require(!IsLock, "ReEntrancyGuard: No Entrance");

        IsLock = true;

        _;

        IsLock = false;
    }
}
