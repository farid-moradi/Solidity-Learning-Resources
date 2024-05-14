import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';

const VotingProjectModule = buildModule('VotingProjectModule', (m) => {
  const votingProject = m.contract('VotingProject', [
    'proposal1',
    'proposal2',
    'proposal3',
  ]);

  return { votingProject };
});

export default VotingProjectModule;
