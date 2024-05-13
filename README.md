# Solidity and Ethereum Notes

This repository contains a collection of notes covering various aspects of Solidity, the Ethereum Virtual Machine (EVM), and smart contract development. These notes are designed to serve as a valuable resource for individuals who are already familiar with Solidity and the EVM, and are looking to review the material in preparation for interviews or coding projects.

The content of these notes is primarily derived from four main sources:

1. **[Learn Ethereum 2](https://www.packtpub.com/product/learn-ethereum-second-edition/9781804616512)**
2. **[Solidity Documentation](https://docs.soliditylang.org/en/v0.8.25/)**
3. **[Smart Contract Security Field Guide](https://scsfg.io/)**
4. **[Consensys](https://consensys.io/blog/consensys-announces-the-sunset-of-truffle-and-ganache-and-new-hardhat)**


These notes are continually being refined and categorized for better organization and readability.

## Introduction

- Solidity code is compiled into bytecode, and it can be run on different platforms. The EVM on different platforms is compiled differently, but they can understand how to run the final bytecode.
- SPDX stands for Software Package Data Exchange.
- If you don't want to open-source the source code, you can use the UNLICENSED value.

## Solidity Components

- Solidity parts: data or state variables, functions, events, function modifiers, types (enums and structs), and collections with mapping.
- The state variables are defined at the contract level and permanently stored in the contract storage in the EVM.

## Ethereum Storage and Contracts

- The storage in Ethereum is like a key-value store (super important), where each variable has its unique storage slot identified by its position in the contract's storage layout. Solidity assigns storage slots to state variables in a deterministic way, which allows the Ethereum Virtual Machine (EVM) to access them efficiently.
- After issuing a contract creation transaction, the address of the contract is derived deterministically from the transaction and its context (nonce, the sender address, and bytecode).

## Calldata in Ethereum

- In Ethereum, when you send a transaction to a contract, you're essentially invoking a function or creating a new contract. The input data that you provide to this transaction, whether it's function parameters or contract creation bytecode, is collectively referred to as "calldata" (the transaction data field).
- Calldata is a special, read-only area where function arguments and data sent with a transaction are stored. Calldata is much cheaper to access compared to memory because it avoids the copying of data. You typically use calldata for parameters that are larger or dynamic in size, like strings or arrays.

## Creating a Smart Contract

- Write Solidity Code: The first step is to write the smart contract code using a language like Solidity. This code defines the logic and behavior of the contract, including its functions, state variables, and events.
- Compile the Code: Once the Solidity code is written, it needs to be compiled into bytecode that can be executed by the Ethereum Virtual Machine (EVM). This bytecode is essentially the machine-readable version of the contract code.
- Deploy the Contract: To deploy the contract to the Ethereum blockchain, you need to create a transaction that includes the contract creation bytecode in its data field. This transaction is sent to the Ethereum network to be included in a block.
- Transaction Execution: When a miner includes your contract creation transaction in a block and the block is successfully mined, the contract creation code is executed by the Ethereum network. This results in the creation of a new contract account on the blockchain.
- Determine Contract Address: The address of the newly created contract is deterministically derived based on factors such as the sender's address and nonce. This address uniquely identifies the contract on the blockchain.
- Initialization: If the contract has a constructor, it will be executed during contract creation to initialize the contract's state variables and perform any necessary setup.
- Contract Interaction: Once deployed, the contract can be interacted with by sending transactions to its address. This includes calling its functions, which involves providing function parameters as calldata, and reading or modifying its state variables.

## Visibility Levels and Data Types

- Internal is the default visibility level for state variables.
- When a function is public, it can be treated as internal or external.
- By defining a limited array size, the byte array is a lot cheaper and saves you gas.
- Hexadecimal literals are written as string literals, enclosed in single or double-quotes. They are prefixed with the `hex` keyword.
- `address` holds a 20-byte value (the size of an Ethereum address).
- `address payable` can receive Ether.

## Gas and Transactions

- When a user interacts with a smart contract and calls a function that results in a transaction, the user (external account) is responsible for providing the necessary gas to execute that transaction.
- The gas stipend is the amount of gas that the sender includes in the transaction beyond what's strictly necessary for the transaction's own execution. This extra gas serves as an allowance for the smart contract to perform its own operations without the sender needing to separately specify gas for each individual operation within the contract. It's a fixed amount set by the Ethereum protocol to ensure that transactions have a reasonable gas limit. If the stipend is insufficient to cover the recipient's gas costs, the transaction may fail due to out-of-gas conditions.

```solidity
contract EtherSender {
    // Function to send Ether to a specified recipient address
    function sendEther(address payable recipient) external payable {
        // Transfer the received Ether to the recipient address
        recipient.transfer(msg.value);
    }
}
```

- At first, each of Account1, Account2, and Account3 has 100 ETH. Account1 creates the `EtherSender` contract, which costs a bit of their ETH due to fees. Next, when Account2 uses the `EtherSender` contract to send 20 ETH to Account3, here's what happens: Account2 needs to provide the gas stipend for the transaction. The gas stipend covers the fees for executing the transaction, which are deducted from Account2's balance. The `EtherSender` contract moves 20 ETH from its balance to Account3's account. Account2 needs to pay for the transaction's fees. As a result, Account3 gets 20 more ETH, making their balance 120 ETH.

## Mappings and Data Types

- The key can be any built-in type, `bytes`, or `string`. The value can be any type, including user-defined types such as contract types, enums, mappings, and structs. When a new key-value pair is added to a mapping, Solidity computes the key's hash value using the cryptographic Keccak-256 hash function.
- In Solidity, reference types are data types that store references to data locations rather than the data itself. A `string` is a dynamically-sized array. These data types include arrays, structs, mappings, and strings. We also have value types, such as `uint`, `bool`, `address`, etc.
- When you pass value types as function parameters, they are automatically allocated in memory by default. Solidity handles the allocation and management of value types in memory without the need for explicit specification.
- All the data that has value types in the function call are passed by value.
- The lifetime of memory is limited to a function call.
- The stack has a limited size, which can maximally contain a size of 1,024 elements and words of 256 bits.
- Since storage data is stored in the blockchain, it is very expensive to use. To occupy a 256-bit slot costs 20,000 gas. Changing an occupied slot value costs 5,000 gas.

# Solidity Data Types and Memory Management

## String Variables and Memory

- When you declare a string variable, it holds a reference to the location in memory where the actual string data is stored.

## Stack and Memory

- The stack is used for storing local variables, function parameters, and function execution context. Variables that are small and of fixed size, such as integers, booleans, and fixed-size arrays, are typically stored in the stack. Memory is used for storing dynamically-sized data and larger data structures.

## View and Pure Functions

- The following are considered as modifying the state:
    - Writing to or updating the state variables
    - Constructing other contracts using constructors or self-destructing using `selfdestruct`
    - Emitting events or sending Ether via calls
    - Making calls to other non-view or non-pure functions, or any low-level call
    - Using inline assembly that contains certain opcodes for modifying the state
- The following are considered as reading the state:
    - Accessing state variables, the balance of any address, or its own balance
    - Accessing any of the members of a block, transaction, or message (with the exception of `msg.sig` and `msg.data`)
    - Calling any function that may read or modify the state
    - Using inline assembly that contains certain opcodes for reading the state
- When you call view or pure functions externally, you do not pay a gas fee.

## Constructors and Fallback Functions

- You can't overload a constructor.
- The fallback function is executed on a call to the contract if none of the other functions match the given function signature, or if no data was supplied at all and there is no `receive` Ether function. The fallback function always receives data, but in order to also receive Ether, it must be marked `payable`.

```solidity
// Any call with non-empty calldata to this contract will execute
// the fallback function (even if Ether is sent along with the call).
fallback() external payable { x = 1; y = msg.value; }

// This function is called for plain Ether transfers, i.e.
// for every call with empty calldata.
receive() external payable { x = 2; y = msg.value; }
```

- In simple terms, the fallback function is invoked when an undefined function is called, while the `receive` function is invoked when Ether is sent directly to the contract without a function call.
- If neither a `receive` Ether nor a `payable` fallback function is present, the contract cannot receive Ether through a transaction that does not represent a payable function call and throws an exception.

## Function Overloading

- Return types don't count as part of the overloading resolution.

## Smart Contract Design Principles

- In smart contract development, it's essential to anticipate the need for future modifications and ensure flexibility and extensibility in the contract design. Since smart contracts are immutable once deployed, consider defining generic modifiers or functions in base contracts during design time. These generic elements can be extended or overridden in child contracts to accommodate future changes or additional functionalities. By making thoughtful design choices and planning for potential modifications, you can enhance the adaptability and longevity of your smart contracts.

## Events and Logging

- DApps can subscribe and listen to events through the Web3 JSON-RPC interface.
- Indexed parameters enable efficient event filtering and searching when querying logs on the Ethereum blockchain. When querying event logs using tools like `web3.js` or `ethers.js`, you can specify filters based on indexed parameters to retrieve only the logs that match certain criteria. This can significantly improve the efficiency of log retrieval, especially in cases where there are many events logged on the blockchain. We can only index up to three parameters per event.
- Similar to function modifiers, events are inheritable members of contracts.

## Libraries in Ethereum

- Once libraries are deployed on the Ethereum network, they will be assigned a contract address. The properties and functions defined in the libraries can be called and reused many times by other contracts. They save on gas since the same code is not deployed multiple times.
- All data is passed to the library by the calling contract using `DELEGATECALL`. `DELEGATECALL` basically calls another contract's function but within its own context, meaning all state variables, including storage and memory, are passing from the calling contract.

## Addresses and Access Control

- `tx.origin` refers to the original sender of the transaction, which is an external account (EOA).
- `msg.sender` refers to the immediate sender of the current message or call within the EVM, which can be either an external account or a contract address, depending on the context.
- Using `tx.origin` for access control is generally discouraged due to potential security vulnerabilities, such as "cross-contract access" attack also known as a "chain-of-calls" attack or "untrusted contract" attack. Instead, it's recommended to rely on `msg.sender` for most access control purposes within smart contracts.

## Object-Oriented Programming in Solidity

- Inheritance enables code reuse and extensibility.
- Encapsulation refers to information hiding and bundling data within methods to avoid unauthorized direct access to the data.
- Abstraction is the process of exposing only the necessary information and hiding the details from other objects.
- Polymorphism allows functional extensibility via the overloading and overriding functions.

## Abstract Contracts and Interfaces

- An abstract contract serves as a blueprint for other contracts to inherit from, providing a partial implementation while leaving certain functions undefined. They are particularly useful when you want to define a common structure or behavior for a set of contracts but leave certain details to be implemented by inheriting contracts.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define an interface for a token contract
interface IToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

// A contract that uses the IToken interface
contract TokenUser {
    IToken public token;

    constructor(IToken _token) {
        token = _token;
    }

    function transferTokens(address recipient, uint256 amount) external {
        require(token.transfer(recipient, amount), "Transfer failed");
    }
}
```

- In this example, `IToken` is an interface that defines the `transfer` and `balanceOf` functions that a token contract should implement. The `TokenUser` contract can then interact with any contract that implements the `IToken` interface.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define an abstract contract
abstract contract AbstractToken {
    mapping(address => uint256) internal balances;

    function balanceOf(address account) public view virtual returns (uint256) {
        return balances[account];
    }

    function _transfer(address from, address to, uint256 amount) internal virtual;
}

// Inherit from the abstract contract and provide implementation for _transfer
contract MyToken is AbstractToken {
    function _transfer(address from, address to, uint256 amount) internal override {
        balances[from] -= amount;
        balances[to] += amount;
    }

    function transfer(address recipient, uint256 amount) external {
        _transfer(msg.sender, recipient, amount);
    }
}
```

- In this example, `AbstractToken` is an abstract contract that defines the `balanceOf` function and declares an abstract `_transfer` function. The MyToken contract inherits from AbstractToken and provides an implementation for the _transfer function. The transfer function in MyToken can then use the _transfer function for transferring tokens.

## Abstract Contracts and Interfaces
- In the case of abstract methods, the derived contract (e.g., `MyToken`) must provide an implementation for all the abstract methods (e.g., `_transfer`).
- In the case of interfaces, the derived contract must implement all the methods defined in the interface.
- Interfaces cannot declare state variables and cannot declare modifiers. All functions declared in an interface must be `external`.
- Abstract contracts are useful for defining base template methods and making the contract design more modular and extensible.
- Abstract contracts and interfaces are not instantiable (cannot be created as objects).

## Enums
- Enums are defined like this: `enum OrderType { PhoneOrder, MailOrder, InternetOrder }` (without a semicolon).
- Types defined in an interface can be accessed using the interface name, e.g., `interface_name.OrderType`.

## Inheritance
- The diamond problem refers to the case where one contract extends from two other contracts, and both extend from a common parent contract.
- The order in the inheritance definition is essential in determining how overriding functions are applied. Comprehensive testing and caution are needed in such cases. It's best to avoid the diamond problem if possible.

## Application Binary Interface (ABI)
- When interacting with smart contracts on the Ethereum blockchain, the Ethereum Web3 API or JSON-API interface uses the contract's Application Binary Interface (ABI) as the standard way to encode and decode the methods we call, as well as the input and output data.
- When a method is called, its function selector is computed as the first 4 bytes of the `keccak256` hash of the method's signature. This selector uniquely identifies the method.
- The method's arguments are then ABI-encoded into a byte array and concatenated with the function selector to form the complete input data for the method's execution.
- In a transaction meant to call a function of a smart contract on the Ethereum network, the method selector is located in the first four bytes of the data field.
- Example: `bytes4 selector = bytes4(keccak256("doSomething(uint256)")));`

## Gas and Immutability
- The EVM executes the contract code as it processes the transactions within a newly mined block.
- Gas limit is paid for upfront, regardless of how much gas is actually consumed during execution. Even if the actual gas consumed ends up being less than the specified gas limit, the sender still has to pay for the entire gas limit they set. Any unused gas is refunded to the sender.
- Once deployed, a smart contract is considered immutable. Therefore, smart contracts must be designed to be flexible, extensible, and maintainable, as there are costs associated with running them on the Ethereum network.

## Smart Contract Security
- As a general coding practice, it is recommended to check math calculations for overflows and underflows to ensure appropriate assertions are made about function inputs, return values, and contract state, and to ensure that only authorized parties can transact with your contract.
- In Solidity, pay special attention to external contract calls, smart contract execution costs, and reentrancy issues associated with DAO attacks.
- Resources for security: `scsfg.io/`, `ccs18-security.pdf`, Solidity documentation, `securitfy2`.
- Have a modular design and keep your smart contracts small and simple. Move unrelated functionality to other contracts or libraries.
- Simplify the contract inheritance hierarchy and avoid unnecessary complexity in OO design.
- Focus on the distinction between built-in global functions like send, transfer, and value. The send function returns a boolean value to signify the success or failure of the transfer. It comes with a gas stipend of 2,300 gas units, generally sufficient for typical transfers. However, if the recipient is a contract and its fallback function consumes more than 2,300 gas, the transfer may fail. On the other hand, the transfer function includes a built-in safety mechanism. If the transfer fails or if the recipient is a contract that throws an exception, the entire transaction will be reverted.

# Reentrancy Attacks

## Checks-Effects-Interactions Pattern

- To avoid reentrancy attacks, you can use the **checks-effects-interactions pattern:** we save the balance in a temporary variable, reduce the transfer amount first from the state variable storing balances, and finally send the stored balance in the temporary variable to the sender of the request. Although the preceding approach prevents repeated withdrawal from the Escrow account, it may not stop reentrancy. As a side effect of reentrancy, it continues to burn gas.

## Pull-Payment Method

- Another approach to avoid the reentrancy attack is the **pull-payment method**. The **pull-payment method** is a pattern where the recipient of Ether needs to actively "pull" or withdraw the funds from the contract, instead of the contract "pushing" or sending the funds to the recipient's address. It simply means that we use a function like `withdraw` to send Ether to the recipient using the `transfer` method.
- Pull-payment may still fail to be a good solution because the gas cost change in the network, and the internal transaction may fail due to a fixed 2300 gas forward and revert the whole transaction.

## Design Patterns to Avoid Reentrancy

Two very good design patterns to avoid reentrancy attack and the risk of getting a ran out of gas exception by calling the `withdraw` function are:

1. Using locks with OpenZeppelin's `ReentrancyGuard` and use the `call` function to send Ether, which forwards all the remaining gas of the contract that calls the `withdraw` function.
2. Use the `call` function to send Ether and use a gas limit assertion within the `withdraw` function using **`gasLeft`**.

## Contract Reference

- In `e = Escrow(vulnerable)`, `e` is a reference to the `Escrow` contract located at the address `vulnerable`.

## Transactions and Internal Calls

- A single transaction can involve multiple calls to different contracts or functions within the same contract.
- Eventually, if the gas provided for the original transaction is exhausted, the entire transaction will revert, and any **state changes made within the transaction will be reverted**.
- When a contract function is called (either directly from an EOA transaction or from another contract function), it can perform various operations, including calling functions on other contracts. **These function calls between contracts are not separate transactions but rather internal message calls or internal transactions**. Internal message calls are executed as part of the same transaction that initiated the contract function call. They do not create a new transaction that needs to be included in a separate block. The key point is that reentrancy attacks can cause excessive gas consumption by repeatedly making internal message calls within the same transaction, potentially leading to an out-of-gas error and a failed transaction.

## Ether Transfer Functions
- Pay special attention to the functional differences between built-in global functions such as `send`, `transfer`, and `value`.
- The `send` function returns a boolean value indicating whether the transfer was successful or not. It has a gas stipend of 2,300 gas units, which is typically enough for most transfers. However, if the recipient is a contract, and its fallback function consumes more than 2,300 gas, the transfer may fail.
- The `transfer` function has a built-in safety mechanism. If the transfer fails or if the recipient is a contract that throws an exception, the entire transaction will be reverted.

## Accounts and Function Calls in Ethereum

In Ethereum, there are two types of accounts: externally owned accounts (EOAs) controlled by private keys, and contract accounts, which are deployed smart contracts.

## External vs. Internal Function Calls

- Transactions can only be initiated from externally owned accounts (EOAs). Contract accounts cannot initiate transactions themselves; they can only execute code in response to receiving transactions or message calls.

### External Function Calls (Transactions)

- They are initiated from an EOA, not a contract account.
- They require gas to be executed, and the gas cost is paid by the EOA initiating the transaction.
- They are recorded on the Ethereum blockchain as transactions.
- They can be used to deploy new contracts or call functions on existing contracts.
- They can transfer Ether (the native cryptocurrency) between accounts.
- They are atomic, meaning either all state changes succeed, or none of them does (if the transaction runs out of gas or encounters an error).

### Internal Function Calls (Message Calls)

- An internal function call, also known as a message call, is initiated from a contract account to another contract account. It is not a top-level call and does not get broadcasted to the Ethereum network or included in a new block.
- They are initiated from a contract account, not an EOA.
- They execute code within the context of the external transaction that triggered the contract execution.
- They are not recorded on the Ethereum blockchain as separate transactions.
- They cannot transfer Ether between accounts directly.
- They can be nested, meaning a contract can call another contract, which can call another contract, and so on.
- They share the same gas pool as the external transaction that triggered the contract execution. If the cumulative gas used by all internal function calls exceeds the gas limit of the external transaction, the entire transaction (including all internal function calls) is reverted.
- When a contract invokes another contract using `call`, by default, it forwards all remaining gas from the current transaction to the callee contract.

## State Machines and Proxy Patterns

- The state machine is a behavioral design pattern. It allows a contract to change its behavior when its internal state is updated. A smart contract function call typically will move a contract's state from one stage to the next.
- This is a proxy design pattern and a popular technique that decouples DApps from the actual smart contract implementation and has the proxy as the agent sitting in between them.
- Although it is not possible to upgrade the code of your already deployed smart contract, it is possible to set-up a proxy contract architecture that will allow you to use new deployed contracts as if your main logic had been upgraded.
- A proxy architecture pattern is such that all message calls go through a Proxy contract that will redirect them to the latest deployed contract logic. To upgrade, a new version of your contract is deployed, and the Proxy is updated to reference the new contract address. The proxy contract uses a custom fallback function to redirect calls to other contract implementations.

## Proxy Contract Implementation

- When the invocation comes, the proxy will look up the address of the latest version and delegate the call to the `OrderDelegate` smart contract via `delegatecall()` methods.
- Whenever a contract A delegates a call to another contract B, it executes the code of contract B in the context of contract A. This means that `msg.value` and `msg.sender` values will be kept, and every storage modification will impact the storage of contract A.
- Since the `delegatecall()` function only returns `true` or `false`, you will need to use inline assembly to make `delegatecall` if you need to get the return results from the target functions.

```solidity
function () payable public {
    address _impl = implementation();
    require(_impl != address(0));

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
```

- `mload` is an opcode that loads a word (32 bytes) from memory at a given location.
- In Solidity, dynamic data types are stored in a specific way: the first 32 bytes (or one "word" in memory) contain the length of the dynamic data, and the rest of the bytes contain the actual data.
- Instead of manually calculating where the actual data starts in `msg.data` and copying it over, we can use `calldatasize` to get the size of `msg.data`, and then `calldatacopy` to copy it directly into our memory buffer (`ptr`).
- In Solidity, the memory slot at position `0x40` is special as it contains the value for the next available free memory pointer.
- In order to delegate a call to another Solidity contract function, we have to pass it the `msg.data` the proxy received. Since `msg.data` is of type `bytes`, a dynamic data structure, it has a varying size that is stored in the first word size (of 32 bytes) in `msg.data`. If we wanted to extract just the actual data, we would need to step over the first word size, and start at `0x20` (32 bytes) of `msg.data`. However, there are two opcodes we'll leverage to do this instead. We'll use `calldatasize` to get the size of `msg.data` and `calldatacopy` to copy it over to our `ptr` variable.

### Opcodes Used

- `calldatasize`: size of call data in bytes
- `calldatacopy(t, f, s)`: copy `s` bytes from calldata at position `f` to memory at position `t`

## Proxy Pattern Approaches

- OpenZeppelin proposes three patterns for developing an upgradable contract: Upgradeability using Inherited Storage, Unstructured Storage, and Eternal Storage.
- The three approaches have different ways to tackle the same technical difficulty: how to ensure that the logic contract does not overwrite state variables that are used in the proxy for upgradeability.
- We call the proxy contract the storage layer and the contract versions the logic layer.
- This means that if the Proxy contract has a state variable to keep track of the latest logic contract address at some storage slot and the logic contract doesn't know about it, then the logic contract could store some other data in the same slot, thus overwriting the proxy's critical information.

# Gas and Data Storage Costs

- Regarding on-chain data usage, stack variables are normally the cheapest to use and can be used for any value type, that is, anything that is 32 bytes or less. They are packed as 32 bytes at the EVM level.
- Calldata is the read-only byte array, and every byte of the calldata costs gas, so a function with more arguments or a large calldata size will always cost more gas. It is relatively cheap to load variables directly from calldata, rather than copying them to memory. However, for complex types or dynamic-sized arrays, you may not have many options except resorting to memory data storage.
- In EVM, memory is a linearly addressable read-writable byte array. Complex types, including structs, arrays, and strings, must be stored in memory, and the size can be dynamically expanded. (In a sense, stack is like stack in the computer programming world, and memory is like the heap). When making external smart contract calls, all the arguments have to be copied into a memory location, which incurs costs. Compared to storage data, it is still cheap, but the cost of memory can grow quadratically.
- Storage in Ethereum is a persistent and read-writable key-value store that maps keys to values. Both are 256-bit words.

# Smart Contract Categories

- There are smart contracts and protocols classified into roughly three categories: Smart Legal Contracts, DAO, and Application Logic Contracts (ALCs).

# Exploring the Lifecycle of a Contract Transaction

## The Simple Contract

Consider a very simple contract:

```solidity
contract Simple {
    int public x;
    
    function addX() public {
        x++;
    }
}
```

An Ethereum node runs a client like Geth, utilizing levelDB to store the world state.

- Upon compiling the code for a contract, an ABI and bytecode are generated. The contract is then deployed on the Ethereum network (main or test) by sending a transaction with an empty `to` field, including the contract's bytecode in the `data` field. A unique contract address is generated upon deployment.

- A user initiates a transaction to call the `addX` function of the `Simple` contract, specifying the gas limit for the transaction.

- The transaction is broadcasted to the Ethereum network, containing the contract address in the `to` field, the function selector for `addX` in the `data` field, and the specified gas limit.

- A miner includes the transaction in a block and attempts to mine the block. The gas limit acts as a constraint for the miner's block selection process.

- The miner successfully mines the block by solving a cryptographic puzzle. The block includes the transaction calling the `addX` function and other transactions.

- During block validation, the Ethereum Virtual Machine (EVM) executes the bytecode associated with the `addX` function.

- The gas consumed during function execution is tracked. If it exceeds the gas limit specified in the transaction, the transaction fails due to an "Out of Gas" error.

- If the gas consumed is within the gas limit, the state variable `x` is incremented by 1 as specified in the function.

- The updated state of the `Simple` contract, including the incremented value of `x`, is added to the miner's copy of the blockchain and propagated to other nodes.

- Other nodes in the network receive the newly mined block, verify its validity, and update their own copies of the blockchain and world state to match the newly mined block. Consensus mechanisms ensure agreement among nodes, maintaining the integrity and security of the blockchain.

## View Functions

- If the function being called is a `view` function and does not change the state of the world state, you can call it directly from your Ethereum client without creating a transaction. However, if the function modifies the state, then you will need to create a transaction and go through the process of mining and block inclusion, even if the state changes are minimal or non-existent.