// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

library Math
{
    function Add(uint256 A, uint256 B) internal pure returns (uint256)
    {
        uint256 C = A + B;

        require(C >= A, "Math: addition overflow");

        return C;
    }

    function Sub(uint256 A, uint256 B) internal pure returns (uint256)
    {
        require(B <= A, "Math: subtraction overflow");

        uint256 C = A - B;

        return C;
    }

    function Mul(uint256 A, uint256 B) internal pure returns (uint256)
    {
        if (A == 0)
        {
            return 0;
        }

        uint256 C = A * B;

        require(C / A == B, "Math: multiplication overflow");

        return C;
    }

    function Div(uint256 A, uint256 B) internal pure returns (uint256)
    {
        require(B > 0, "Math: division by zero");

        uint256 C = A / B;

        return C;
    }

    function Mod(uint256 A, uint256 B) internal pure returns (uint256)
    {
        require(B != 0, "Math: modulo by zero");

        return A % B;
    }

    function Min(uint256 A, uint256 B) internal pure returns (uint256 Result)
    {
        Result = A < B ? A : B;
    }
}
