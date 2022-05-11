// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./interface/IBEP20.sol";

/*
    Overflow is detected automatically since 0.8.0
*/

contract Coin is IBEP20
{
    mapping(address => uint256) private Balance;
    mapping(address => mapping(address => uint256)) private Allowance;

    constructor()
    {
        Balance[msg.sender] = 1000000000000 ether;

        emit Transfer(address(0), msg.sender, 1000000000000 ether);
    }

    function decimals() override external pure returns (uint8)
    {
        return 18;
    }

    function getOwner() override external pure returns (address)
    {
        return address(0);
    }

    function name() override external pure returns (string memory)
    {
        return "Guardian Coin";
    }

    function totalSupply() override external pure returns (uint256)
    {
        return 1000000000000 ether;
    }

    function symbol() override external pure returns (string memory)
    {
        return "GC";
    }

    function balanceOf(address account) override external view returns (uint256)
    {
        return Balance[account];
    }

    function approve(address spender, uint256 amount) override external returns (bool)
    {
        Allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address recipient, uint256 amount) override external returns (bool)
    {
        Balance[recipient] += amount;

        Balance[msg.sender] -= amount;
        
        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function allowance(address owner, address spender) override external view returns (uint256)
    {
        return Allowance[owner][spender];
    }

    function transferFrom(address sender, address recipient, uint256 amount) override external returns (bool)
    {
        uint256 CurrentAllowance = Allowance[sender][msg.sender] - amount;

        Allowance[sender][msg.sender] = CurrentAllowance;

        emit Approval(sender, msg.sender, CurrentAllowance);

        Balance[sender] -= amount;

        Balance[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    function totalBurn() external view returns (uint256)
    {
        return Balance[address(0)];
    }

    receive() external payable
    {
        revert();
    }

    fallback() external payable
    {
        revert();
    }
}
