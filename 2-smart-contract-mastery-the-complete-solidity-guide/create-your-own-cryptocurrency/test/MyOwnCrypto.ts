import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('MyOwnCrypto', function () {
  async function deployContractFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, account1, account2] = await ethers.getSigners();
    const name = 'MyOwnCrypto';
    const symbol = 'MOC';
    const initialSupply = 1000;
    const initialOwnerTokens = 100;

    const MyOwnCrypto = await ethers.deployContract('MyOwnCrypto', [
      name,
      symbol,
      initialSupply,
      initialOwnerTokens,
    ]);
    const myOwnCrypto = await MyOwnCrypto.waitForDeployment();

    return {
      myOwnCrypto,
      owner,
      account1,
      account2,
      initialSupply,
      initialOwnerTokens,
    };
  }

  it('deploys a contract', async () => {
    const { myOwnCrypto } = await loadFixture(deployContractFixture);
    expect(ethers.isAddress(myOwnCrypto.target)).to.true;
  });

  it('owner has the initial minted tokens at first', async () => {
    const { myOwnCrypto, owner, initialOwnerTokens } = await loadFixture(
      deployContractFixture
    );

    const ownerBalance = await myOwnCrypto.connect(owner).balanceOf(owner);
    expect(Number(ethers.formatEther(ownerBalance))).to.equal(
      initialOwnerTokens
    );
  });

  it('should have the correct initial total supply', async () => {
    const { myOwnCrypto, initialOwnerTokens } = await loadFixture(
      deployContractFixture
    );

    // the totalBalance is equal to the number of tokens minted so far (at beginning)
    const supply = await myOwnCrypto.totalSupply();
    expect(Number(ethers.formatEther(supply))).to.equal(initialOwnerTokens);
  });
});

// to be continued
