// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Promethium is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable
{
    using SafeMathUpgradeable for uint256;

    uint128 private _MAX_NUMBER_OF_TOKENS_MINTABLE;
    uint8 private _DECIMALS;
    address private _addressOfTheNFTContract;

    mapping(bytes32 => bool) private _hashBook;

    function initialize(address newOwner) public initializer {
        __ERC20_init("Promethium", "PRM");
        __ERC20Burnable_init();
        __Pausable_init();
        _DECIMALS = 6;
        _MAX_NUMBER_OF_TOKENS_MINTABLE = 21000000000000;
        
        //Delete the following lines for next upgrades
        _mint(newOwner, 100000 * 10**decimals());
    }

    function setAddressOfNFTContract(address addr) public onlyOwner() {
        _addressOfTheNFTContract = addr;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return _DECIMALS;
    }

    /*
        The string in input is generated as follows:
            - a random number is generated between 0 and 10000000000 in a server hosted in google Cloud
            - that number is hashed with kekka256 algorithm
            - after that I manipulate the strings, a better explanation in the next points
            - the last digit tells how many characters to read from the string to exctract the number of tokens
              that can be minted.
              Example: 
              This hash here was signed by the owner: 0xb4ac5fc7d8e5be4271b275abb9a4bb49fc57e1fc7a1906f612e9e08610000007
              As you can see the last digit is "7" so the characters that must be read from the string are the next 7 characters
              starting from the end of the string, those are the tokens that will be minted in this mint, in this case
              the tokens are: 1000000.
            - From my backend I sign the message with the private key of the owner to validate this mint
     */
    function extractNumberOfTokensFromHash(string memory str)
        public
        pure
        returns (uint256)
    {
        bytes memory strBytes = bytes(str);
        uint256 startIndex = strBytes.length - 1;
        uint256 endIndex = strBytes.length;
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        string memory resultToConvert = string(result);
        uint256 charactersToReadFromHash = st2num(resultToConvert);

        startIndex = strBytes.length - 1 - charactersToReadFromHash;
        endIndex = strBytes.length - 1;
        bytes memory numberOfTokensToMint = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            numberOfTokensToMint[i - startIndex] = strBytes[i];
        }
        resultToConvert = string(numberOfTokensToMint);
        uint256 tokens = st2num(resultToConvert);

        return tokens;
    }

    function isCodeValid(bytes32 _hash) public view returns (bool) {
        return _hashBook[_hash];
    }

    /*
        This is a utility function used to convert strings to integers
     */
    function st2num(string memory numString) public pure returns (uint256) {
        uint256 numberExtractFromString = exctractNumberFromHash(numString);
        return numberExtractFromString;
    }

    function exctractNumberFromHash(string memory numString)
        private
        pure
        returns (uint256)
    {
        uint256 val = 0;
        if (areEquals(numString, "A")) {
            return 10;
        } else if (areEquals(numString, "B")) {
            return 11;
        } else if (areEquals(numString, "C")) {
            return 12;
        } else if (areEquals(numString, "D")) {
            return 13;
        } else {
            bytes memory stringBytes = bytes(numString);
            for (uint256 i = 0; i < stringBytes.length; i++) {
                uint256 exp = stringBytes.length - i;
                bytes1 ival = stringBytes[i];
                uint8 uval = uint8(ival);
                uint256 jval = uval - uint256(0x30);

                val += (uint256(jval) * (10**(exp - 1)));
            }
        }
        return val;
    }

    function areEquals(string memory firstString, string memory secondString)
        private
        pure
        returns (bool)
    {
        return
            keccak256(abi.encode(firstString)) ==
            keccak256(abi.encode(secondString));
    }

    /*
        The idea is to process 16 bytes at once using binary operations.
        The toHex16 function converts a sequence of 16 bytes represented 
        as a bytes16 value into a sequence of 32 hexadecimal digits represented 
        as a bytes32 value. The toHex function splits a bytes32 value into two bytes16 chunks, 
        converts each chunk to hexadecimal representation via the toHex16 function, and finally 
        concatenates the 0x prefix with the converted chunks using abi.encodePacked function.
        For a better explanation: https://stackoverflow.com/questions/67893318/solidity-how-to-represent-bytes32-as-string
     */
    function toHex(bytes32 data) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "0x",
                    toHex16(bytes16(data)),
                    toHex16(bytes16(data << 128))
                )
            );
    }

    function toHex16(bytes16 data) internal pure returns (bytes32 result) {
        result =
            (bytes32(data) &
                0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000) |
            ((bytes32(data) &
                0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >>
                64);
        result =
            (result &
                0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000) |
            ((result &
                0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >>
                32);
        result =
            (result &
                0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000) |
            ((result &
                0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >>
                16);
        result =
            (result &
                0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000) |
            ((result &
                0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >>
                8);
        result =
            ((result &
                0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >>
                4) |
            ((result &
                0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >>
                8);
        result = bytes32(
            0x3030303030303030303030303030303030303030303030303030303030303030 +
                uint256(result) +
                (((uint256(result) +
                    0x0606060606060606060606060606060606060606060606060606060606060606) >>
                    4) &
                    0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) *
                7
        );
    }

    modifier onlyNFTContract() {
        require(
            _msgSender() == _addressOfTheNFTContract,
            "This function can only be called by the smart contract of the NFTs"
        );
        _;
    }

    function receiveTokensFromNFTMint(address origin, uint256 value)
        public
        onlyNFTContract
    {
        _balances[origin] = _balances[origin].sub(value);
        _balances[owner()] = _balances[owner()].add(value);
    }
}
