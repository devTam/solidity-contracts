// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Voting {
    address public owner;
    address [] public candidates;
    mapping (address => uint) public votes;
    uint public totalVotes;  
    enum VoteState {
        NotStarted,
        InProgress,
        Ended
    }
    VoteState public voteStatus;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function setStatus() public onlyOwner {
        if (voteStatus != VoteState.Ended) voteStatus = VoteState.InProgress;
        voteStatus = VoteState.Ended;
    }

    function addCandidate(address _candidate) onlyOwner public {
        candidates.push(_candidate);
    }

    function validateCandidate(address _candidate) public view returns (bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i] == _candidate) {
                return true;
            }
        }
        return false;
    }

    function vote(address _candidate) public {
        require(validateCandidate(_candidate), "Candidate not found");
        require(voteStatus == VoteState.InProgress, "Voting has not started");
        votes[_candidate] += 1;
        totalVotes++;
    }

    function getWinner() public view returns (address) {
        uint winnerVotes = 0;
        address winner;
        require(voteStatus == VoteState.Ended, "Voting has not ended");
        for (uint i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] > winnerVotes) {
                winnerVotes = votes[candidates[i]];
                winner = candidates[i];
            }
        }
        return winner;
    }

    function getTotalVotes() public view returns (uint) {
        return totalVotes;
    }

    function getCandidateVotes(address _candidate) public view returns (uint) {
        require(validateCandidate(_candidate), "Candidate not found");
        require(voteStatus == VoteState.InProgress, "Voting has not started");
        return votes[_candidate];
    }

    function getCandidate(uint index) public view returns (address) {
        return candidates[index];
    }

    
}
