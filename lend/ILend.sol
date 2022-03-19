// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.6;

interface IBEP20
{
    function GetPrice() external view returns (int256);
    function GetCollateralRate() external view returns (uint256);

    function name() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function symbol() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
