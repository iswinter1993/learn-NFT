//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './Ownable.sol';
import './ZombieFactory.sol';
import './HelloKittyInterface.sol';

contract ZombieFeeding is ZombieFactory,Ownable {

    //kitty 的 地址
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    
    function feedAndMultiply (uint _zombieId, uint _targetDna, string memory _species  ) internal  {
        require(zombieToOwner[_zombieId] == msg.sender, "not you zombie");
        Zombie storage myZombie = zombies[_zombieId];

        require(_isReady(myZombie),"cant eat");

        _targetDna = _targetDna % dnaModulus ;
        uint newDna  = (myZombie.dna + _targetDna)/2;

        if(keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))){
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie(myZombie.name, newDna);
        _triggerCooldown(myZombie);

    }

    function feedOnKitty (uint _zombieId , uint _kittyId ) public {
        (,,,,,,,,,uint kittyDna) = KittyInterface(ckAddress).getKitty(_kittyId);
        feedAndMultiply(_zombieId,kittyDna, "kitty");
    }

    function setKittyContractAddress (address _ckAddress) external onlyOwner {
        ckAddress = _ckAddress;
    }
    //冷却
    function _triggerCooldown (Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }
    //可以喂食
    function _isReady ( Zombie storage _zombie ) internal view returns(bool){
        return (_zombie.readyTime <= block.timestamp);
    }
}