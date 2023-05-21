// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingDAO {
    
    address public owner;          // Owner of the contract
    uint public requiredVotes;     // Required number of votes to pass a proposal
    enum CurrentStatus {NOT_STARTED, IN_PROGRESS, COMPLETED}

    struct Proposal {
        string proposalName;
        string description;
        uint yesVotes;
        uint noVotes;
        CurrentStatus status;
    }
    
    mapping(string => Proposal) public proposals;
    mapping(address => bool) public voters;
    mapping(uint => string) proposalIds;
    uint256 proposalIndex = 0;

    
    constructor(uint _requiredVotes) {
        owner = msg.sender;
        requiredVotes = _requiredVotes;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    modifier checkProposalDoesntExists(string memory _proposalName) {
        require(!compare(proposals[_proposalName].proposalName, _proposalName), "This proposal already exist!");    
        _;
    }

    modifier checkProposalExists(string memory _proposalName) {
        require(compare(proposals[_proposalName].proposalName, _proposalName), "This proposal doesnt exist!");    
        _;
    }

    modifier checkForVoter(address _voter) {
        require(voters[_voter] == false, "Voter has already voted or isn't authorized!");
        _;
    }

    function addVoter(address _voter) public checkForVoter(_voter) onlyOwner {
        voters[_voter] = false;
    }
    
    function createProposal(string memory _proposalName, string memory _description) public checkProposalDoesntExists(_proposalName) onlyOwner {
        proposals[_proposalName] = Proposal({
            proposalName:_proposalName,
            description: _description,
            yesVotes: 0,
            noVotes: 0,
            status: CurrentStatus.IN_PROGRESS
        });
        proposalIds[proposalIndex] = _proposalName;
        proposalIndex++;
    }
    
    function vote(string memory _proposalName, bool _vote) public checkProposalExists(_proposalName) checkForVoter(msg.sender) {
        Proposal storage proposal = proposals[_proposalName];
        
        if(_vote) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
        voters[msg.sender] = true;
    }
    
    function getProposalStatus(string memory _proposalName) public checkProposalExists(_proposalName)  view returns(bool) {
        Proposal memory proposal = proposals[_proposalName];
        
        if(proposal.yesVotes >= requiredVotes) {
            return true;
        } else if(proposal.noVotes >= requiredVotes) {
            return false;
        } else {
            proposal.status = CurrentStatus.IN_PROGRESS;
            return false;
        }
    }

    function getNumberOfProposals() public view returns(uint) {
        return proposalIndex;
    }

    function updateStatuses() public returns (bool) {
        for (uint i = 0; i <= proposalIndex; i++) {
            string memory id  = proposalIds[i];
            if(!compare(proposals[id].proposalName, ""))
            {
                if(proposals[id].yesVotes >= requiredVotes || proposals[id].noVotes >= requiredVotes)
                {
                    proposals[id].status = CurrentStatus.COMPLETED;
                }
            }
        }
        return true;
    }

    function getProposalsWithCurrentStatuses(uint from, uint to) public view returns (Proposal[] memory) {
        require(validatePagination(from, to), "Pagination coordinates exceeds limit!");
        Proposal[] memory proposalData = new Proposal[](to - from + 1);
        uint index = 0;
        for (uint i = from; i <= to; i++) {
            string memory id  = proposalIds[i];
            if(!compare(proposals[id].proposalName, "")){
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


    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    function validatePagination(uint from, uint to) private view returns(bool){
        if(from >=0  && to <= proposalIndex)
            return true;
        return false;
    }
}
