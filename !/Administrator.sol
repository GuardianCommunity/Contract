// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

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
        require(Admin == msg.sender, "Administrator: Only Admin");

        AdminPending = NewAdminPending;
    }

    function AcceptPendingAdmin() external
    {
        require(AdminPending == msg.sender, "Administrator: Only Pending Admin");

        emit AdminChanged(Admin, msg.sender);

        AdminPending = address(0);

        Admin = msg.sender;
    }

    function IsAdmin(address Caller) override external view returns (bool)
    {
        return Admin == Caller;
    }

    event AdminChanged(address indexed OldAdmin, address indexed NewAdmin);
}
