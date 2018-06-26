pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    
    using SafeMath for uint;
    
    struct struEmployee{
        address addrOfEmployee;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    
    mapping(address => struEmployee) public mapEmployees ;
    
    uint public ntotalSalary = 0;
    
    uint public nEmployeeNum = 0;
    
    modifier employeeExists(address addrOfEmployee) {
        var employee = mapEmployees[addrOfEmployee];
        assert(employee.addrOfEmployee != 0x0); 
        _;
    }
    
    modifier employeeChangeAddr(address oldAddress,address newAddress) {
        require(oldAddress != newAddress);
        
        var employee = mapEmployees[oldAddress];
        assert(employee.addrOfEmployee != 0x0);
        _;
    }
    
    //
    function partialPaid(struEmployee employee) private{
        
        uint partialdPaid = employee.salary * (now - employee.lastPayday)/payDuration;
        
        employee.addrOfEmployee.transfer(partialdPaid);
    }
    
    
    function addFund() payable public returns(uint) {
        
        return address(this).balance;
    }
    
    function getFund() public view returns(uint) {
        
        return address(this).balance;
    }
    
    //
    function addEmployee(address addrOfEmployee,uint salary) public  onlyOwner{
        
        var employee = mapEmployees[addrOfEmployee];
        assert(employee.addrOfEmployee == 0x0); 

        ntotalSalary = ntotalSalary.add(salary * 1 ether);
        
        mapEmployees[addrOfEmployee]= struEmployee(addrOfEmployee,salary * 1 ether,now) ;
        
        nEmployeeNum = nEmployeeNum.add(1);
        
    }
    
    function removeEmployee(address addrOfEmployee) public onlyOwner employeeExists(addrOfEmployee) {

        var employee = mapEmployees[addrOfEmployee];
        
        partialPaid(employee);
        
        ntotalSalary = ntotalSalary.sub(employee.salary);
        
        delete mapEmployees[employee.addrOfEmployee];
        nEmployeeNum = nEmployeeNum.sub(1);
    }
    
    function updateEmployee(address addrOfEmployee, uint salary) public onlyOwner employeeExists(addrOfEmployee){
        
        var employee = mapEmployees[addrOfEmployee];
        
        assert(employee.addrOfEmployee != 0x0);
        
        ntotalSalary = ntotalSalary.sub(employee.salary);
        
        partialPaid(employee);
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
        
        ntotalSalary = ntotalSalary.add(employee.salary);
        
    }
    
    // public onlyOwner employeeChangeAddr(oldAddress,newAddress)
    function changePaymentAddress(address oldAddress,address newAddress) public onlyOwner employeeChangeAddr(oldAddress,newAddress){

        var employee = mapEmployees[oldAddress];
        
        partialPaid(employee);

        employee.addrOfEmployee = newAddress;
        employee.lastPayday = now;
        
    }
    
    function checkEmployeeInfo(address addrOfEmployee) public employeeExists(addrOfEmployee) view returns (uint salary,uint lastPayday) {
        
        var employee = mapEmployees[addrOfEmployee];

        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function calculateRunway() public view returns (uint)  {
            
        assert(ntotalSalary!=0);
        
        return address(this).balance.div(ntotalSalary) ;
    }
    
    function hasEnoughFund() public view returns (bool) {
        
        return calculateRunway()>0;
    }
    
    function getPaid() public employeeExists(msg.sender){
        
        var employee = mapEmployees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        if(nextPayday >now) revert();

        employee.lastPayday = nextPayday;
        employee.addrOfEmployee.transfer(employee.salary);
    }

}
