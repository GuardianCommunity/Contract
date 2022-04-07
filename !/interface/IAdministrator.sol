// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IAdministrator
{
    function IsAdmin(address) external view returns (bool);
}
