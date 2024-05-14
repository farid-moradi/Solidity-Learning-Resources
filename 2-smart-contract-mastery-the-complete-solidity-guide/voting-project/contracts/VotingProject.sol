// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18 <0.9.0;

/**
 * @title VotingProject
 * @dev This contract implements a voting system with support for delegation.
 *      It allows the chairperson to create proposals and grant voting rights to addresses.
 *      Voters can vote for a proposal, delegate their vote to another voter, and determine the winning proposal.
 */
contract VotingProject {
    // @dev Represents a voter and stores their voting status and weight.
    struct Voter {
        bool votedOrNot; // Whether the voter has already voted
        uint weight; // The weight or voting power of the voter
    }

    // @dev Stores the delegations from one voter to another.
    // We decouple the delegation logic from the Voter struct to optimize storage when delegation is not used.
    mapping(address => address) public delegations;

    // @dev Stores the index of the proposal that an address has voted for.
    // Using a mapping instead of storing in the Voter struct optimizes storage when voters do not participate.
    mapping(address => uint) public votedProposalIndex;

    // @dev Represents a proposal with its name and vote count.
    struct Proposal {
        string name; // The name or description of the proposal
        uint voteCount; // The number of votes received for this proposal
    }

    // @dev The address of the person who created the contract and has the authority to pick the winner.
    address public chairperson;

    // @dev An array of all the proposals in the voting.
    Proposal[] public proposals;

    // @dev Mapping of addresses to their respective Voter struct.
    mapping(address => Voter) public voters;

    /**
     * @dev Constructor that initializes the contract with a list of proposal names.
     * @param proposalNames An array of strings representing the names of the proposals.
     */
    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;

        // For every proposal name, we construct a Proposal struct and add it to the proposals array.
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    /**
     * @dev Allows a voter to cast their vote for a specific proposal.
     * @param proposalIndex The index of the proposal to vote for.
     * @notice Requires that the voter has not already voted and has the right to vote.
     *         Updates the voter's voting status, the voted proposal index, and the vote count for the chosen proposal.
     */
    function vote(uint proposalIndex) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.votedOrNot, "You have already voted.");
        require(sender.weight != 0, "You do not have the right to vote.");
        sender.votedOrNot = true;
        votedProposalIndex[msg.sender] = proposalIndex;
        proposals[proposalIndex].voteCount += sender.weight;
    }

    /**
     * @dev Allows the chairperson to grant voting rights to a specific address.
     * @param voter The address to grant voting rights to.
     * @notice Requires that the caller is the chairperson, and the given address has not already voted and has no weight.
     *         Sets the weight of the given address to 1, allowing them to vote.
     */
    function abilityToVote(address voter) public onlyChairpersonAllowsVoters {
        require(!voters[voter].votedOrNot, "The voter has already voted.");
        require(
            voters[voter].weight == 0,
            "The voter already has voting rights."
        );
        voters[voter].weight = 1;
    }

    /**
     * @dev Determines the winning proposal based on the highest vote count.
     * @return winningProposalIndex The index of the winning proposal.
     * @notice Requires that the caller is the chairperson.
     */
    function winningProposal()
        public
        view
        onlyChairpersonPickWinner
        returns (uint winningProposalIndex)
    {
        uint winningVoteCount = 0; // The current highest vote count

        for (uint i = 0; i < proposals.length; i++) {
            // If the current proposal has a higher vote count, update the winning proposal index and vote count.
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalIndex = i;
            }
        }
    }

    /**
     * @dev Allows a voter to delegate their vote to another voter.
     * @param to The address to delegate the vote to.
     * @notice Requires that the voter has not already voted, cannot delegate to themselves, and avoids infinite delegation loops.
     *         Updates the voter's voting status, the delegations mapping, and the vote count or weight of the delegated voter.
     */
    function delegate(address to) public {
        Voter storage voter = voters[msg.sender];
        require(!voter.votedOrNot, "You have already voted.");
        require(to != msg.sender, "You cannot delegate to yourself.");

        // Follow the chain of delegation and ensure there are no infinite loops.
        address _to = to;
        while (_to != address(0)) {
            _to = delegations[_to];
            require(_to != msg.sender, "Found an infinite delegation loop.");
        }

        voter.votedOrNot = true;
        delegations[msg.sender] = to;

        Voter storage _delegate = voters[to];
        if (_delegate.votedOrNot) {
            // If the delegated voter has already voted, increment the vote count for their chosen proposal.
            proposals[votedProposalIndex[to]].voteCount += voter.weight;
        } else {
            // If the delegated voter has not voted yet, increment their weight by the delegating voter's weight.
            _delegate.weight += voter.weight;
        }
    }

    /**
     * @dev Returns the name of the winning proposal.
     * @return winnerName The name of the winning proposal.
     */
    function winnerProposalName()
        public
        view
        returns (string memory winnerName)
    {
        winnerName = proposals[winningProposal()].name;
    }

    /**
     * @dev Modifier that restricts a function to be called only by the chairperson.
     */
    modifier onlyChairpersonAllowsVoters() {
        require(
            msg.sender == chairperson,
            "Only the chairperson can grant voting rights."
        );
        _;
    }

    /**
     * @dev Modifier that restricts a function to be called only by the chairperson.
     */
    modifier onlyChairpersonPickWinner() {
        require(
            msg.sender == chairperson,
            "Only the chairperson can pick the winner."
        );
        _;
    }
}
