pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    
    mapping(address => Employee) employees;
    
    modifier employeeExists(address employeeAddress) {
        Employee storage employee = employees[employeeAddress];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExists(address employeeAddress) {
        Employee storage employee = employees[employeeAddress];
        assert(employee.id == 0x0);
        _;
    }
    
    function Payroll() payable public {
        owner = msg.sender;
    }
    
    function addEmployee(address employeeAddress, uint salary) onlyOwner employeeNotExists(employeeAddress) public {
        employees[employeeAddress] = Employee(employeeAddress, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
    }
    
    function removeEmployee(address employeeAddress) onlyOwner employeeExists(employeeAddress) public {
        Employee storage  employee = employees[employeeAddress];
        _partialPaid(employee);
        totalSalary -= employee.salary * 1 ether;
        delete employees[employeeAddress];
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) employeeExists(oldAddress) public {
        //Only the employee him/herself could change the payment address
        //require(oldAddress == msg.sender);
        require(newAddress != oldAddress);
        require(newAddress != 0x0);
        
        uint salary = employees[oldAddress].salary;
        uint lastPayday = employees[oldAddress].lastPayday;
        
        delete employees[oldAddress];
        employees[newAddress] = Employee(newAddress, salary, lastPayday);
    }
    
    function updateEmployee(address employeeAddress, uint salary) onlyOwner employeeExists(employeeAddress) public {
        Employee storage employee = employees[employeeAddress];
        _partialPaid(employee);
        
        //totalSalary += salary*1 ether - employee.salary*1 ether;
        totalSalary = totalSalary.add(salary.mul(1 ether));
        totalSalary = totalSalary.sub(employee.salary);
        
        employees[employeeAddress].salary = salary.mul(1 ether);
        employees[employeeAddress].lastPayday = now;
        
        //if this employee is brand new, should we add him/her to the list??????
        //addEmployee(employeeAddress, salary);
    }
    
    function addFund() payable public returns (uint) {
        return address(this).balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return address(this).balance.div(totalSalary);
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExists(msg.sender) public {
        Employee storage employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday <= now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employee.salary);
    }
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary.mul(now - employee.lastPayday).div(payDuration);
        employee.id.transfer(payment);
    }
}
