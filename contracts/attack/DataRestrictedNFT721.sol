//SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Data restricted NFT has use case in GameFi where every transfer must be approved by the offchain backend
contract DataRestrictedNft721 is ERC721("Data Restricted NFT", "DRNFT"), Ownable {
  using Address for address;

  /**
    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
    * The call is not executed if the target address is not a contract.
    *
    * @param from address representing the previous owner of the given token ID
    * @param to target address that will receive the tokens
    * @param tokenId uint256 ID of the token to be transferred
    * @param data bytes optional data to send along with the call
    * @return bool whether the call correctly returned the expected magic value
    */
  function checkOnERC721Received(
      address from,
      address to,
      uint256 tokenId,
      bytes memory data
  ) private returns (bool) {
      if (to.isContract()) {
          try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
              return retval == IERC721Receiver.onERC721Received.selector;
          } catch (bytes memory reason) {
              if (reason.length == 0) {
                  revert("ERC721: transfer to non ERC721Receiver implementer");
              } else {
                  /// @solidity memory-safe-assembly
                  assembly {
                      revert(add(32, reason), mload(reason))
                  }
              }
          }
      } else {
          return true;
      }
  }

  function _transfer(address from, address, uint256) internal virtual override {
    require(from == address(0), "Use safeTransfer instead");
  }

  function _safeTransfer(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) internal virtual override {
    require(keccak256(data) == keccak256(hex"1234"), "Forbidden");
    super._transfer(from, to, tokenId);
    require(checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
  }

  function mint(address to, uint256 tokenId) public returns (bool) {
    _mint(to, tokenId);
    return true;
  }
}