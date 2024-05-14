import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('VotingProjectContract', function () {
  async function deployContractFixture() {
    // Contracts are deployed using the first signer/account by default
    const [chairPerson, account1, account2, account3, account4] =
      await ethers.getSigners();

    const proposals = ['proposal1', 'proposal2', 'proposal3', 'proposal4'];

    const VotingProject = await ethers.deployContract('VotingProject', [
      proposals,
    ]);
    const votingProject = await VotingProject.waitForDeployment();

    return {
      votingProject,
      proposals,
      chairPerson,
      account1,
      account2,
      account3,
      account4,
    };
  }

  it('deploys a contract', async () => {
    const { votingProject } = await loadFixture(deployContractFixture);
    expect(ethers.isAddress(votingProject.target)).to.true;
  });

  it('the chairperson can pick the correct winner', async () => {
    const { votingProject, chairPerson, account1 } = await loadFixture(
      deployContractFixture
    );

    // the chairperson allows the account1 address to vote
    await votingProject.connect(chairPerson).abilityToVote(account1);

    // account1 votes for proposal3 with index of 2
    await votingProject.connect(account1).vote(2);

    // pick the winner by the chairperson (in bigint)
    const winner = await votingProject.connect(chairPerson).winningProposal();

    expect(Number(winner)).to.equal(2);
  });

  it('revert on accounts beside the chairperson trying to pick the winner', async () => {
    const { votingProject, chairPerson, account1 } = await loadFixture(
      deployContractFixture
    );

    // the chairperson allows the account1 address to vote
    await votingProject.connect(chairPerson).abilityToVote(account1);

    // account1 votes for proposal3 with index of 2
    await votingProject.connect(account1).vote(2);

    await expect(
      votingProject.connect(account1).winningProposal()
    ).to.revertedWith('Only the chairperson can pick the winner.');
  });
});

// to be continued
