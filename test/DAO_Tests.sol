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
        votingDAOTest.createProposal("Proposal 1");
    }

    function checkInitialProposal() public {
        Assert.equal(votingDAOTest.getProposalStatus(1), false, "Proposal 1 should not have passed initially");
    }

    function checkVotesAndProposalStatus() public {
        votingDAOTest.vote(1, true);
        Assert.equal(votingDAOTest.getProposalStatus(1), false, "Proposal 1 should not have passed with only 1 vote");

        votingDAOTest.vote(1, true);
        Assert.equal(votingDAOTest.getProposalStatus(1), true, "Proposal 1 should have passed with 2 votes");
    }

    function checkInvalidProposal() public {
        Assert.equal(votingDAOTest.getProposalStatus(100), false, "Invalid proposal ID should throw an error");
    }
} 