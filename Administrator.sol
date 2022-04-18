// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./interface/IAdministrator.sol";

contract Administrator is IAdministrator
{
    address[] private Admin;
    address[] private AdminPending;

    constructor()
    {
        Admin[0] = msg.sender;

        emit AdminChanged(0, address(0), msg.sender);
    }

    function SetPendingAdmin(uint256 Index, address NewAdminPending) external
    {
        require(Admin[Index] == msg.sender, "Administrator: Only Admin");

        AdminPending[Index] = NewAdminPending;
    }

    function AcceptPendingAdmin(uint256 Index) external
    {
        require(AdminPending[Index] == msg.sender, "Administrator: Only Pending Admin");

        emit AdminChanged(Index, Admin[Index], msg.sender);

        AdminPending[Index] = address(0);

        Admin[Index] = msg.sender;
    }

    function IsAdmin(uint256 Index, address Caller) override external view returns (bool)
    {
        return Admin[Index] == Caller;
    }
}
