// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IBEP20
{
    function decimals() external view returns (uint8);
    function getOwner() external view returns (address);
    function name() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function symbol() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed From, address indexed To, uint256 Value);
    event Approval(address indexed Owner, address indexed Spender, uint256 Value);
}
