// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

interface IAdministrator
{
    function GetAdmin() external view returns (address);

    event AdminChanged(address indexed OldAdmin, address indexed NewAdmin);
}
