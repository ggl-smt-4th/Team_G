pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        address id;
        uint  salary;
        uint lastPayday;
        
    }
    
    uint constant payDuration = 30 day;
    uint public totalSalary = 0;
    mapping(address => Employee) employees;
    
    function Payroll() payable public onlyOwner{
        // TODO: your code here
    }
    
    modifier employeesExist(address employeeId){
        var employee=employees[employeeId];
        assert(employee.id !=0x0);
        _;
    }
    function _partition(Employee employee )private{
        uint parment=employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(parment);
    }
    function addEmployee(address employeeId, uint salary) public onlyOwner {
        // TODO: your code here
        var employee=employees[employeeId];
        assert(employee.id==0x0);
        employees[employeeId]=Employee(employeeId,salary.mul(1 ether),now);
        totalSalary=totalSalary.add(salary.mul(1 ether));
        
    }

    function removeEmployee(address employeeId) public onlyOwner employeesExist(employeeId){
        // TODO: your code here
         var employee=employees[employeeId];
        _partition(employee);
        totalSalary=totalSalary.sub(employee.salary);
        delete employees[employeeId];
       
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeesExist(oldAddress){
        // TODO: your code here
        var employee=employees[oldAddress];
        employee.id=newAddress;
        employees[newAddress]=employee;
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeesExist(employeeId){
        // TODO: your code here
         var employee=employees[employeeId];
         _partition(employee);
          totalSalary=totalSalary.sub(employee.salary);
         employees[employeeId].salary=salary.mul(1 ether);
         employees[employeeId].lastPayday=now;
         totalSalary=totalSalary.add(salary.mul(1 ether));
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway()>0;
    }

    function getPaid() public employeesExist(msg.sender){
        // TODO: your code here
        var employee=employees[msg.sender];
         var nextDay=employee.lastPayday+payDuration;
         assert(nextDay<now);
         employee.lastPayday=nextDay;
         employee.id.transfer(employee.salary);
    }
}
