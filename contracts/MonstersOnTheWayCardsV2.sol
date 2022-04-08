// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "./Promethium.sol";

contract MonstersOnTheWayCardsV2 is
    Initializable,
    ERC721Upgradeable,
    ERC721URIStorageUpgradeable,
    PausableUpgradeable,
    ERC721BurnableUpgradeable,
    OwnableUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeMathUpgradeable for uint256;

    CountersUpgradeable.Counter private _tokenIdCounter;

    uint256 private _fee;
    address payable _addressRetriever;
    uint256 private _balanceOfContract;
    string[] private _bookOfUris;
    address private _addressOfSmartContractOfTokens;
    mapping(bytes32 => bool) private _hashBook;

    function initialize(address addressOfPromethium, address newOwner)
        public
        initializer
    {
        __ERC721_init("Cards", "CRD");
        __ERC721URIStorage_init();
        __Pausable_init();
        __ERC721Burnable_init();
        __Ownable_init();
        _addressOfSmartContractOfTokens = addressOfPromethium;
        _fee = 3000000000000000;
        _addressRetriever = payable(newOwner);
    }

    function lastIdMinted() public view returns(CountersUpgradeable.Counter memory){
        return _tokenIdCounter;
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

    function safeMintWithTicket(bytes32 _hash, bytes memory _signature, address to, string memory uri) public {
        require(ECDSAUpgradeable.recover(_hash, _signature) == owner(), "This mint was not signed by the owner");
        require(!_hashBook[_hash], "This code was already redeemed");
        
        _hashBook[_hash] = true;

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
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

    function checkIfTokenExists(uint256 id) public view returns(bool) {
        return _owners[id] != address(0);
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

    function getFee() public view returns (uint256) {
        return _fee;
    }

    function setFee(uint256 fee) public onlyOwner {
        _fee = fee;
    }

    function getCids() public view returns (string[] memory) {
        return _bookOfUris;
    }

    function getRetriever() public view returns (address) {
        return _addressRetriever;
    }

    function setRetriever(address newRetrieve) public onlyOwner {
        _addressRetriever = payable(newRetrieve);
    }

    function getSmartContractAddr() public view returns (address) {
        return _addressOfSmartContractOfTokens;
    }
    
    function setAddressOfTokenContract(address newAddress) public onlyOwner() {
        _addressOfSmartContractOfTokens = newAddress;
    }

    
}
