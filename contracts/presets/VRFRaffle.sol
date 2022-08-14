// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../Raffle.sol";
import "../extensions/RafflePurchaseable.sol";
import "../extensions/RaffleVRFRandomPick.sol";

/** 
 * @title VRFRaffle
 * @dev Provides a complete raffle system where entries are purchased at the entry
 *      price, the winner is selected using VRF, and the balance of all entries
 *      is sent to the winner.
 */
contract VRFRaffle is Ownable, Raffle, RafflePurchaseable, RaffleVRFRandomPick {

    constructor(
        uint256 entryCost,
        address vrfCoordinator
    ) RaffleVRFRandomPick(vrfCoordinator) {
        price = entryCost;
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
    function enter(uint16 qnty) external payable {
        _enter(qnty);
    }

    function pickWinner() external onlyOwner {
        _randomPickWinner();
    }

    function _enter(uint16 qnty) internal override {
        _purchase(qnty);
        super._enter(qnty);
    }

    function _resolveRandomPick(uint256 idx) internal override {
        address _winner = _pickWinner(idx);
        _sendWinnings(_winner);
    }

}
