// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/RandomNFT.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract RandomNFTTest is Test {
    RandomNFT private rnft;

    using stdStorage for StdStorage;

    function setUp() public {
        rnft = new RandomNFT("Random NFTs", "RNFT", "baseUri");
    }

    function testFailInsufficientAmount() public {
        rnft.mintTo(address(1));
    }

    function testPricePaid() public {
        rnft.mintTo{value: 0.001 ether}(address(1));
    }

    function testFailMaxSupplyCrossed() public {
        uint256 slot = stdstore.target(address(rnft)).sig("nextTokenId()").find();
        // uint256 slot = 123;
        bytes32 loc = bytes32(slot);
        bytes32 mockTokenId = bytes32(abi.encode(1000));
        vm.store(address(rnft), loc, mockTokenId);
        rnft.mintTo{value: 0.001 ether}(address(1));
    }

    function testFailMintToZeroAddress() public {
        rnft.mintTo{value: 0.001 ether}(address(0));
    }

    function testNewMintOwnerRegistered() public {
        rnft.mintTo{value: 0.001 ether}(address(25));

        uint256 slot = stdstore.target(address(rnft)).sig(rnft.ownerOf.selector).with_key(1).find();
        bytes32 loc = bytes32(slot);
        uint160 owner = uint160(uint256(vm.load(address(rnft), loc)));

        assertEq(address(owner), address(25));
    }

    function testNFTBalanceIncremented() public {
        rnft.mintTo{value: 0.001 ether}(address(25));
        rnft.mintTo{value: 0.001 ether}(address(25));
        rnft.mintTo{value: 0.001 ether}(address(25));

        uint256 slot = stdstore.target(address(rnft)).sig(rnft.balanceOf.selector).with_key(address(25)).find();
        bytes32 loc = bytes32(slot);
        uint256 balance = uint256(vm.load(address(rnft), loc));

        assertEq(balance, 3);
    }

    function testWithdrawalWorksAsOwner() public {

    }
}

contract Receiver is IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) override external returns(bytes4) {
        return this.onERC721Received.selector;
    }
}
