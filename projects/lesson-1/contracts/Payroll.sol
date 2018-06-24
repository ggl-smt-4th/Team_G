pragma solidity ^0.4.14;
contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;
    
    
    function Payroll(){
        owner = msg..sender
    }

    function updateEmployeeAddress(address newAddress) public {
        require(msg.sender == owner)
        // TODO: your code here
        if(employee != 0x0){
            uint payment = salary * (now - lastPayday)/payDuration
            employee.transfer(payment)
        }
        
        employee = newAddress
        lastPayday = now
    }

    function updateEmployeeSalary(uint newSalary) public {
        // TODO: your code here
        require(msg.sender = owner)
        
        salary = newSalary * 1 ether
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() view public returns (uint) {
        return address(this).balance / salary;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        require(msg.sender == employee)
        
        uint nextPayday = lastPayday + payDuration
        assert(nextPayday > now )
        employee.transfer(salary)
        
        
        
    }
}
