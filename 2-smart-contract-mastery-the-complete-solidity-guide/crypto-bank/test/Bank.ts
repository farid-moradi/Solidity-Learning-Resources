import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Bank', function () {
  async function deployContractFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, account1, account2] = await ethers.getSigners();
    const initalBalance = ethers.parseEther('200');

    const Bank = await ethers.deployContract('Bank', { value: initalBalance });
    const bank = await Bank.waitForDeployment();

    return {
      bank,
      owner,
      account1,
      account2,
      initalBalance,
    };
  }

  it('deploys a contract', async () => {
    const { bank } = await loadFixture(deployContractFixture);
    expect(ethers.isAddress(bank.target)).to.true;
  });

  it('balance of the owner should be equal to the initial balance at first', async () => {
    const { bank, owner, initalBalance } = await loadFixture(
      deployContractFixture
    );
    const ownerBalance = await bank.connect(owner).getBalance();
    expect(ownerBalance).to.equal(initalBalance);
  });
});

// to be continued
