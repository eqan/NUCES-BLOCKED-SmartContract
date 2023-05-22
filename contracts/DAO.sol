// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingDAO {
    address public owner;          // Owner of the contract
    uint public requiredVotes;     // Required number of votes to pass a proposal
    enum CurrentStatus { NOT_STARTED, IN_PROGRESS, COMPLETED }

    struct Proposal {
        string proposalName;
        string description;
        uint yesVotes;
        uint noVotes;
        CurrentStatus status;
        mapping(address => bool) voters; // Track voter's votes per proposal
    }

    
    struct ProposalData {
        string proposalName;
        string description;
        uint yesVotes;
        uint noVotes;
        CurrentStatus status;
    }
    
    mapping(string => Proposal) public proposals;
    mapping(uint => string) public proposalIds;
    mapping(address => bool) private authorizedVoters;
    uint256 proposalIndex = 0;

    constructor(uint _requiredVotes) {
        owner = msg.sender;
        requiredVotes = _requiredVotes;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    modifier checkProposalDoesntExist(string memory _proposalName) {
        require(!compareStrings(proposals[_proposalName].proposalName, _proposalName), "This proposal already exists!");    
        _;
    }

    modifier checkProposalExists(string memory _proposalName) {
        require(compareStrings(proposals[_proposalName].proposalName, _proposalName), "This proposal doesn't exist!");    
        _;
    }

    modifier checkForVoter(address _voter, string memory _proposalName) {
        require(authorizedVoters[_voter] && !proposals[_proposalName].voters[_voter], "Voter has already voted or isn't authorized!");
        _;
    }

    function addVoter(address _voter) public onlyOwner {
        authorizedVoters[_voter] = true; // Add voter as authorized
    }
    
    function createProposal(string memory _proposalName, string memory _description) public checkProposalDoesntExist(_proposalName) onlyOwner {
        Proposal storage proposal = proposals[_proposalName];
        proposal.proposalName = _proposalName;
        proposal.description = _description;
        proposal.yesVotes = 0;
        proposal.noVotes = 0;
        proposal.status = CurrentStatus.IN_PROGRESS;
        proposalIds[proposalIndex] = _proposalName;
        proposalIndex++;
    }
    
    function getProposalsWithCurrentStatuses(uint from, uint to) public view returns (ProposalData[] memory) {
        require(validatePagination(from, to), "Pagination coordinates exceed the limit!");
        ProposalData[] memory proposalData = new ProposalData[](to - from + 1);
        uint index = 0;
        for (uint i = from; i <= to; i++) {
            string memory id  = proposalIds[i];
            if(!compareStrings(proposals[id].proposalName, "")){
                proposalData[index].proposalName = proposals[id].proposalName;
                proposalData[index].description = proposals[id].description;
                proposalData[index].yesVotes = proposals[id].yesVotes;
                proposalData[index].noVotes = proposals[id].noVotes;
                proposalData[index].status = proposals[id].status;
            }
            index++;
        }
        return proposalData;
    }

    function vote(string memory _proposalName, bool _vote) public checkProposalExists(_proposalName) checkForVoter(msg.sender, _proposalName) {
        Proposal storage proposal = proposals[_proposalName];
        
        if (_vote) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
        proposal.voters[msg.sender] = true; // Mark the voter as voted for the specific proposal
    }

    function getProposalStatus(string memory _proposalName) public checkProposalExists(_proposalName) view returns(bool) {
        if(proposals[_proposalName].yesVotes >= requiredVotes) {
            return true;
        } else if(proposals[_proposalName].noVotes >= requiredVotes) {
            return false;
        } else {
            return false;
        }
    }

    function getProposalStatusOfLatestProposal() public view returns(bool) {
        string memory proposalName = proposalIds[proposalIndex-1];
        
        if(proposals[proposalName].yesVotes >= requiredVotes) {
            return true;
        } else if(proposals[proposalName].noVotes >= requiredVotes) {
            return false;
        } else {
            return false;
        }
    }

    function getLatestProposalName() public view returns(string memory) {
        return proposalIds[proposalIndex-1];
    }

    function getNumberOfProposals() public view returns(uint) {
        return proposalIndex;
    }

    function updateStatuses() public onlyOwner returns (bool) {
        for (uint i = 0; i <= proposalIndex; i++) {
            string memory id  = proposalIds[i];
            if(!compareStrings(proposals[id].proposalName, "") && proposals[id].status == CurrentStatus.IN_PROGRESS){
                if(proposals[id].yesVotes >= requiredVotes)
                { proposals[id].status = CurrentStatus.COMPLETED; }
                else if(proposals[id].noVotes >= requiredVotes)
                { proposals[id].status = CurrentStatus.COMPLETED; }
                }
            }
        return true;
    }

    function validatePagination(uint from, uint to) private view returns(bool) {
        if (from >= 0 && from <= proposalIndex && to >= 0 && to <= proposalIndex && from <= to) {
            return true;
        }
        return false;
    }

    function compareStrings(string memory a, string memory b) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
