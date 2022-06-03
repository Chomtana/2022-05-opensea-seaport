//SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SemiSoulboundNft is ERC721("Rekt Fee and Royalty", "SSBT"), Ownable {
  mapping(address => bool) public whitelisted;
  mapping(address => bool) public blacklisted; // Won't demonstrated this but can be used to prevent man in the middle attack
  mapping(uint256 => uint256) public locked;
  uint256 public totalSupply = 0;

  function _beforeTokenTransfer(
    address,
    address,
    uint256
  ) internal view override {
    require(whitelisted[msg.sender], "Forbidden");
  }

  function addWhitelist(address wl, bool enabled) public onlyOwner {
    whitelisted[wl] = enabled;
  }

  function addBlacklist(address wl, bool enabled) public onlyOwner {
    blacklisted[wl] = enabled;
  }

  function mint() public payable {
    totalSupply++;
    _safeMint(msg.sender, totalSupply);
    locked[totalSupply] = msg.value;
  }

  function burn(uint256 tokenId) public {
    require(!blacklisted[msg.sender], "Blacklisted");
    require(ownerOf(tokenId) == msg.sender, "Not owner");
    _burn(tokenId);
    payable(msg.sender).transfer(locked[tokenId]);
    locked[tokenId] = 0;
  }
}