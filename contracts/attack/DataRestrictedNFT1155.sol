//SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Data restricted NFT has use case in GameFi where every transfer must be approved by the offchain backend
contract DataRestrictedNft1155 is ERC1155("https://chom.dev/opensea_code4rena/{id}"), Ownable {
  function _beforeTokenTransfer(
    address,
    address,
    address,
    uint256[] memory,
    uint256[] memory,
    bytes memory data
  ) internal virtual override {
    require(keccak256(data) == keccak256(hex"1234"), "Forbidden");
  }

  function mint(
    address to,
    uint256 tokenId,
    uint256 amount
  ) public returns (bool) {
    _mint(to, tokenId, amount, hex"1234");
    return true;
  }
}