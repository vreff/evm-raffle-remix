// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../Raffle.sol";

/** 
 * @title RaffleERC721Winnable
 * @notice Implements IERC721Receiver and provides utilites to send ERC721 prizes
 */
abstract contract RaffleERC721Winnable is Raffle, IERC721Receiver {

    address private _contract;
    uint256 private _tokenId;

    function onERC721Received(
        address,
        address,
        uint256 tokenId,
        bytes calldata
    ) external override returns (bytes4) {
        if (!_prizeAvailable()) {
            revert("a prize is already available for this raffle");
        }

        try ERC721(msg.sender).ownerOf(tokenId) returns (address retval) {
            if (retval != address(this)) {
                revert("sending contract does not indicate that new owner and this contract match");
            }
        } catch(bytes memory reason) {
            assembly {
                revert(add(32, reason), mload(reason))
            }
        }

        _contract = msg.sender;
        _tokenId = tokenId;

        return IERC721Receiver.onERC721Received.selector;
    }

    function _sendERC721Token(address to) internal {
        require(_tokenId != 0, "no token to transfer");
        require(to != address(0), "cannot send to the zero address");

        address source = _contract;
        uint256 tokenId = _tokenId;

        _contract = address(0);
        _tokenId = 0;

        ERC721(source).safeTransferFrom(msg.sender, to, tokenId);
    }

    function _prizeAvailable() internal view returns(bool) {
        return _contract != address(0) && _tokenId != 0;
    }

}