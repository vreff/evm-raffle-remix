// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "../Raffle.sol";

/** 
 * @title RaffleLimitable
 * @notice Provides entry limit utility for raffle
 */
abstract contract RaffleLimitable is Raffle {

    uint256 public entryLimit;

    mapping(address => uint256) private _limits;

    modifier limit(uint256 quantity_) {
        require(
            _limits[msg.sender]+quantity_ <= entryLimit,
            "entries limited"
        );
        _;
    }

    function _setEntryLimit(uint256 limit_) internal {
        entryLimit = limit_;
    }

    function _enter(uint256 qnty) internal virtual override limit(qnty) {
        super._enter(qnty);
    }

}