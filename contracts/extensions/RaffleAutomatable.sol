// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "../Raffle.sol";

/** 
 * @title RaffleAutomatable
 * @notice Implements keepers interface for automation
 *
 * Steps to include this extension into a simple Raffle
 *
 * 1. Include RaffleAutomatable and RaffleRandomPick into a simple Raffle contract
 *
 * 2. Implement _runRaffleAutomation to call _randomPickWinner
 *
 * 3. Add _setInterval to the Raffle constructor with an interval value (3000 seconds)
 *
 * 4. Deploy and verify the contract
 *
 * 5. Go to keepers.chain.link
 *
 * 6. Connect Metamask to Ethereum Goerli
 *
 * 7. Register a new custom logic upkeep
 *
 * 8. Play the raffle!
 */
abstract contract RaffleAutomatable is Raffle, KeeperCompatibleInterface {

    uint256 public interval; // the interval at which this contract should run
    
    uint256 public lastRafflePick; // the last time stamp a winner was picked

    /**
    * @notice method that is simulated by the keepers to see if any work actually
    * needs to be performed. This method does does not actually need to be
    * executable, and since it is only ever simulated it can consume lots of gas.
    * @dev To ensure that it is never called, you may want to add the
    * cannotExecute modifier from KeeperBase to your implementation of this
    * method.
    * @param checkData specified in the upkeep registration so it is always the
    * same for a registered upkeep. This can easily be broken down into specific
    * arguments using `abi.decode`, so multiple upkeeps can be registered on the
    * same contract and easily differentiated by the contract.
    * @return upkeepNeeded boolean to indicate whether the keeper should call
    * performUpkeep or not.
    * @return performData bytes that the keeper should call performUpkeep with, if
    * upkeep is needed. If you would like to encode data to decode later, try
    * `abi.encode`.
    */
    function checkUpkeep(bytes calldata) external view override returns(bool upkeepNeeded, bytes memory) {
        upkeepNeeded = _upkeepNeeded();
    }

    /**
    * @notice method that is actually executed by the keepers, via the registry.
    * The data returned by the checkUpkeep simulation will be passed into
    * this method to actually be executed.
    * @dev The input to this method should not be trusted, and the caller of the
    * method should not even be restricted to any single registry. Anyone should
    * be able call it, and the input should be validated, there is no guarantee
    * that the data passed in is the performData returned from checkUpkeep. This
    * could happen due to malicious keepers, racing keepers, or simply a state
    * change while the performUpkeep transaction is waiting for confirmation.
    * Always validate the data passed in.
    * @param performData is the data which was passed back from the checkData
    * simulation. If it is encoded, it can easily be decoded into other types by
    * calling `abi.decode`. This data should not be trusted, and should be
    * validated against the contract's current state.
    */
    function performUpkeep(bytes calldata) external override {
        if (_upkeepNeeded()) {
            _runRaffleAutomation();
        }
    }

    function _setInterval(uint256 interval_) internal virtual {
        interval = interval_;
    }

    /**
    * @notice Override this function for custom automation logic; returns whether automation should run or not
    */
    function _upkeepNeeded() internal view virtual returns(bool) {
        return (block.timestamp - lastRafflePick) > interval;
    }

    function _runRaffleAutomation() internal virtual

}
