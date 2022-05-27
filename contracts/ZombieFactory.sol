// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract ZombieFactory {

    //1.   定义僵尸DNA 由16位数字组成
    uint public dnaDigits = 16;
    //2. 为了保证我们的僵尸的DNA只含有16个字符，我们先造一个uint数据，让它等于10^16。这样一来以后我们可以用模运算符 % 把一个整数变成16位。
    uint public dnaModulus = 10**dnaDigits;
    //喂食后的 冷却时间
    uint cooldownTime = 1 days;

    //3. 定义结构体
    struct Zombie{
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    //8. 定义映射 通过id（uint）查找 owner（address）
    mapping(uint=>address) public zombieToOwner ;
    //9. 通过 owner（address） 查找 僵尸数量（uint）
    mapping(address=>uint) public ownerZombieCount ;


    //4. 定义保存僵尸的数组
    Zombie[] public zombies;


    event NewZombie(uint zombieId , string name, uint dna);
    //5. 创建僵尸函数私有方法
    function _createZombie (string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name,_dna,1,uint32(block.timestamp + cooldownTime)));
        uint id = zombies.length - 1;
        //给僵尸指定owner
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender] + 1;
        emit NewZombie(id, _name, _dna);
    } 
    //6. 生成随机dna
    function _generateRandomDna (string memory _str) private view returns(uint) {
        //获取随机数
        uint rand = uint(keccak256(abi.encode(_str)));
        //保持dna是16位，对rand取模
        return rand % dnaModulus ;
    }

    //7. 创建僵尸公共方法
    function createRandomZombie (string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "you had Zombie!!!");
        uint _dna = _generateRandomDna(_name);
        
        _createZombie(_name,_dna);
    }

    

}
