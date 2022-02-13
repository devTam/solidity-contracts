// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public owner;
    address payable[] public players;

    constructor() {
        owner = msg.sender;
    }

    event WinnerPicked(address winner);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function join() public payable {
        require(msg.value >= 1 ether);
        players.push(payable(msg.sender));
    }

    function generateRandomNumber() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        players.length
                    )
                )
            );
    }

    function pickWinner() public onlyOwner {
        uint256 randomNumber = generateRandomNumber();
        uint256 winnerIndex = randomNumber % players.length;
        address payable winner = players[winnerIndex];
        winner.transfer(address(this).balance);
        emit WinnerPicked(winner);
        players = new address payable [](0);
    }
}
