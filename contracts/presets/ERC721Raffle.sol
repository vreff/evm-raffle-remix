// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../Raffle.sol";
import "../extensions/RaffleERC721Winnable.sol";
import "../extensions/RaffleLimitable.sol";

/** 
 * @title ERC721Raffle
 * @dev Provides a complete raffle system where entries are limited but free,
 *      the winner is selected externally, and an ERC721 token is sent to the winner.
 */
contract ERC721Raffle is Ownable, Raffle, RaffleERC721Winnable, RaffleLimitable {

    constructor(uint256 entryLimit_) {
        _setEntryLimit(entryLimit_);
    }
    
    /**
    * @notice Adds the sender to the list of raffle entries
    * @param qnty The number of entries to add for sender
    */
    function enter(uint256 qnty) external {
        _enter(qnty);
    }

    function pickWinner(uint256 idx) external onlyOwner returns(address) {
        require(_prizeAvailable(), "cannot pick winner when no prize is available");

        address _winner = _pickWinner(idx);
        _sendERC721Token(_winner);

        return _winner;
    }

    function _enter(uint256 qnty) internal override (Raffle, RaffleLimitable) {
        require(_prizeAvailable(), "cannot enter when no prize is available");
        super._enter(qnty);
    }

}