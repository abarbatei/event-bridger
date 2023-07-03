// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EventBridger.sol";

contract CounterTest is Test {
    EventBridger public eventBridger;

    function setUp() public {
        eventBridger = new EventBridger();
        
    }

    function testEmitERC721() public {
        eventBridger.emitERC721TransferEvent(makeAddr("from"), makeAddr("to"), 42);
    }

    function testEmitERC721Raw() public {
        eventBridger.emitERC721TransferEvent(address(0x0), address(0x1), 42);
    }

    function testEmitERC721BatchManual() public {
        address[] memory fromAddresses;
        address[] memory toAddresses;
        uint256[] memory tokenIDs;
        uint256 size = 1;

        fromAddresses = new address[](size);
        toAddresses = new address[](size);
        tokenIDs = new uint256[](size);
        
        for (uint256 i; i < size; i++) {
            fromAddresses[i] = address(0x0);            
            toAddresses[i] = address(0x1);
            tokenIDs[i] = i;
        }

        eventBridger.emitERC721TransferEventBatch(fromAddresses, toAddresses, tokenIDs);
    }

}
