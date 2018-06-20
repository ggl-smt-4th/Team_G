pragma solidity ^0.4.14;

contract Payroll{
    uint salary;
    address frank;
    uint payDuration = 10 seconds;
    uint lastPayday  = now;
    
    function setSalary (uint x){
        salary = x;
    }
    function setAddress (address y){
        frank = y;
    }
    function addFund() payable returns (uint){
        return this.balance;
    }
    function calculateRunway() returns (uint){
        return addFund() / salary;
    }
    function hasEnoughFund() returns(bool){
        return calculateRunway() > 0;
    }
    function getPaid(){
        if(msg.sender != frank){
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now ){
            revert();
        }
        lastPayday = nextPayday;
        frank.transfer(salary);
    }
    
}
