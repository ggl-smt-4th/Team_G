/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address boss;
    address frank;
    uint constant payDuring = 30 days;
    uint lastPayDay = now;
    
    constructor (address f) public {
        boss = msg.sender;
        frank = f;
    }
    
    function addFund() public payable returns (uint) {
        return this.balance;
    }
    
    // Only Boss is able to set his address.
    function setBossAddr(address newAddr) public {
        if (msg.sender != boss && boss != address(0)) {
            revert();
        }
        boss = newAddr;
    }
    
    // Only Boss is able to get his address.
    function getBossAddr() public view returns (address) {
        if (msg.sender != boss) {
            revert();
        }
        return boss;
    }
    
    // Only frank is able to set his address.
    function setFrankAddr(address newAddr) public {
        if (msg.sender != frank && frank != address(0)) {
            revert();
        }
        frank = newAddr;
    }
    
    // Only frank is able to get his address.
    function getFrankAddr() public view returns (address) {
        if (msg.sender != frank) {
            revert();
        }
        return frank;
    }
    
    // Only boss is able to set salary.
    function setSalary(uint amount) public {
        if (msg.sender != boss) {
            revert();
        }
        salary = amount;
    }
    
    // Only frank and boss is able to check salary.
    function getSalary() public view returns (uint) {
        if (msg.sender != frank && msg.sender != boss) {
            revert();
        }
        return salary;
    }

    function getPaid() public {
        if (msg.sender != frank) {
            revert();
        }
        uint nextPayDay = lastPayDay + payDuring;
        if (nextPayDay > now) {
            revert();
        }
        lastPayDay = nextPayDay;
        frank.transfer(salary);
    }
}
