//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './ZombieHelper.sol';
contract ZombieBattle is ZombieHelper{
    
    uint attackVictoryProbability = 70;
    uint randNonce = 0;


    
    //随机数种子
    function randMod (uint _mod) internal returns(uint){
        randNonce++;
        return uint(keccak256(abi.encodePacked(randNonce,_mod)))%_mod;
    }
    function attack (uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage targetZombie = zombies[_targetId];
        uint rand = randMod(100);
        if(rand <= attackVictoryProbability){
            myZombie.winCount++;
            myZombie.level++;
            targetZombie.loseCount++;
            feedAndMultiply (_zombieId,targetZombie.dna,'zombie');
        }else{
            myZombie.loseCount++;
            targetZombie.winCount++;
            _triggerCooldown(myZombie);
        }
    }
}