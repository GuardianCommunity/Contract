// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "./Library/Math.sol";
import "./Interface/IBEP20.sol";

contract Treasury
{
    using Math for uint256;

    mapping(address => mapping(IBEP20 => uint256)) private Storage;

    function deposit(IBEP20 token, uint256 amount) public
    {
        token.transferFrom(msg.sender, address(this), amount);

        Storage[msg.sender][token] = Storage[msg.sender][token].Add(amount);

        emit Deposit(address(token), msg.sender, amount);
    }

    function withdraw(IBEP20 token, uint256 amount) public
    {
        Storage[msg.sender][token] = Storage[msg.sender][token].Sub(amount);

        token.transferFrom(address(this), msg.sender, amount);

        emit Withdraw(address(token), msg.sender, amount);
    }

    function balanceOf(IBEP20 token, address account) external view returns (uint256)
    {
        return Storage[account][token];
    }

    event Deposit(address indexed token, address indexed account, uint256 amount);
    event Withdraw(address indexed token, address indexed account, uint256 amount);
}
