// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Bank
 * @dev Creates a simple bank that allows customers to deposit and withdraw funds.
 */
contract Bank {
    mapping(address => uint) balances;
    address public owner;

    /**
     * @dev Constructor function to set the owner and initialize the balance of the contract owner.

     */
    constructor() payable {
        owner = msg.sender;
        balances[msg.sender] = msg.value;
    }

    /**
     * @dev Function to deposit funds.
     */

    function deposit() public payable {
        require(msg.value > 0, "Need to deposit more that 0.");
        balances[msg.sender] += msg.value;
    }

    /**
     * @dev Function to get the balance of the sender.
     * @return The balance of the sender.
     */
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /**
     * @dev Function to get the balance of an address.
     * @param _address The address for which the owner wants to get the balance.
     * @return The balance of the specified address.
     */
    function getBalanceByOwner(address _address) public view returns (uint) {
        require(msg.sender == owner, "You are not the owner.");
        return balances[_address];
    }

    /**
     * @dev Function to withdraw funds.
     * @param _amount The amount of funds the sender wants to withdraw.
     */
    function withdraw(uint _amount) public {
        // Checks
        require(
            _amount <= balances[msg.sender],
            "You are withdrawing more than you have."
        );
        // Effects
        balances[msg.sender] -= _amount;
        // Interactions
        payable(msg.sender).transfer(_amount);
    }

    /**
     * @dev Function to withdraw funds for a specified customer.
     * @param _customer The address for which the owner wants to withdraw funds.
     * @param _amount The amount of funds the sender wants to withdraw.
     */
    function withdrawOwner(address _customer, uint _amount) public {
        // Checks
        require(msg.sender == owner, "You are not the owner.");
        require(
            _amount <= balances[msg.sender],
            "The customer does not have enough funds to withdraw."
        );
        // Effects
        balances[_customer] -= _amount;
        // Interactions
        payable(_customer).transfer(_amount);
    }

    /**
     * @dev To receive funds sent directly to the contract.
     */
    receive() external payable {}
}
