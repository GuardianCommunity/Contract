// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

interface IAdministrator
{
    function IsAdmin(address) external view returns (bool);
}
