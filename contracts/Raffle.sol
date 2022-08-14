// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

/**
 * @title Raffle
 * @notice Provides a basic raffle system
 */
abstract contract Raffle {
    // Emits a purchased raffle entry event
    event RaffleEntry(address indexed purchaser, uint256 quantity);

    // Emits a winner event with the winner address
    event RaffleWinner(address indexed winner);

    // an Entry represents a single entry purchase for a raffle
    struct Entry {
        address player;
    }

    // owner is the creator of the contract and is used for permissioned function calls
    address private _owner;

    // winner of the most recent raffle
    address private winner;

    // collection of entries for the current raffle
    Entry[] private _entries;

    /**
     * @notice Returns the total number of entries for the active raffle
     */
    function getEntryCount() public view returns (uint256) {
        return _entries.length;
    }

    /**
     * @notice Returns the most recent raffle winner
     */
    function getWinner() public view returns (address) {
        return winner;
    }

    /**
     * @notice Adds the entries to the private list of entries
     * @param qnty The number of entries to add for sender
     */
    function _enter(uint16 qnty) internal virtual {
        for (uint i = 0; i < qnty; i++) {
            _entries.push(Entry({player: msg.sender}));
        }

        emit RaffleEntry(msg.sender, qnty);
    }

    /**
     * @notice Provides logic to pick a winner from the list of entries
     * @param idx The index of the winner in the list of entries
     */
    function _pickWinner(uint256 idx) internal returns (address) {
        require(idx >= 0 && idx < _entries.length, "winner out of bounds");
        // collect winner info before modifying state
        Entry memory _winner = _entries[idx];

        // modify internal contract state before transfering funds
        delete _entries;

        // allow custom logic for extended cleanup
        _afterPickWinner(_winner.player);

        return _winner.player;
    }

    /**
     * @notice Cleanup function for after winner has been picked
     */
    function _afterPickWinner(address newWinner) internal virtual {
        winner = newWinner;
        emit RaffleWinner(newWinner);
    }
}
