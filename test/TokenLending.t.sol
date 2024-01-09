// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@jarvis-network/uma-core/contracts/common/implementation/FixedPoint.sol";
import "@jarvis-network/uma-core/contracts/financial-templates/common/interfaces/ExpandedIERC20.sol";
import "foundry/contracts/MasterDeployer.sol";
import "foundry/contracts/FinancialTemplates/contracts/TokenLendingPool.sol";

contract TestTokenLending {
    TokenLendingPool lendingPool;
    ExpandedIERC20 token;

    constructor(TokenLendingPool _lendingPool, ExpandedIERC20 _token) {
        lendingPool = _lendingPool;
        token = _token;
    }

    function testDepositAndWithdraw() external {
        uint256 initialBalance = token.balanceOf(address(this));
        uint256 depositAmount = 100;

        // Deposit tokens
        token.transferFrom(address(this), address(lendingPool), depositAmount);

        // Check user balance in the lending pool
        assert(token.balanceOf(address(lendingPool), address(this)) == depositAmount);

        // Withdraw tokens from the lending pool
        lendingPool.withdraw(depositAmount);

        // Check user balance after withdrawal
        assert(token.balanceOf(address(this)) == initialBalance);
    }

    function testBorrowAndRepay() external {
        uint256 initialBalance = token.balanceOf(address(this));
        uint256 borrowAmount = 100;

        // Deposit tokens to the lending pool
        token.transferFrom(address(this), address(lendingPool), borrowAmount);

        // Borrow tokens from the lending pool
        lendingPool.borrow(borrowAmount);

        // Check user borrowed amount in the lending pool
        assert(lendingPool.borrowedAmounts(address(this)) == borrowAmount);

        // Repay borrowed tokens to the lending pool
        token.transferFrom(address(this), address(lendingPool), borrowAmount);
        lendingPool.repay(borrowAmount);

        // Check user borrowed amount after repayment
        assert(lendingPool.borrowedAmounts(address(this)) == 0);

        // Check user balance after borrowing and repayment
        assert(token.balanceOf(address(this)) == initialBalance);
    }
}