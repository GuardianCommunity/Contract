// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

contract Ownable
{
    address private Owner;

    constructor()
    {
        Owner = msg.sender;

        emit OwnerChanged(address(0), Owner);
    }

    modifier OnlyOwner()
    {
        require(Owner == msg.sender, "Ownable: Only Owner");

        _;
    }

    function GetOwner() external view returns (address)
    {
        return Owner;
    }

    function TransferOwnership(address NewOwner) public OnlyOwner
    {
        Owner = NewOwner;

        emit OwnerChanged(Owner, NewOwner);
    }

    event OwnerChanged(address indexed PreviousOwner, address indexed NewOwner);
}
