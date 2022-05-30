//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './ZombieBattle.sol';
import './ERC721.sol';
contract ZombieOwnership is ZombieBattle, ERC721{

    mapping(uint => address) public zombieApprovals;

    function balanceOf(address _owner ) public override view returns (uint256 _balance) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId ) public override view returns (address _owner) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId ) internal {
        ownerZombieCount[_from]--;
        ownerZombieCount[_to]++;
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }

    function transfer (address _to, uint256 _tokenId ) public override onlyOwnerOf (_tokenId) {
        _transfer(msg.sender,_to,_tokenId);
    }

    function approve(address _to, uint256 _tokenId ) public override onlyOwnerOf (_tokenId) {
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender,_to,_tokenId);
    }

    function takeOwnership(uint256 _tokenId ) public override {
        require(zombieApprovals[_tokenId] == msg.sender,"you are not approved");
        address owner = ownerOf(_tokenId);
        _transfer(owner,msg.sender,_tokenId);
        
    }
}