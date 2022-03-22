// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "../interface/IBEP20.sol";
import "../interface/IAdministrator.sol";

import "../library/Iterator.sol";

contract Factory
{
    address private constant CONTRACT_ADMINISTRATOR = address(0);

    // Modifier
    modifier AdminOnly()
    {
        // Administrator Contract Address
        require(IAdministrator(CONTRACT_ADMINISTRATOR).IsAdmin(msg.sender), "AdminOnly: Admin Only");

        _;
    }
}
