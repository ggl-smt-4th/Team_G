pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 30 days;
    
    address owner;
    Employee[] employees;
    
    function _findEmployee(address employeeAddr) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeAddr) {
                return (employees[i], i);
            }
        }
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function Payroll() payable public {
        owner = msg.sender;
    }
    
    function addEmployee(address employeeAddr, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeAddr);
        
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeAddr, salary, now));
    }
    
    function removeEmployee(address employeeAddr) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeAddr);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address employeeAddr, uint salary) {
        require(msg.sender == owner);
        
        var (employee, index) = _findEmployee(employeeAddr);
        
        assert(employee.id == 0x0);
        
        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }
    
    function addFound() payable returns(uint) {
    
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalay = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalay += employees[i].salary;
        }
        return this.balance / totalSalay;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPaydat = employee.lastPayday + payDuration;
        assert(nextPaydat < now);
        
        employees[index].lastPayday = nextPaydat;
        employee.id.transfer(employee.salary);
    }
}
