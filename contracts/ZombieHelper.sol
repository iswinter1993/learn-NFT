//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './ZombieFeeding.sol';
contract ZombieHelper is ZombieFeeding{


    uint levelUpFee = 0.001 ether;

    modifier aboveLevel (uint _level , uint _zombieId ) {
        require( zombies[_zombieId].level >= _level,"level too low");
        _;
    }

    function changeName (uint _zombieId, string memory _newName) external aboveLevel(2,_zombieId ) onlyOwnerOf(_zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender,"you are not owner!!");
        zombies[_zombieId].name = _newName;
    }

    function changeDna (uint _zombieId, uint _dna ) external aboveLevel(20,_zombieId) onlyOwnerOf(_zombieId) {
        require(zombieToOwner[_zombieId] == msg.sender,"you are not owner!!");
        zombies[_zombieId].dna = _dna;
    }
    //获取用户的所有僵尸
    function getZombiesByOwner (address _owner) external view returns( uint [] memory){
        uint [] memory result = new uint[](ownerZombieCount[_owner]);
        uint count = 0 ;
        
        for(uint i = 0 ; i < zombies.length; i++){
            if(zombieToOwner [i] == _owner){
                result[count] = i;
                count++;
            }
        }

        return result;
    }

    //通过向合约发送eth升级
    function levelUp (uint _zombieId) external payable {
        require(msg.value == levelUpFee,"you dont have enough money");
        zombies[_zombieId].level++;
    }
    //取出合约中的余额
    function withdraw () external onlyOwner {
        owner.transfer(address(this).balance);
    }
    //设置升级费
    function setLevelUpFee (uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

}