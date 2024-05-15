// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title MyOwnCrypto
 * @dev Extends ERC20 and AccessControl from OpenZeppelin contracts to create a custom ERC20 token with minting capabilities.
 */
contract MyOwnCrypto is ERC20, AccessControl {
    // Total supply of tokens available
    uint totalSupplyOfTokensAvailable;
    // Address of the owner
    address owner;

    /**
     * @dev Constructor function to initialize the ERC20 token.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _totalSupplyOfTokensAvailable The initial supply of the token.
     * @param _initalMint The minted tokens to the creator of the contract.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint _totalSupplyOfTokensAvailable,
        uint _initalMint
    ) ERC20(_name, _symbol) {
        owner = msg.sender;
        // Set the total supply of the token
        totalSupplyOfTokensAvailable =
            _totalSupplyOfTokensAvailable *
            10 ** decimals();
        // Mint initial supply to the contract deployer
        _mint(msg.sender, _initalMint * 10 ** decimals());
        // Grant DEFAULT_ADMIN_ROLE to the contract deployer
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev Function to mint new tokens.
     * @param to The address to which new tokens will be minted.
     * @param amount The amount of tokens to mint.
     */
    function mint(
        address to,
        uint256 amount
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        // Ensure the total supply after minting does not exceed the total supply cap
        require(
            totalSupply() + amount <= totalSupplyOfTokensAvailable,
            "We have no more token to mint."
        );
        // Mint new tokens
        _mint(to, amount);
    }
}
