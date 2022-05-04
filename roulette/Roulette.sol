// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "../interface/IBEP20.sol";

/*
    Error: 1, Roulette is not active
    Error: 2, Maximum participate reached
    Error: 3, time
    Error: 4, need to ends
    Error: 2, Maximum participate reached
*/

contract LuckyDraw
{
    IBEP20 private immutable TOKEN;
    uint256 private immutable FEE;
    uint256 private immutable TIME;
    uint256 private immutable PRICE;
    uint256 private immutable CHANCE;
    
    constructor(uint256 fee, uint256 time, uint256 price, uint256 chance, address token)
    {
        FEE = fee;
        TIME = time;
        PRICE = price;
        CHANCE = chance;
        TOKEN = IBEP20(token);
    }

    struct Reward
    {
        bool Won;
        bool Claim;
        address Owner;
    }

    uint256 private Hash;
    uint256 private Nonce;
    mapping(uint256 => Reward) private TicketMap;
    mapping(address => uint256[]) private ParticipatetMap;

    function Join() external
    {
        require(Hash == 0, "1");

        require(ParticipatetMap[msg.sender].length < 10, "2");

        TOKEN.transferFrom(msg.sender, address(this), PRICE);

        ParticipatetMap[msg.sender].push(Nonce);

        TicketMap[Nonce].Owner = msg.sender;

        Nonce++;
    }

    function Finish() external
    {
        require(Hash == 0, "1");

        require(block.timestamp > TIME, "3");

        Hash = uint256(keccak256(abi.encodePacked(block.difficulty, address(this), block.timestamp, block.number, block.basefee)));

        uint256 WinnerCount = Nonce / CHANCE;

        for (uint256 I = 0; I < WinnerCount; I++)
        {
            Hash = uint256(keccak256(abi.encodePacked(Hash, I)));

            TicketMap[Hash % Nonce].Won = true;
        }
    }

    function Claim() external
    {
        require(Hash != 0, "4");

        uint256 Amount;

        for (uint256 I = 0; I < ParticipatetMap[msg.sender].length; I++)
        {
            uint256 NonceID = ParticipatetMap[msg.sender][I];

            if (TicketMap[NonceID].Won && !TicketMap[NonceID].Claim)
            {
                TicketMap[NonceID].Claim = true;

                Amount += PRICE;
            }
        }

        if (Amount > 0)
        {
            Amount = Amount / FEE;

            TOKEN.transfer(msg.sender, Amount);
        }
    }

    function Claimable() external view returns (uint256)
    {
        uint256 Amount;

        for (uint256 I = 0; I < ParticipatetMap[msg.sender].length; I++)
        {
            uint256 NonceID = ParticipatetMap[msg.sender][I];

            if (TicketMap[NonceID].Won && !TicketMap[NonceID].Claim)
            {
                Amount += PRICE;
            }
        }

        return Amount;
    }

    function GetTicketCount(address Account) external view returns (uint256)
    {
        return ParticipatetMap[Account].length;
    }

    function GetReward() external view returns (uint256)
    {
        return (PRICE * Nonce) / FEE;
    }

    function GetPrice() external view returns (uint256)
    {
        return PRICE;
    }

    function GetChance() external view returns (uint256)
    {
        return CHANCE;
    }

    function GetTime() external view returns (uint256)
    {
        return TIME;
    }
}
