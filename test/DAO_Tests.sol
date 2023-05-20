// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../contracts/DAO.sol";

contract VotingDAOTest {

    VotingDAO votingDAOTest;
    
    function beforeAll() public {
        votingDAOTest = new VotingDAO(2);
        votingDAOTest.addVoter(address(0x123));
        votingDAOTest.addVoter(address(0x456));
        votingDAOTest.createProposal("Proposal 1", "");
    }

    function checkInitialProposal() public {
        VotingDAO.Proposal[] memory proposals = votingDAOTest.getProposalsWithCurrentStatuses(0, 1);
        Assert.equal(proposals.length, 1, "Should have 1 proposal");

        VotingDAO.Proposal memory proposal = proposals[0];
        Assert.equal(proposal.proposalName, "Proposal 1", "Incorrect proposal name");
        Assert.equal(proposal.description, "", "Incorrect proposal description");
        Assert.equal(proposal.yesVotes, 0, "Incorrect number of yes votes");
        Assert.equal(proposal.noVotes, 0, "Incorrect number of no votes");
    }

    function checkVotesAndProposalStatus() public {
        votingDAOTest.vote("Proposal 1", true);
        votingDAOTest.vote("Proposal 1", true);
        VotingDAO.Proposal[] memory proposals = votingDAOTest.getProposalsWithCurrentStatuses(0, 1);
        VotingDAO.Proposal memory proposal = proposals[0];

        Assert.equal(proposal.yesVotes, 2, "Incorrect number of yes votes");
        Assert.equal(proposal.noVotes, 0, "Incorrect number of no votes");
    }

    function checkInvalidProposal() public {
        VotingDAO.Proposal[] memory proposals = votingDAOTest.getProposalsWithCurrentStatuses(100, 100);
        Assert.equal(proposals.length, 0, "Invalid proposal ID should return an empty array");
    }
}
