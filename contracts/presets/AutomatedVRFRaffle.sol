// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../Raffle.sol";
import "../extensions/RafflePurchaseable.sol";
import "../extensions/RaffleVRFRandomPick.sol";
import "../extensions/RaffleAutomatable.sol";

/** 
 * @title AutomatedVRFRaffle
 * @dev Provides a complete raffle system where entries are purchased at the entry
 *      price, the winner is selected automatically with VRF and Keepers, and the 
 *      balance of all entries is sent to the winner.
 */
contract AutomatedVRFRaffle is Ownable, Raffle, RafflePurchaseable, RaffleVRFRandomPick, RaffleAutomatable {

    constructor(
        uint256 raffleInterval_,
        uint256 entryCost_,
        uint64 subscriptionId_,
        address vrfCoordinator_,
        bytes32 gasLane_
    ) RaffleVRFRandomPick(subscriptionId_, vrfCoordinator_, gasLane_) {
        price = entryCost_;
        _setInterval(raffleInterval_);
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

    function _enter(uint256 qnty) internal override {
        _purchase(qnty);
        super._enter(qnty);
    }

    function _resolveRandomPick(uint256 idx) internal override {
        address _winner = _pickWinner(idx);
        _sendWinnings(_winner);
    }

    function _runRaffleAutomation() internal override {
        _randomPickWinner();
    }

}