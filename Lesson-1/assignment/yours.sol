/*作业请提交在这个目录下*/
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    
    uint constant payDuration = 10 seconds;

    address owner;
    
    uint salary;
    salary = 0.1;   //default
    
    address employee;
    employee = 0xdd870fa1b7c4700f2bd7f44238821c26f7392148;      //default
    
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);

        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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

    function getPaid() {
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    function changeEmployeeAddress(address e){
        
        if(msg.sender != owner){                    //only the BOSS can handle this
            revert();
        }
        
        employee = e;
        
        lastPayday = now;

    }
    
    function changeEmployeeSalary(uint s){
        
        if(msg.sender != owner ){                   //only the BOSS can pay employee
            revert();
        }
        
        salary = s;  
        
        lastPayday = now;

    }
}
