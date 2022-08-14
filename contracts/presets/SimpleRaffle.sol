// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../Raffle.sol";
import "../extensions/RafflePurchaseable.sol";

/** 
 * @title SimpleRaffle
 * @dev Provides a complete raffle system where entries are purchased at the entry
 *      price, the winner is selected externally, and the balance of all entries
 *      is sent to the winner.
 */
contract SimpleRaffle is Ownable, Raffle, RafflePurchaseable {

    constructor(uint256 entryCost_) {
        price = entryCost_;
    }

    receive() external payable {
        _enter(1);
    }

    fallback() external payable {
        _enter(1);
    }
    
    /**
    * @notice Adds the sender to the list of raffle entries
    * @param qnty The number of entries to add for sender
    */
    function enter(uint256 qnty) external payable {
        _enter(qnty);
    }

    function pickWinner(uint256 idx) external onlyOwner returns(address) {
        address _winner = _pickWinner(idx);
        _sendWinnings(_winner);
        return _winner;
    }

    function _enter(uint256 qnty) internal override {
        _purchase(qnty);
        super._enter(qnty);
    }

}