// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/forge-std/src/Test.sol";
import "src/tokens/OakNft.sol";

contract OakNftTest is Test {
    OakNft public Oak721;
    string URIBASE = "IPFS://BASELEVEL"; 
    address public OWNER = address(0x01);
    address public ART = address(0x02);
    address public WHALE = address(0x03);
    address public FAN = address(0x04);
    address public FRIEND = address(0x05);
    address public PEON = address(0x06);
    address public BROKE = address(0x07);
    address public OWNER1 = address(0x08);

    event Mint(address indexed _to, uint256 indexed _tokenId, uint16 indexed _rank );

    function setUp() public {
        Oak721 = new OakNft(URIBASE,ART);
    }

    function testEthBalance() public  {
        //Expect Whale mint of 1 ether works.
        hoax(WHALE,1 ether);
        assertEq(WHALE.balance, 1 ether);
        vm.expectEmit();
        emit Mint(WHALE,0,4);
        Oak721.mint{value: 1 ether}(WHALE);
        assertEq(WHALE.balance, 0);
        address Mint0Result = Oak721.ownerOf(0);
        assertEq(Mint0Result, WHALE);
        //Expect Fan mint of .1 Ether works.
        hoax(FAN,0.1 ether);
        assertEq(FAN.balance, 0.1 ether);
        vm.expectEmit();
        emit Mint(FAN,1,3);
        Oak721.mint{value:0.1 ether}(FAN);
        assertEq(FAN.balance, 0);
        address Mint1Result = Oak721.ownerOf(1);
        assertEq(Mint1Result, FAN);
        //Expect Friend mint of .01 Ether works.
        hoax(FRIEND, 0.01 ether);
        assertEq(FRIEND.balance, 0.01 ether);
        vm.expectEmit();
        emit Mint(FRIEND,2,2);
        Oak721.mint{value: 0.01 ether}(FRIEND);
        assertEq(FRIEND.balance, 0);
        address Mint2Result = Oak721.ownerOf(2);
        assertEq(Mint2Result, FRIEND);
        //Expect Peon mint of .001 Ether works.
        hoax(PEON,0.001 ether);
        assertEq(PEON.balance, 0.001 ether);
        vm.expectEmit();
        emit Mint(PEON,3,1);
        Oak721.mint{value:0.001 ether}(PEON);
        assertEq(PEON.balance, 0);
        address Mint3Result = Oak721.ownerOf(0);
        assertEq(Mint3Result, WHALE);
        // Expect Contract Balance to equal 1.111 ether
        assertEq(address(Oak721).balance, 1.111 ether);
        //Expect Broke Mint to fail
        vm.startPrank(BROKE);
        vm.expectRevert("Insufficient Mint Value");
        Oak721.mint(BROKE);
        // Expect Incorrect Value mint to Fail
        hoax(WHALE, 0.5 ether);
        vm.expectRevert("incorrect Mint Amount");
        Oak721.mint{value: 0.5 ether}(WHALE);
        uint256 Mint4Result = Oak721.balanceOf(WHALE);
        assertEq(Mint4Result, 1);
        //Expect Value of 1.111 mint to Fail
        hoax(FAN, 1.111 ether);
        vm.expectRevert("incorrect Mint Amount");
        Oak721.mint{value: 1.111 ether}(FAN);
        assertEq(FAN.balance, 1.111 ether);
        //Expect 
        
    }

    function testMultipleMint() public {
        //Expect multiple Whale mints to work
        deal(WHALE, 1.111 ether);
        vm.startPrank(WHALE);
        assertEq(WHALE.balance, 1.111 ether);
        vm.expectEmit();
        emit Mint(WHALE, 0, 4);
        Oak721.mint{value:1 ether}(WHALE);
        assertEq(WHALE.balance, .111 ether);
        vm.expectEmit();
        emit Mint(WHALE, 1, 3);
        Oak721.mint{value: .1 ether}(WHALE);
        vm.expectEmit();
        emit Mint(WHALE, 2, 2);
        Oak721.mint{value: .01 ether}(WHALE);
        vm.expectEmit();
        emit Mint(WHALE, 3, 1);
        Oak721.mint{value: .001 ether}(WHALE);
        assertEq(WHALE.balance, 0);
        uint256 Mint5Results = Oak721.balanceOf(WHALE);
        assertEq(Mint5Results, 4);
    }

    function testWithdrawl() public {
        Oak721.setOwner(OWNER);
        //Expect Whale mint level 4 works.
        hoax(WHALE, 1 ether);
        Oak721.mint{value: 1 ether }(WHALE);
        assertEq(address(Oak721).balance, 1 ether);
        // Expect Withdraw works.
        vm.startPrank(OWNER);
        Oak721.withdraw();
        assertEq(ART.balance, 1 ether / 2);
        assertEq(OWNER.balance, 1 ether / 2);
        assertEq(address(Oak721).balance, 0);
        //Expect Swap Owner Withdraw Works
        Oak721.setOwner(OWNER1);
        hoax(FAN, .1 ether);
        Oak721.mint{value: .1 ether}(FAN);
        vm.startPrank(OWNER);
        vm.expectRevert("Not authorized");
        Oak721.withdraw();
        vm.startPrank(OWNER1);
        Oak721.withdraw();
        assertEq(ART.balance, 1 ether / 2 + .1 ether / 2);
        assertEq(OWNER1.balance, .1 ether / 2);
        assertEq(address(Oak721).balance, 0);
        //Expect unauthorized Owner Withdraw fails
        deal(FRIEND, .01 ether);
        vm.startPrank(FRIEND);
        Oak721.mint{value: .01 ether}(FRIEND);
        vm.expectRevert("Not authorized");
        Oak721.withdraw();
        vm.startPrank(OWNER1);
        Oak721.withdraw();
        assertEq(ART.balance, 1 ether / 2 + .1 ether / 2 + .01 ether / 2);
        assertEq(OWNER1.balance, .1 ether / 2 + .01 ether / 2 );
        assertEq(address(Oak721).balance, 0);
       //Expect Contract Zero Balance fails
       vm.expectRevert("Insufficient Withdrawl Value");
       Oak721.withdraw();
    }
}

