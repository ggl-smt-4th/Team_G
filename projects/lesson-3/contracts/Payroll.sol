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

    uint constant payDuration = 10 seconds;
    uint public totalSalary = 0;
    mapping(address => Employee) public employees; 
    uint salaryTotal = 0;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier employeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }

    function _partiaPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) public onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);
        salaryTotal = salaryTotal + employees[employeeId].salary;
    }

    function removeEmployee(address employeeId) public onlyOwner employeExist(employeeId){
        var employee = employees[employeeId];
        _partiaPaid(employee);
        delete employees[employeeId];
        salaryTotal -= employee.salary;
    }

    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeExist(oldAddress) employeeNotExist(newAddress) public {
        var employee = employees[oldAddress];
        employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeExist(employeeId){
        var employee = employees[employeeId];
        _partiaPaid(employee);
        salaryTotal -= employee.salary;
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
        salaryTotal += salary * 1 ether;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public  returns (uint) {
        return this.balance / salaryTotal;
    }

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeExist(msg.sender) public {
        var employee = employees[msg.sender];
        
        uint nextPaydat = employee.lastPayday.add(payDuration);
        assert(nextPaydat < now);
        
        employee.lastPayday = nextPaydat;
        employee.id.transfer(employee.salary);
    }
}
