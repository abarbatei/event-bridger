// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { Ownable2Step } from "openzeppelin/access/Ownable2Step.sol";


interface IERC1155 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );
}

interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
}

contract EventBridger is Ownable2Step, IERC1155, IERC721 {

    function emitERC721TransferEvent(address from, address to, uint256 tokenId) external onlyOwner {
        emit Transfer(from, to, tokenId);
    }

    function emitERC721TransferEventBatch(
        address[] calldata fromAddresses, 
        address[] calldata toAddresses, 
        uint256[] calldata tokenIDs
    ) 
        external onlyOwner 
    {
        uint256 length = fromAddresses.length;
        for (uint256 index; index < length; ) {
            emit Transfer(fromAddresses[index], toAddresses[index], tokenIDs[index]);
            unchecked { ++index; }
        }
    }
    function emitERC1155TransferSingleEvent(
        address operator, 
        address from, 
        address to,
        uint256 id,
        uint256 value
    ) 
        external onlyOwner 
    {
        emit TransferSingle(operator, from, to, id, value);
    }

    function emitERC721TransferBatchEvent(
        address operator,
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values
    ) 
        external onlyOwner 
    {
        emit TransferBatch(operator, from, to, ids, values);
    }
}
