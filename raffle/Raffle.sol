// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "../interface/IBEP20.sol";

/*
    Error: 1, App is not active
    Error: 2, Maximum participate reached
    Error: 3, time
    Error: 4, need to ends
    Error: 5, Maximum participate reached
    Error: 6, QQ
*/

contract Raffle
{
    uint256 private immutable TIME;
    uint256 private immutable PRICE;
    uint256 private immutable CHANCE;
    uint256 private immutable DRAIN_TIME;

    uint256 private constant FEE = 10;
    uint256 private constant PARTICIPATE = 9;
    address private constant TREASURY = 0xCf9a595fD25B76570eF90Ad070Db0b2f7AF864e6;
    IBEP20 private constant TOKEN = IBEP20(address(0xCf9a595fD25B76570eF90Ad070Db0b2f7AF864e6));

    constructor(uint256 price, uint256 chance)
    {
        PRICE = price;
        CHANCE = chance;
        TIME = block.timestamp + 7 days;
        DRAIN_TIME = TIME * 2;
    }

    struct Ticket
    {
        bool Won;
        bool Claim;
        address Owner;
    }

    uint256 private Hash;
    uint256 private Nonce;
    mapping(uint256 => Ticket) private TicketMap;
    mapping(address => uint256[]) private ParticipateMap;

    function Join() external
    {
        require(Hash == 0, "Error: 1");

        require(ParticipateMap[msg.sender].length < PARTICIPATE, "Error: 2");

        TOKEN.transferFrom(msg.sender, address(this), PRICE);

        ParticipateMap[msg.sender].push(Nonce);

        TicketMap[Nonce].Owner = msg.sender;

        emit Joined(msg.sender);

        unchecked
        {
            Nonce++;
        }
    }

    function Finish() external
    {
        require(Hash == 0, "Error: 1");

        // require(block.timestamp > TIME, "Error: 5");

        Hash = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, block.number)));

        uint256 WinnerCount = 2; // Nonce / CHANCE;

        unchecked
        {
            for (uint256 I = 0; I < WinnerCount; I++)
            {
                Hash = uint256(keccak256(abi.encodePacked(Hash, I)));

                TicketMap[Hash % Nonce].Won = true;
            }
        }
    }

    function Claim() external
    {
        require(Hash != 0, "Error: 4");

        uint256 Amount;

        unchecked
        {
            for (uint256 I = 0; I < ParticipateMap[msg.sender].length; I++)
            {
                uint256 NonceID = ParticipateMap[msg.sender][I];

                if (TicketMap[NonceID].Won && !TicketMap[NonceID].Claim)
                {
                    TicketMap[NonceID].Claim = true;

                    Amount += PRICE;
                }
            }
        }

        if (Amount > 0)
        {
            unchecked
            {
                Amount -= (Amount * FEE) / 100;
            }

            TOKEN.transfer(msg.sender, Amount);
        }
    }

    function Drain() external
    {
        require(Hash != 0, "Error: 4");

        // require(block.timestamp > DRAIN_TIME, "Error: 6");

        uint256 Supply = TOKEN.balanceOf(address(this));

        TOKEN.transfer(TREASURY, Supply);
    }

    function GetReward() external view returns (uint256)
    {
        uint256 Amount = 0;

        for (uint256 I = 0; I < ParticipateMap[msg.sender].length; I++)
        {
            uint256 NonceID = ParticipateMap[msg.sender][I];

            if (TicketMap[NonceID].Won && !TicketMap[NonceID].Claim)
            {
                Amount += PRICE;
            }
        }

        if (Amount > 0)
            Amount -= (Amount * FEE) / 100;

        return Amount;
    }

    function GetParticipateJoin() external view returns (uint256)
    {
        return ParticipateMap[msg.sender].length;
    }

    function GetParticipateTotal() external view returns (uint256)
    {
        return Nonce;
    }

    function GetParticipateCount() external pure returns (uint256)
    {
        return PARTICIPATE;
    }

    function GetEntryPrice() external view returns (uint256)
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

    event Joined(address indexed Account);
}
