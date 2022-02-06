// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "./Library/Math.sol";
import "./Interface/IBEP20.sol";

contract Coin is IBEP20
{
    using Math for uint256;

    mapping(address => uint256) private Balance;
    mapping(address => mapping(address => uint256)) private Allowance;

    constructor()
    {
        Balance[msg.sender] = 100000000000 ether;

        emit Transfer(address(0), msg.sender, 100000000000 ether);
    }

    function decimals() external pure returns (uint8)
    {
        return 18;
    }

    function getOwner() external pure returns (address)
    {
        return address(0);
    }

    function name() external pure returns (string memory)
    {
        return "Guardian";
    }

    function totalSupply() external pure returns (uint256)
    {
        return 100000000000 ether;
    }

    function symbol() external pure returns (string memory)
    {
        return "G";
    }

    function balanceOf(address account) external view returns (uint256)
    {
        return Balance[account];
    }

    function approve(address spender, uint256 amount) external returns (bool)
    {
        Allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address recipient, uint256 amount) external returns (bool)
    {
        Balance[msg.sender] = Balance[msg.sender].Sub(amount);

        Balance[recipient] = Balance[recipient].Add(amount);

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256)
    {
        return Allowance[owner][spender];
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
    {
        Balance[sender] = Balance[sender].Sub(amount);

        Balance[recipient] = Balance[recipient].Add(amount);

        emit Transfer(sender, recipient, amount);

        Allowance[sender][msg.sender] = Allowance[sender][msg.sender].Sub(amount);

        emit Approval(sender, msg.sender, amount);

        return true;
    }

    function totalBurn() external view returns (uint256)
    {
        return Balance[address(0)];
    }
}
