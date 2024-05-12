import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('LeaseContract', function () {
  async function deployContractFixture() {
    // Contracts are deployed using the first signer/account by default
    const [landlord, tenant] = await ethers.getSigners();

    const rent = ethers.parseEther('1.0'); // 1 ETH rent per month
    const term = 12; // 12-month lease term
    const securityDeposit = ethers.parseEther('2.0'); // 2 ETH security deposit
    const earlyPenalty = ethers.parseEther('0.5'); // 0.5 ETH early termination penalty
    const location = '123 Main St, Anytown, USA'; // Location of the rental property

    const LeaseContract = await ethers.deployContract('LeaseContract', [
      rent,
      term,
      securityDeposit,
      earlyPenalty,
      location,
    ]);
    const leaseContract = await LeaseContract.waitForDeployment();

    return {
      leaseContract,
      landlord,
      tenant,
      rent,
      term,
      securityDeposit,
      earlyPenalty,
      location,
    };
  }

  it('deploys a contract', async () => {
    const { leaseContract } = await loadFixture(deployContractFixture);
    expect(ethers.isAddress(leaseContract.target)).to.true;
  });

  it('sign the lease with enough deposit', async () => {
    const { leaseContract, tenant, securityDeposit } = await loadFixture(
      deployContractFixture
    );

    const deposit = { value: securityDeposit };

    const blockTimestamp = (await ethers.provider.getBlock('latest'))
      ?.timestamp;

    // because this new external transaction (calling the signLease function from the tenant account)
    // will be included into the next block in the blockchain we should add 1 to the latest block
    await expect(leaseContract.connect(tenant).signLease(deposit))
      .to.emit(leaseContract, 'leaseSigned')
      .withArgs(tenant.address, (blockTimestamp || 0) + 1);
  });

  it('revert if sign the lease with not enough deposit', async () => {
    const { leaseContract, tenant, securityDeposit } = await loadFixture(
      deployContractFixture
    );

    const gap = ethers.parseEther('0.1');

    const deposit = { value: securityDeposit - gap };

    await expect(leaseContract.connect(tenant).signLease(deposit)).to.reverted;
  });
});

// to be continued
