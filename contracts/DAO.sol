// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingDAO {
    
    address public owner;          // Owner of the contract
    uint public requiredVotes;     // Required number of votes to pass a proposal
    uint public proposalCount;     // Counter for proposals
    
    struct Proposal {
        uint id;
        string description;
        uint yesVotes;
        uint noVotes;
    }
    
    mapping(uint => Proposal) public proposals;
    mapping(address => bool) public voters;
    
    constructor(uint _requiredVotes) {
        owner = msg.sender;
        requiredVotes = _requiredVotes;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }
    
    function addVoter(address _voter) public onlyOwner {
        voters[_voter] = true;
    }
    
    function createProposal(string memory _description) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: _description,
            yesVotes: 0,
            noVotes: 0
        });
    }
    
    function vote(uint _proposalId, bool _vote) public {
        require(voters[msg.sender], "You are not authorized to vote.");
        
        Proposal storage proposal = proposals[_proposalId];
        
        if(_vote) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
    }
    
    function getProposalStatus(uint _proposalId) public view returns(bool) {
        require(_proposalId <= proposalCount, "Invalid proposal ID.");
        
        Proposal memory proposal = proposals[_proposalId];
        
        if(proposal.yesVotes >= requiredVotes) {
            return true;
        } else if(proposal.noVotes >= requiredVotes) {
            return false;
        } else {
            return false;
        }
    }
}
