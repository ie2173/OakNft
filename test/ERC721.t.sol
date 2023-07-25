// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/forge-std/src/Test.sol";
import "src/tokens/ERC721.sol";
import "src/interfaces/IERC721Receiver.sol";

contract NFTTOKEN is ERC721 {
    uint256 public TOKEN_ID = 0;
    constructor(string memory _name, string memory _symbol, string memory _URIBASE) {
        _owner = msg.sender;
        __name = _name;
        __symbol = _symbol;
        __URIBase = _URIBASE;
    }

    function mint (address _to) public {
        _mint(_to, TOKEN_ID);
        unchecked {
            TOKEN_ID++;    
        }  
    }
}

contract NFTWALLETCONTRACT is IERC721Receiver {
   function onERC721Received(
      address _operator,
      address _from,
      uint256 _tokenId,
      bytes calldata _data
   ) public pure returns(bytes4){
      return 0x150b7a02;
   }

   function returnAddress() public view returns(address){ 
      return address(this);
   }
}

contract INVALIDNFTCONTRACT is IERC721Receiver {
   function onERC721Received(
      address _operator,
      address _from,
      uint256 _tokenId,
      bytes calldata _data
   ) public pure returns(bytes4){
      return 0xFFFFFFFF;
   }

   function returnAddress() public view returns(address) {
      return address(this);
   }
}

 contract ERC721TEST is Test {
    NFTTOKEN public ERC721Contract;
    NFTWALLETCONTRACT public SAFEWALLET;
    INVALIDNFTCONTRACT public BadWALLET;
    string public name = "OAKLAND NFT";
    string public symbol = "OAK";
    string public baseuri = "IPFS:BASEURI/";
    address public minter = address(0x01);
    address public EOA1 = address(0x02);
    address public EOA2 = address(0x03);
    address public EOA3 = address(0x04);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function setUp() public {
        ERC721Contract = new NFTTOKEN(name,symbol,baseuri);
    }

    // Begin Tests

    function testERC165() public {
        // Web3 Interface ID's for Their 721, 721Meta Data and ERC165 Data
        bytes4 IERC165Id = 0x01ffc9a7;
        bytes4 IERC721Id = 0x80ac58cd;
        bytes4 IERC721MetaId = 0x5b5e139f;
        // Get Interface ID for Contract's Interfaces and check Matches Web3 ID
        bytes4 IERC165InterfaceId = type(IERC165).interfaceId;
        assertEq(IERC165Id, IERC165InterfaceId);
        bytes4 IERC721InterfaceId = type(IERC721).interfaceId;
        assertEq(IERC721Id,IERC721InterfaceId);
        bytes4 IERC721MetaInterfaceId = type(IERC721Metadata).interfaceId;
        assertEq(IERC721MetaId, IERC721MetaInterfaceId);
        // Assert supports Interface function works
        bool IERC165Result = ERC721Contract.supportsInterface(IERC165Id);
        assertTrue(IERC165Result);
        bool IERC721Result = ERC721Contract.supportsInterface(IERC721Id);
        assertTrue(IERC721Result);
        bool IERC721MetaDataResult = ERC721Contract.supportsInterface(IERC721MetaId);
        assertTrue(IERC721MetaDataResult);
    }

    function testName() public {
        // Expect name of contract function returns "OAKLAND NFT"
        string memory nameResult = ERC721Contract.name();
        assertEq(name, nameResult);
    }

    function testSymbol() public {
        // Expect sumbol of contraction function returns "OAK"
        string memory symbolResult = ERC721Contract.symbol();
        assertEq(symbol, symbolResult);
    }

    function testMint() public {
        // Expect Mint to EOA1 of token 0 works.
        vm.expectEmit();
        emit Transfer(address(0),EOA1,0);
        ERC721Contract.mint(EOA1);
        address mint1_owner = ERC721Contract.ownerOf(0);
        assertEq(EOA1, mint1_owner);
        // Expect mint to EOA2 of token 1 works.
        ERC721Contract.mint(EOA2);
        address mint2_owner = ERC721Contract.ownerOf(1);
        assertEq(EOA2, mint2_owner);
    }

    function testBalanceOf() public {
        // Expect BalanceOf function for EOA1 with a balance of 0 tokens to return 0
        uint256 ZeroResult = ERC721Contract.balanceOf(EOA1);
        assertEq(0, ZeroResult);
        // Expect balanceOf function for EOA1 with a balance of 1 to return 1
        vm.expectEmit();
        emit Transfer(address(0),EOA1,0);
        ERC721Contract.mint(EOA1);
        uint256 OneResult = ERC721Contract.balanceOf(EOA1);
        assertEq(1, OneResult);
       // Expect Balanceof function for EOA1 with balance of 2 to return 2.
        vm.expectEmit();
        emit Transfer(address(0),EOA1,1);
        ERC721Contract.mint(EOA1);
        uint256 TwoResult = ERC721Contract.balanceOf(EOA1);
        assertEq(2, TwoResult);
       // Expect balanceof function for EOA1 with a balance of 10 return 10
       // Additionally test events work properly for repeated mints.
        vm.expectEmit();
        emit Transfer(address(0),EOA1,2);
        ERC721Contract.mint(EOA1); // 3
        vm.expectEmit();
        emit Transfer(address(0),EOA1,3);
        ERC721Contract.mint(EOA1); // 4
        vm.expectEmit();
        emit Transfer(address(0),EOA1,4);
        ERC721Contract.mint(EOA1); // 5
        vm.expectEmit();
        emit Transfer(address(0),EOA1,5);
        ERC721Contract.mint(EOA1); // 6
        vm.expectEmit();
        emit Transfer(address(0),EOA1,6);
        ERC721Contract.mint(EOA1); // 7 
        vm.expectEmit();
        emit Transfer(address(0),EOA1,7);
        ERC721Contract.mint(EOA1); // 8 
        vm.expectEmit();
        emit Transfer(address(0),EOA1,8);
        ERC721Contract.mint(EOA1); // 9 
        vm.expectEmit();
        emit Transfer(address(0),EOA1,9);
        ERC721Contract.mint(EOA1); // 10
        uint256 TenResult = ERC721Contract.balanceOf(EOA1);
        assertEq(10, TenResult);
    }

    function testOwnerOf() public {
        // Expect ownerOf function to return owner EOA1 for Token 0
        ERC721Contract.mint(EOA1);
        address OwnerResult = ERC721Contract.ownerOf(0);
        assertEq(EOA1, OwnerResult);
        // Expect ownerOf function for non-existant token to fail.
        vm.expectRevert("Invalid Owner");
        ERC721Contract.ownerOf(1);
    }

    function testTokenURI() public {
        // Expect tokenURI function to return IPFS:BASEURI/0.png for token 0
        ERC721Contract.mint(EOA1);
        string memory TokenURI = "IPFS:BASEURI/0.png";
        string memory URIResult = ERC721Contract.tokenURI(0);
        assertEq(TokenURI, URIResult);
        //Expect tokenURI function to return blank for non-existant Token 1
        string memory BlankTokenURI = "";
        string memory BlankURIResult = ERC721Contract.tokenURI(1);
        assertEq(BlankTokenURI, BlankURIResult);
    }

    function testSetBaseUri() public {
        // Expect owner to change Base URI in contract to work.
        ERC721Contract.mint(EOA1);
        string memory TokenURI = "IPFS:BASEURI/0.png";
        string memory URIResult = ERC721Contract.tokenURI(0);
        assertEq(TokenURI, URIResult);
        string memory NewBase = "IPFS:NEWBASEURI/";
        ERC721Contract.setBaseURI(NewBase);
        string memory NewTokenURI = "IPFS:NEWBASEURI/0.png";
        string memory NewBaseResult = ERC721Contract.tokenURI(0);
        assertEq(NewTokenURI,NewBaseResult);
        // Expect unauthorized EOA1 to change base URI in Contract to Fail
        vm.expectRevert("Not authorized");
        vm.startPrank(EOA1);
        ERC721Contract.setBaseURI(NewBase);
    }

    function testApprove() public {
        ERC721Contract.mint(EOA2);
        // Expect owner EOA1 to approve EOA2 Token 1 and Emit Event.
        vm.startPrank(EOA1);
        ERC721Contract.mint(EOA1);
        vm.expectEmit();
        emit Approval(EOA1, EOA2,1);
        ERC721Contract.approve(EOA2, 1);
        address ApprovalResults = ERC721Contract.getApproved(1);
        assertEq(ApprovalResults,EOA2);
        // Expect EOA1 to approve EOA3 Token 0 from owner EOA2 to fail. 
        vm.expectRevert("Unauthorized User");
        ERC721Contract.approve(EOA3,0);
        vm.startPrank(EOA2);
        // Expect owner EOA2 to approve EOA2 token 0 to fail.
        vm.expectRevert("Invalid Operation");
        ERC721Contract.approve(EOA2, 0);
        //Expect Owner EOA2 to approve EOA3 to work then Approve EOA1 to work and approve for EOA3 to fail.
        assertEq(ERC721Contract.getApproved(0), address(0));
        ERC721Contract.approve(EOA3, 0);
        address ApprovalResults1 = ERC721Contract.getApproved(0);
        assertEq(ApprovalResults1, EOA3);
        ERC721Contract.approve(EOA1, 0);
        address ApprovalResults2 = ERC721Contract.getApproved(0);
        assertEq(ApprovalResults2, EOA1);
        assertNotEq(ApprovalResults2, EOA3);

    }

    function testSafeTransferFrom() public {
        ERC721Contract.mint(EOA2);
        // Expect Transfer from owner EOA1 to EOA3 works.
        vm.startPrank(EOA1);
        ERC721Contract.mint(EOA1);
        vm.expectEmit();
        emit Transfer(EOA1, EOA3, 1);
        ERC721Contract.safeTransferFrom(EOA1, EOA3, 1);
        address SafeTranfer1Result = ERC721Contract.ownerOf(1);
        assertEq(SafeTranfer1Result, EOA3);
        // Expect Transfer from Approved EOA3 for EOA2 to EOA1 works
        vm.startPrank(EOA2);
        ERC721Contract.approve(EOA3, 0);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 0);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 0);
        address SafeTransfer2Result = ERC721Contract.ownerOf(0);
        assertEq(SafeTransfer2Result, EOA1); 
        // Expect Transfer From Operator EOA3 for  Owner EOA2 to EOA1 for Tokens 2 and 3 Works
        ERC721Contract.mint(EOA2);
        ERC721Contract.mint(EOA2);
        vm.startPrank(EOA2);
        ERC721Contract.setApprovalForAll(EOA3, true);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 2);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 2);
        address SafeContract3Result = ERC721Contract.ownerOf(2);
        assertEq(EOA1, SafeContract3Result);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 3);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 3);
        address SafeContract4Result = ERC721Contract.ownerOf(3);
        assertEq(EOA1, SafeContract4Result);

        // Expect Unauthorized Transfer of EOA1 for EOA2 to EOA1 fails 
        vm.startPrank(EOA1);
        vm.expectRevert("Unauthorized Access");
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 1);
        // Expect Transfer Owner EOA1 to Address 0 fails
        vm.expectRevert("Invalid Owner");
        ERC721Contract.safeTransferFrom(EOA1,address(0), 0);
        // Expect Transfer from EOA1 to Safe Contract 1 works
        SAFEWALLET = new NFTWALLETCONTRACT();
        address SafeContract1 = SAFEWALLET.returnAddress();
        vm.expectEmit();
        emit Transfer(EOA1, SafeContract1, 0);
        ERC721Contract.safeTransferFrom(EOA1, SafeContract1, 0);
        address SafeTransfer5Results = ERC721Contract.ownerOf(0);
        assertEq(SafeContract1, SafeTransfer5Results);
        // Expect Transfer Owner EOA3 to Bad Wallet 1 fails
        vm.startPrank(EOA3);
        BadWALLET = new INVALIDNFTCONTRACT();
        address BadWallet1 = BadWALLET.returnAddress();
        vm.expectRevert("invalid Reciepeint");
        ERC721Contract.safeTransferFrom(EOA3, BadWallet1, 1); 
        // Expect Operator of EOA3 for  Owner EOA2 to EOA1 to Work for token 4, but fail for Token 5
        vm.startPrank(EOA2);
        ERC721Contract.mint(EOA2); // token 4
        ERC721Contract.mint(EOA2); // Token 5
        ERC721Contract.setApprovalForAll(EOA3, false);
        ERC721Contract.approve(EOA3, 4);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 4);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 4);
        vm.expectRevert("Unauthorized Access");
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 5);
    }
    function testSafeTransferFromA() public {
        ERC721Contract.mint(EOA2);
        // Expect Transfer from owner EOA1 to EOA3 works.
        vm.startPrank(EOA1);
        ERC721Contract.mint(EOA1);
        vm.expectEmit();
        emit Transfer(EOA1, EOA3, 1);
        ERC721Contract.safeTransferFrom(EOA1, EOA3, 1,"");
        address SafeTranfer1Result = ERC721Contract.ownerOf(1);
        assertEq(SafeTranfer1Result, EOA3);
        // Expect Transfer from Approved EOA3 for EOA2 to EOA1 works
        vm.startPrank(EOA2);
        ERC721Contract.approve(EOA3, 0);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 0);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 0,"");
        address SafeTransfer2Result = ERC721Contract.ownerOf(0);
        assertEq(SafeTransfer2Result, EOA1); 
        // Expect Transfer From Operator EOA3 for  Owner EOA2 to EOA1 for Tokens 2 and 3 Works
        ERC721Contract.mint(EOA2);
        ERC721Contract.mint(EOA2);
        vm.startPrank(EOA2);
        ERC721Contract.setApprovalForAll(EOA3, true);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 2);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 2,"");
        address SafeContract3Result = ERC721Contract.ownerOf(2);
        assertEq(EOA1, SafeContract3Result);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 3);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 3,"");
        address SafeContract4Result = ERC721Contract.ownerOf(3);
        assertEq(EOA1, SafeContract4Result);

        // Expect Unauthorized Transfer of EOA1 for EOA2 to EOA1 fails 
        vm.startPrank(EOA1);
        vm.expectRevert("Unauthorized Access");
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 1,"");
        // Expect Transfer Owner EOA1 to Address 0 fails
        vm.expectRevert("Invalid Owner");
        ERC721Contract.safeTransferFrom(EOA1,address(0), 0,"");
        // Expect Transfer from EOA1 to Safe Contract 1 works
        SAFEWALLET = new NFTWALLETCONTRACT();
        address SafeContract1 = SAFEWALLET.returnAddress();
        vm.expectEmit();
        emit Transfer(EOA1, SafeContract1, 0);
        ERC721Contract.safeTransferFrom(EOA1, SafeContract1, 0,"");
        address SafeTransfer5Results = ERC721Contract.ownerOf(0);
        assertEq(SafeContract1, SafeTransfer5Results);
        // Expect Transfer Owner EOA3 to Bad Wallet 1 fails
        vm.startPrank(EOA3);
        BadWALLET = new INVALIDNFTCONTRACT();
        address BadWallet1 = BadWALLET.returnAddress();
        vm.expectRevert("invalid Reciepeint");
        ERC721Contract.safeTransferFrom(EOA3, BadWallet1, 1,""); 
        // Expect Operator of EOA3 for  Owner EOA2 to EOA1 to Work for token 4, but fail for Token 5
        vm.startPrank(EOA2);
        ERC721Contract.mint(EOA2); // token 4
        ERC721Contract.mint(EOA2); // Token 5
        ERC721Contract.setApprovalForAll(EOA3, false);
        ERC721Contract.approve(EOA3, 4);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 4);
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 4,"");
        vm.expectRevert("Unauthorized Access");
        ERC721Contract.safeTransferFrom(EOA2, EOA1, 5,"");
    }

    function testTransferFrom() public {
        ERC721Contract.mint(EOA3);// token 0
        //Expect Transfer from owner EOA1 to EOA3 for token 1 Works.
        ERC721Contract.mint(EOA1); // Token 1
        vm.startPrank(EOA1);
        vm.expectEmit();
        emit Transfer(EOA1, EOA2, 1);
        ERC721Contract.transferFrom(EOA1, EOA2,1);
        address TransferFromOwner1Results = ERC721Contract.ownerOf(1);
        assertEq(TransferFromOwner1Results, EOA2);
        uint256 TransferFromBalancesEOA2Results1 = ERC721Contract.balanceOf(EOA2);
        uint256 TransferFromBalancesEOA1Results1 = ERC721Contract.balanceOf(EOA1);
        assertEq(TransferFromBalancesEOA2Results1, 1);
        assertEq(TransferFromBalancesEOA1Results1, 0);
        // Expect Transfer from owner EOA2 to EOA1 via Approved EOA3 for token 1 works.
        vm.startPrank(EOA2);
        ERC721Contract.approve(EOA3, 1);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA2, EOA1, 1);
        ERC721Contract.transferFrom(EOA2, EOA1, 1); 
        address TransferFromOwnerEOA1Results2 = ERC721Contract.ownerOf(1);
        assertEq(TransferFromOwnerEOA1Results2, EOA1);
        uint256 TransferFromBalancesEOA2Results2 = ERC721Contract.balanceOf(EOA2);
        assertEq(TransferFromBalancesEOA2Results2, 0);
        uint256 TransferFromBalancesEOA1Results2 = ERC721Contract.balanceOf(EOA1);
        assertEq(TransferFromBalancesEOA1Results2, 1);
        // Expect Transfer from owner EOA3 to EOA2 via Operator EOA1 for token 0 works
        ERC721Contract.setApprovalForAll(EOA1, true);
        vm.startPrank(EOA1);
        vm.expectEmit();
        emit Transfer(EOA3, EOA2, 0);
        ERC721Contract.transferFrom(EOA3, EOA2, 0);
        address TransferFromOwnerEOA2Results3 = ERC721Contract.ownerOf(0);
        assertEq(TransferFromOwnerEOA2Results3, EOA2);
        uint256 TransferFromBalancesEOA3Results3 = ERC721Contract.balanceOf(EOA3);
        assertEq(TransferFromBalancesEOA3Results3, 0);
        uint256 TransferFromBalancesEOA2Results3 = ERC721Contract.balanceOf(EOA2);
        assertEq(TransferFromBalancesEOA2Results3, 1);

        //Expect transfer from owner EOA1 to validNFTContract for token 1 works
        SAFEWALLET = new NFTWALLETCONTRACT();
        address SafeContract1 = SAFEWALLET.returnAddress();
        vm.expectEmit();
        emit Transfer(EOA1, SafeContract1, 1);
        ERC721Contract.transferFrom(EOA1, SafeContract1, 1);
        address TransferFromOwnerContractResults4 = ERC721Contract.ownerOf(1);
        assertEq(TransferFromOwnerContractResults4, SafeContract1);
        uint256 TransferFromBalancesEOA1Retults4 = ERC721Contract.balanceOf(EOA1);
        assertEq(TransferFromBalancesEOA1Retults4,0);
        uint256 TransferFromBalancesContractResults4 = ERC721Contract.balanceOf(SafeContract1);
        assertEq(TransferFromBalancesContractResults4, 1);
        // Expect Transfer from Owner EOA2 to BadContract for Token 0 works
        vm.startPrank(EOA2);
        BadWALLET = new INVALIDNFTCONTRACT();
        address BadWallet1 = BadWALLET.returnAddress();
        vm.expectEmit();
        emit Transfer(EOA2, BadWallet1, 0);
        ERC721Contract.transferFrom(EOA2, BadWallet1, 0);
        address TransferFromOwnerBadContractResults5 = ERC721Contract.ownerOf(0);
        assertEq(TransferFromOwnerBadContractResults5, BadWallet1);
        uint256 TransferFromBalancesBadContractResults5 = ERC721Contract.balanceOf(BadWallet1);
        assertEq(TransferFromBalancesBadContractResults5, 1);
        uint256 TransferFromBalancesEOA2Results5 = ERC721Contract.balanceOf(EOA2);
        assertEq(TransferFromBalancesEOA2Results5, 0);
        // Expect Transfer From EOA1 to EOA2 Via Authorized EOA3 works and Transfer from EOA2 to EOA1 via unauthorized EOA3 fails
        vm.startPrank(EOA1);
        ERC721Contract.mint(EOA1); // Token 2
        ERC721Contract.approve(EOA3, 2);
        vm.startPrank(EOA3);
        vm.expectEmit();
        emit Transfer(EOA1, EOA2, 2);
        ERC721Contract.transferFrom(EOA1, EOA2, 2);
        vm.startPrank(EOA3);
        vm.expectRevert("Unauthorized Access");
        ERC721Contract.transferFrom(EOA2, EOA1, 2);
        address TransferFromOwnerEOA2Results6 = ERC721Contract.ownerOf(2);
        assertEq(TransferFromOwnerEOA2Results6, EOA2);
        uint256 TransferFromBalancesEOA1Results6 = ERC721Contract.balanceOf(EOA1);
        assertEq(TransferFromBalancesEOA1Results6, 0);
        uint256 TransferFromBalancesEOA2Results6 = ERC721Contract.balanceOf(EOA2);
        assertEq(TransferFromBalancesEOA2Results6, 1);
        // Expect Transfer from EOA1 to EOA2 via Unauthorized EOA3 to Fail
        ERC721Contract.mint(EOA1); // Token 3
        vm.startPrank(EOA1);
        ERC721Contract.setApprovalForAll(EOA3, false);
        vm.startPrank(EOA3);
        vm.expectRevert("Unauthorized Access");
        ERC721Contract.transferFrom(EOA1, EOA2, 3);
    }

    function testGetapproved() public {
        // Expect Approval from EOA 1 to EOA2 and get Approved returns EOA2 works
        ERC721Contract.mint(EOA1);
        vm.startPrank(EOA1);
        address GetApprovedResults1 = ERC721Contract.getApproved(0);
        assertEq(GetApprovedResults1, address(0));
        vm.expectEmit();
        emit Approval(EOA1, EOA2, 0);
        ERC721Contract.approve(EOA2, 0);
        address GetApprovedResults2 = ERC721Contract.getApproved(0);
        assertEq(GetApprovedResults2, EOA2);
       // Expect Approval from EOA1 to EOA3 and get Approved returns EOA3 and not EOA2 works.
        vm.expectEmit();
        emit Approval(EOA1, EOA3, 0);
        ERC721Contract.approve(EOA3, 0);
        address GetApprovedResults3 = ERC721Contract.getApproved(0);
        assertEq(GetApprovedResults3, EOA3);
        assertNotEq(GetApprovedResults3, EOA2);
        // Expect Get Approval from non-existant token Fails
        vm.expectRevert("Invalid Token Id");
        ERC721Contract.getApproved(1);
    }

    function testSetApprovalForAll() public {
        vm.startPrank(EOA1);
        // Expect set Operator for EOA1 to EOA2 to True Works
        vm.expectEmit();
        emit ApprovalForAll(EOA1, EOA2, true);
        ERC721Contract.setApprovalForAll(EOA2, true);
        //Expect set Operator For EOA1 to EOA2 to False Works
        vm.expectEmit();
        emit ApprovalForAll(EOA1, EOA2, false);
        ERC721Contract.setApprovalForAll(EOA2, false);
        //Expect set Operator for EOA1 to EOA1 to true fails
        vm.expectRevert("Invalid Operation");
        ERC721Contract.setApprovalForAll(EOA1, true);
    }

    function testisApprovedForAll() public {
        //Expect isApprovedForAll to return false for owner EOA1 and operator EOA2
        bool isApprovedResults1 = ERC721Contract.isApprovedForAll(EOA1, EOA2);
        assertFalse(isApprovedResults1);
        //Expect isApprovedForAll to return false for owner EOA2 and operator EOA3
        bool isApprovedResults2 = ERC721Contract.isApprovedForAll(EOA2, EOA3);
        assertFalse(isApprovedResults2);
        // Expect isApprovedForAll returns true for owner EOA1 and operator EOA2 when set to true works
        vm.startPrank(EOA1);
        ERC721Contract.setApprovalForAll(EOA2, true);
        bool isApprovedResults3 = ERC721Contract.isApprovedForAll(EOA1, EOA2);
        assertTrue(isApprovedResults3);
        // Expect isApprovedForAll returns false for owner EOA1 and operator EOA2 when set to false works
        ERC721Contract.setApprovalForAll(EOA2, false);
        bool isApprovedResults4 = ERC721Contract.isApprovedForAll(EOA1, EOA2);
        assertFalse(isApprovedResults4);
    }
} 