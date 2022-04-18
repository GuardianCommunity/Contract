// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IAdministrator
{
    function IsAdmin(uint256, address) external view returns (bool);

    event AdminChanged(uint256 Index, address indexed OldAdmin, address indexed NewAdmin);
}
