// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "./Promethium.sol";

contract MonstersOnTheWayCards is
    Initializable,
    ERC721Upgradeable,
    ERC721URIStorageUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    ERC721BurnableUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeMathUpgradeable for uint256;

    CountersUpgradeable.Counter private _tokenIdCounter;

    uint256 private _fee;
    address payable _owner;
    uint256 private _balanceOfContract;
    string[] private _bookOfUris;
    address private _addressOfSmartContractOfTokens;

    function initialize(address addressOfPromethium) public initializer {
        __ERC721_init("Cards", "CRD");
        __ERC721URIStorage_init();
        __Pausable_init();
        __Ownable_init();
        __ERC721Burnable_init();

        _addressOfSmartContractOfTokens = addressOfPromethium;
        _fee = 3000000000000000;
        _owner = payable(_msgSender());
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) external payable {
        require(msg.value >= _fee, "Not enough funds to mint");
        _bookOfUris.push(uri);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function safeMintWithTokens(address to, string memory uri) public {
        Promethium smartContractTokens = Promethium(
            _addressOfSmartContractOfTokens
        );
        require(
            smartContractTokens.balanceOf(_msgSender()) > 10,
            "Not enough promethiums"
        );
        smartContractTokens.receiveTokensFromNFTMint(_msgSender(), 10);
        _bookOfUris.push(uri);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function retrieveFunds() public onlyOwner {
        require(address(this).balance > 0, "No funds to retrieve");
        (bool sent, bytes memory data) = owner().call{
            value: address(this).balance
        }("");
        require(sent, "Failed to send Ether");
    }

    function balanceToRetrieveByTheOwner()
        public
        view
        onlyOwner
        returns (uint256)
    {
        return address(this).balance;
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function getFee() public view returns(uint256) {
        return _fee;
    }

    function setFee(uint256 fee) public onlyOwner {
        _fee = fee;
    }

    function getCids() public view returns(string[] memory) {
        return _bookOfUris;
    }
}
