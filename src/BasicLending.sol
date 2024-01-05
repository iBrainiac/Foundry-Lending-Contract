// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//A simple lending contract allowing deposit, withdrawal, borrowing, and repayment of Ether.
 
contract BasicLending {
    // Mapping of lender addresses to their deposited balances
    mapping(address => uint256) public  balances;

    // Mapping of borrower addresses to their borrowed amounts
    mapping(address => uint256) public  borrowedAmounts;

    // Event for Ethers deposited into the contract
    event Deposit(address indexed lender, uint256 amount);

    // Event for Ethers withdrawn from the contract
    event Withdraw(address indexed lender, uint256 amount);

    // Event for Ethers borrowed from the contract
    event Borrow(address indexed borrower, uint256 amount);

    // Event for Ethers repaid to the contract
    event Repay(address indexed borrower, uint256 amount);

    // @notice Allows a user to deposit Ether into the contract.
     
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

     // Allows a user to withdraw Ether from their balance in the contract.
     //param amount The amount of Ether to withdraw.
     
    function withdraw(uint256 amount) external {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    //@notice Allows a user to borrow Ether from the contract.
     //@param amount The amount of Ether to borrow.
    
    function borrow(uint256 amount) external {
        require(amount <= address(this).balance, "Insufficient contract balance");
        require(amount > 0, "Borrow amount must be greater than 0");
        borrowedAmounts[msg.sender] += amount;
        payable(msg.sender).transfer(amount);
        emit Borrow(msg.sender, amount);
    }

    //@notice Allows a user to repay borrowed Ether to the contract.
    
    function repay() external payable {
        uint256 borrowed = borrowedAmounts[msg.sender];
        require(msg.value > 0, "Repay amount must be greater than 0");
        require(msg.value <= borrowed, "Repayment amount exceeds borrowed amount");
        borrowedAmounts[msg.sender] -= msg.value;
        emit Repay(msg.sender, msg.value);
    }

    //@notice Get the balance of the caller.
    
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    // @notice Get the borrowed amount of the caller.
    
    function getBorrowedAmount() external view returns (uint256) {
        return borrowedAmounts[msg.sender];
    }
}