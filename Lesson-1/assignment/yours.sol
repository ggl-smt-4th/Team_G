
pragma solidity ^0.4.14;

contract Payroll {
    uint salary;
    address owner;
    address employee;
    uint constant payDuration = 30 days;
    uint lastPayday = now;
    
    function setEmployee(address _add) {
        if(owner != msg.sender) {
            return revert();
        }
        
        owner = _add;
    } 
    
    function setSalary(uint _sal) {
        if(owner != msg.sender) {
            return revert();
        }
        
        if(salary == 0) {
            revert();
        }
        
        salary = _sal * 1 ether;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getpaid()  {
        if(msg.sender != employee) {
            revert();
        }
        
        if( ! hasEnoughFund() ) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        } 
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
}
