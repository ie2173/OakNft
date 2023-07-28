// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ERC721.sol";

contract OakNft is ERC721 {
    uint8 public tier4TokenId = 0;
    uint16 public tier3TokenId = 255;
    uint32 public tier2TokenId = 755;
    uint256  tier1TokenId = 1755;
    address private ARTIST;
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
           require(tier4TokenId < 254, "NFT Sold Out");
           _mint(_to, tier4TokenId);
            emit Mint(_to,tier4TokenId,4);
            unchecked {
                tier4TokenId++;
            }
            
            return;
        }
        if (msg.value == 0.1 ether) {
            require(tier3TokenId < 754,"NFT Sold Out");
            _mint(_to, tier3TokenId);
            emit Mint(_to,tier3TokenId,3);
            unchecked {
                tier3TokenId++;
            }
            
            return;
        }
        if (msg.value == 0.01 ether) {
            require(tier2TokenId < 1754, "NFT Sold Out");
            _mint(_to, tier2TokenId);
            emit Mint(_to,tier2TokenId,2);
            unchecked {
                tier2TokenId++;
            }
             return;
        }
        if (msg.value == 0.001 ether) {
            require(tier1TokenId < 6754, "NFT Sold Out");
            _mint(_to, tier1TokenId);
            emit Mint(_to,tier1TokenId,1);
            unchecked {
                tier1TokenId++;
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