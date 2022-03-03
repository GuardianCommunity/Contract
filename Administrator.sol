// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

import "../interface/IAdministrator.sol";

contract Administrator is IAdministrator
{
    address private Admin;
    address private AdminPending;

    constructor()
    {
        Admin = msg.sender;

        emit AdminChanged(address(0), Admin);
    }

    function SetPendingAdmin(address NewAdminPending) external
    {
        require(Admin == msg.sender, "Admin: Only Admin");

        AdminPending = NewAdminPending;
    }

    function AcceptPendingAdmin() external
    {
        require(msg.sender == AdminPending, "Admin: Only Pending Admin");

        emit AdminChanged(Admin, AdminPending);

        AdminPending = address(0);

        Admin = msg.sender;
    }

    function GetAdministrator() override external view returns (address)
    {
        return Admin;
    }

    event AdminChanged(address indexed OldAdmin, address indexed NewAdmin);
}
