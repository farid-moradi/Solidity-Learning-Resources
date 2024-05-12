import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';
import { ethers } from 'hardhat';

const LeaseContractModule = buildModule('LeaseContractModule', (m) => {
  // sample data for the contract. Later we get these values in a front-end application from a landlord or a landlady.
  const rent = ethers.parseEther('1.0'); // 1 ETH rent per month
  const term = 12; // 12-month lease term
  const securityDeposit = ethers.parseEther('2.0'); // 2 ETH security deposit
  const earlyPenalty = ethers.parseEther('0.5'); // 0.5 ETH early termination penalty
  const location = '123 Main St, Anytown, USA'; // Location of the rental property

  const leaseContract = m.contract('LeaseContract', [
    rent,
    term,
    securityDeposit,
    earlyPenalty,
    location,
  ]);

  return { leaseContract };
});

export default LeaseContractModule;
