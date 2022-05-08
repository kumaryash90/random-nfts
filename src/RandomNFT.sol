// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error InsufficientAmount();
error MaxSupplyCrossed();
error TokenNonExistent();

contract RandomNFT is ERC721, Ownable {
    using Strings for uint256;

    string public baseURI;
    uint256 public nextTokenId;
    uint256 public constant PRICE = 0.001 ether;
    uint256 public constant MAX_SUPPLY = 1000;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) ERC721(_name, _symbol) {
        baseURI = _baseURI;
    }

    function mintTo(address recipient) public payable returns(uint256) {
        if(msg.value < PRICE) {
            revert InsufficientAmount();
        }
        uint256 newTokenId = ++nextTokenId;
        if(newTokenId > MAX_SUPPLY) {
            revert MaxSupplyCrossed();
        }
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
        if(ownerOf(tokenId) == address(0)) {
            revert TokenNonExistent();
        }
        return
            bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString()))
            : "";
    }

    function withdraw(address payable recipient) external onlyOwner {
        recipient.transfer(address(this).balance);
    }
}
