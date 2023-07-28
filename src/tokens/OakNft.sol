// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ERC721.sol";

contract OakNft is ERC721 {
    address private ARTIST;
    uint256 public TOKEN_ID = 0;
    event Mint(address indexed _to, uint256 indexed _tokenId, uint16 indexed _rank );

    constructor( string memory _URIBASE, address _artist) {
        _owner = msg.sender;
        __name = "Oak NFT";
        __symbol = "OAK";
        __URIBase = _URIBASE;
        ARTIST = _artist;
    }

    function mint(address _to) public payable {
        require(msg.value >= 0.001 ether, "Incorrect Value to purchase NFT");

        if (msg.value == 1 ether) {
            _mint(_to, TOKEN_ID);
            emit Mint(_to,TOKEN_ID,4);
            unchecked {
                TOKEN_ID++;
            }
            
            return;
        }
        if (msg.value == 0.1 ether) {
            _mint(_to, TOKEN_ID);
            emit Mint(_to,TOKEN_ID,3);
            unchecked {
                TOKEN_ID++;
            }
            
            return;
        }
        if (msg.value == 0.01 ether) {
            _mint(_to, TOKEN_ID);
            emit Mint(_to,TOKEN_ID,2);
            unchecked {
                TOKEN_ID++;
            }
             return;
        }
        if (msg.value == 0.001 ether) {
            _mint(_to, TOKEN_ID);
            emit Mint(_to,TOKEN_ID,1);
            unchecked {
                TOKEN_ID++;
            }
            return;
        }
            revert("Incorrect Value to purchase NFT");
    }

    function withdraw() public onlyOwner payable {
            require(address(this).balance > 0,"Insufficient Withdrawal Value");
            uint256 ContractAmount = address(this).balance;
            uint256 artistShare = ContractAmount / 2;
            (bool artistSuccess,) = ARTIST.call{value: artistShare}("");
            require(artistSuccess, "Transaction to artist failed");
            (bool ownerSuccess,) = _owner.call{value: artistShare}("");
            require(ownerSuccess, "Transaction to Owner Failed");
    }

    
}