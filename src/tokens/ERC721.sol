// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "../interfaces/IERC721.sol";
import "../interfaces/IERC721MetaData.sol";
import "../interfaces/IERC721Receiver.sol";
import "../utils/Strings.sol";
import "../utils/Address.sol";
import "../utils/ERC165.sol";
import "../utils/Ownable.sol";

    // Interface ID: 0x80ac58cd

contract ERC721 is ERC165, IERC721, IERC721Metadata, Ownable {
    using AddressUtils for address;
    using Strings for uint256;
    
    string internal   __name;
    string internal   __symbol;
    string internal   __URIBase;
    mapping(uint256 => address) private _owners;
    mapping(address=> uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address=> bool)) private _operatorApprovals;
    
    
    
    function supportsInterface (bytes4 _interfaceId) public view virtual override(ERC165) returns (bool) {
        return 
            _interfaceId == type(IERC721).interfaceId ||
            _interfaceId == type(IERC721Metadata).interfaceId || _interfaceId == 0x01ffc9a7;
    }

    function name() public view returns (string memory) {
        return __name;
    }

    function symbol() public view returns (string memory) {
        return __symbol;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        if (_owner == address(0)) {
            revert("Invalid Owner");

        }
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        require(_exists(_tokenId), "Invalid Owner");
        return _ownerOf(_tokenId);
    }

    function baseURI() private view returns (string memory) {
        return __URIBase;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        string memory _baseURI = baseURI();
        return string( _exists(_tokenId) ? abi.encodePacked(_baseURI,_tokenId.toString(),".png") : abi.encodePacked(""));

    }

    function setBaseURI(string memory _NewURIBase) public onlyOwner {
        __URIBase = _NewURIBase;

    }

    function approve(address _to, uint256 _tokenId) public virtual {
        require(_to != _ownerOf(_tokenId), "Invalid Operation");
        require(msg.sender == _ownerOf(_tokenId) || isApprovedForAll(_ownerOf(_tokenId), msg.sender), "Unauthorized User");

        _approve(_to,_tokenId);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public virtual{
        require(_owners[_tokenId] == msg.sender || _operatorApprovals[_from][msg.sender] == true || _tokenApprovals[_tokenId] == msg.sender, "Unauthorized Access" );
        require(_to != address(0),"Invalid Owner");

        if (_to.isContract()) {
            bytes4 returnValue = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, "");
            require(returnValue == 0x150b7a02, "invalid Reciepeint"); // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) 
        }
        _transfer(_from, _to, _tokenId);
    }
    

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) public virtual{
        require(_owners[_tokenId] == msg.sender || _operatorApprovals[_from][msg.sender] == true || _tokenApprovals[_tokenId] == msg.sender, "Unauthorized Access"  );
        require(_to != address(0),"Invalid Owner");

        if (_to.isContract()) {
            bytes4 returnValue = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
            require(returnValue == 0x150b7a02, "invalid Reciepeint"); // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) 
        }
        _transfer(_from, _to, _tokenId);
    }


    

function transferFrom(address _from, address _to, uint256 _tokenId) public {
    require(_owners[_tokenId] == msg.sender || _operatorApprovals[_from][msg.sender] == true || _tokenApprovals[_tokenId] == msg.sender, "Unauthorized Access" );

    _transfer(_from,_to,_tokenId);
   }

    function getApproved(uint256 _tokenId) public view returns (address) {
            require(_exists(_tokenId), "Invalid Token Id");
            return _tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view returns(bool) {
         return _operatorApprovals[_owner][_operator];
    }


    function setApprovalForAll(address _operator, bool _approved) public {
        require(msg.sender != _operator, "Invalid Operation");
        _setApprovalForAll(msg.sender, _operator, _approved);
        

    }

// Internal Functions

function _transfer(address _from, address _to, uint256 _tokenId) internal virtual {
     delete _tokenApprovals[_tokenId];
    _balances[_from] -= 1;
    _owners[_tokenId] = _to;
   unchecked {
    _balances[_to] += 1;
   }
   emit Transfer(_from, _to, _tokenId);
}

 function _ownerOf(uint256 _tokenId) internal view virtual returns (address) {
        return _owners[_tokenId];
    }


function _approve(address _to, uint256 _tokenId) internal virtual {
    _tokenApprovals[_tokenId] = _to;
    emit Approval(_ownerOf(_tokenId), _to, _tokenId);
}

function _exists(uint256 _tokenId) internal view virtual returns(bool) {
    return _ownerOf(_tokenId) != address(0);

}

function _setApprovalForAll(address _owner, address _operator, bool _approved) internal virtual {
            
        _operatorApprovals[_owner][_operator] = _approved;
        emit ApprovalForAll(_owner, _operator, _approved);
    }



function _mint(address _to, uint256 _tokenId) internal virtual {
        unchecked {
            _balances[_to] += 1;
        }
        _owners[_tokenId] = _to;
        emit Transfer(address(0), _to, _tokenId);
    }

function _burn(uint256 _tokenId) internal virtual {
    address owner = _ownerOf(_tokenId);
    delete _tokenApprovals[_tokenId];
    _balances[owner] -= 1;
    delete _owners[_tokenId];
    emit Transfer(owner, address(0), _tokenId);
}

}