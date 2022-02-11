// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

abstract contract Ownable
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

    function Transfer(address NewOwner) external OnlyOwner
    {
        emit OwnerChanged(Owner, NewOwner);

        Owner = NewOwner;
    }

    event OwnerChanged(address indexed PreviousOwner, address indexed NewOwner);
}
