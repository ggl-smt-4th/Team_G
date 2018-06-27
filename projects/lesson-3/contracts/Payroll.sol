pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        
        address id;
        uint lastPayDay;
        uint salary;
        
    }

    uint constant payDuration = 30 days;
    
    
    mapping(address => Employee) employees;
    
    uint totalSalary = 0;
    
    function Payroll() payable public {
        // TODO: your code here
        
        owner = msg.sender;

        
    }

    function addEmployee(address employeeId, uint salary) public {
        // TODO: your code here
        
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId,salary,now);
        totalSalary = totalSalary.add(salary);
    }


     function _payAllSalary(Employee storage employee) private {
         
        uint value = employee.salary.mul(now - employee.lastPayDay).div(payDuration);
        employee.id.transfer(value);
        employee.lastPayDay = now;
    }
    
    function _payPerSalary(Employee storage employee) private {
        
        uint newPayDay = employee.lastPayDay.add(payDuration);
        assert(newPayDay < now);
        employee.id.transfer(employee.salary);
        employee.lastPayDay = newPayDay;
    }
    
    
    function removeEmployee(address employeeId) public {
        // TODO: your code here
        
        _payAllSalary(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
        
    }

    function changePaymentAddress(address oldAddress, address newAddress) public {
        // TODO: your code here
        
        require(newAddress != 0x0);
        employees[newAddress] = Employee(newAddress,employees[oldAddress].salary,employees[oldAddress].lastPayDay);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public {
        // TODO: your code here
        
        salary = salary.mul(1 ether);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].id = employeeId;
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayDay = now;
        totalSalary = totalSalary.add(salary);


    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
        
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        
        require(totalSalary > 0);
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        _payPerSalary(employees[msg.sender]);

    }
}
