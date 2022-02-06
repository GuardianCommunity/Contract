// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

contract Ownable
{
    address private Owner;

    constructor()
    {
        Owner = msg.sender;

        emit OwnershipTransferred(address(0), Owner);
    }

    modifier OnlyOwner()
    {
        require(Owner == msg.sender, "Ownable: Only Owner");

        _;
    }

    function GetOwner() public view returns (address)
    {
        return Owner;
    }

    function TransferOwnership(address NewOwner) public OnlyOwner
    {
        Owner = NewOwner;

        emit OwnershipTransferred(Owner, NewOwner);
    }

    event OwnershipTransferred(address indexed PreviousOwner, address indexed NewOwner);
}
