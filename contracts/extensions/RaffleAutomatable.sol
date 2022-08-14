// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "../Raffle.sol";

/** 
 * @title RaffleAutomatable
 * @notice Implements keepers interface for automation
 */
abstract contract RaffleAutomatable is Raffle, KeeperCompatibleInterface {

    uint256 public interval;
    uint256 public lastRafflePick;

    function checkUpkeep(bytes calldata) external view override returns(bool upkeepNeeded, bytes memory) {
        upkeepNeeded = _upkeepNeeded();
    }

    function performUpkeep(bytes calldata) external override {
        if (_upkeepNeeded()) {
            _runRaffleAutomation();
        }
    }

    function _setInterval(uint256 interval_) internal virtual {
        interval = interval_;
    }

    function _upkeepNeeded() internal view virtual returns(bool) {
        return (block.timestamp - lastRafflePick) > interval;
    }

    function _runRaffleAutomation() internal virtual {
        _pickWinner(0);
    }

}