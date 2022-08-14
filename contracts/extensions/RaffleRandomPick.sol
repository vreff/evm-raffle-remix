// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../Raffle.sol";

/** 
 * @title RaffleRandomPick
 * @notice Provides a random pick from available entries
 */
abstract contract RaffleRandomPick is Raffle {

    function _randomPickWinner() internal virtual {
        uint256 idx = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%getEntryCount();
        _pickWinner(idx);
    }

}
