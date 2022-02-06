// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "../library/Math.sol";
import "../library/Ownable.sol";
import "../interface/IBEP20.sol";

contract Treasury is Ownable
{
    using Math for uint256;

    mapping(address => mapping(IBEP20 => uint256)) private SupplyStorage;

    function Deposit(IBEP20 token, uint256 amount) public
    {
        require(amount > 0, "Token value is too low!");
        require(token.allowance(msg.sender, address(this)) >= amount, "Approve token first!");

        token.transferFrom(msg.sender, address(this), amount);

        SupplyStorage[msg.sender][token] += amount;

        emit OnDeposit(address(token), msg.sender, amount);
    }

    event OnDeposit(address indexed token, address indexed account, uint256 amount);
}
