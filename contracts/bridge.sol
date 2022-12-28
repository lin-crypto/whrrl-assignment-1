// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract WhrrlNFT is ERC721Enumerable, Ownable {
  using Strings for uint256;
  string public baseURI;
  string public baseExtension = ".json";
  uint256 public maxSupply = 1000;

  constructor() ERC721("Whrrl NFT", "WRL") {
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return "ipfs://QmcbqRHejmN7fVpudZsge9gd4Gi4zbcakFJEpEbWtGKXu1/";
  }
  
  function mint(uint256 tokenId) public virtual {
    _mint(msg.sender, tokenId);
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
    {
      uint256 ownerTokenCount = balanceOf(_owner);
      uint256[] memory tokenIds = new uint256[](ownerTokenCount);
      for (uint256 i; i < ownerTokenCount; i++) {
          tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
      }
      return tokenIds;
    }
  
      
  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory) {
      require(
        _exists(tokenId),
        "ERC721Metadata: URI query for nonexistent token"
        );
        
        string memory currentBaseURI = _baseURI();
        return
        bytes(currentBaseURI).length > 0 
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
    }

  function setBaseURI(string memory _newBaseURI) public onlyOwner() {
    baseURI = _newBaseURI;
  }
  
  function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
    baseExtension = _newBaseExtension;
  }
}

contract WhrrlNFTBridge is IERC721Receiver, ReentrancyGuard, Ownable {
  struct Store {
    uint256 tokenId;
    address holder;
  }

  mapping(uint256 => Store) public holdStore;

  event NFTStore (
    uint256 indexed tokenId,
    address holder
  );


  ERC721Enumerable nft;

  constructor(ERC721Enumerable _nft) {
    nft = _nft;
  }

  function depositNFT(uint256 tokenId) public payable nonReentrant {
    require(nft.ownerOf(tokenId) == msg.sender, "The NFT is not yours.");
    require(holdStore[tokenId].tokenId == 0, "The NFT already deposited.");
    holdStore[tokenId] =  Store(tokenId, msg.sender);
    nft.transferFrom(msg.sender, address(this), tokenId);
    emit NFTStore(tokenId, msg.sender);
  }
 
  function withdrawNFT(uint256 tokenId, address user) public nonReentrant onlyOwner() {
    nft.transferFrom(address(this), user, tokenId);
    delete holdStore[tokenId];
  }

  function onERC721Received(
    address,
    address from,
    uint256,
    bytes calldata
  ) external pure override returns (bytes4) {
    require(from == address(0x0), "Cannot Receive NFT Directly");
    return IERC721Receiver.onERC721Received.selector;
  }
}