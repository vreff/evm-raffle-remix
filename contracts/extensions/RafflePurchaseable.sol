// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

/** 
 * @title RafflePurchaseable
 * @notice Provides utilities to process raffle entry purchases
 */
abstract contract RafflePurchaseable {

    uint256 public balance;

    uint256 public price;

    function _purchase(uint256 quantity_) internal virtual {
        require(msg.value >= quantity_ * price, "amount must be at least quantity times price");
        balance += msg.value;
    }

    /**
    * @notice Sends contract balance to the winner; override for custom logic
    * @param winner The winners address
    */
    function _sendWinnings(address winner) internal virtual {
        _beforeSendWinnings();

        uint256 _toSend = balance;
        balance = 0;
        payable(winner).transfer(_toSend);
        
        _afterSendWinnings();
    }

    function _setPrice(uint256 price_) internal virtual {
        price = price_;
    }

    function _beforeSendWinnings() internal virtual {}

    function _afterSendWinnings() internal virtual {}

}
