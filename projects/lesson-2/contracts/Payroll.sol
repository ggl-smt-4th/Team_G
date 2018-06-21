pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address addr;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint s) public {
        require(msg.sender == owner);
        employees.push(Employee(employeeAddress, s, now));
    }

    function _findEmployee(address employeeId) private view returns (uint, bool) {
        for (uint i = 0; i < employees.length; i++) {
            if (employeeId == employees[i].addr) {
                return (i, true);
            }
        }
        return (0, false);
    }
    
    function _payRemaining(Employee e) private {
        e.addr.transfer(e.salary * (now - e.lastPayDay) / payDuration);
    }
    
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (idx, found) = _findEmployee(employeeId);
        assert(found);
        uint lastIdx = employees.length - 1;
        Employee toRemoveEmployee = employees[idx];
        employees[idx] = employees[lastIdx];
        employees.length -= 1;
        _payRemaining(toRemoveEmployee);
        // TODO: If failed to transfer, add to unpaid.
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (idx, found) = _findEmployee(employeeAddress);
        assert(found);
        employees[idx].salary = salary;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < employees.length; i++) {
            sum += employees[i].salary;
        }
        return address(this).balance / sum;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (idx, found) = _findEmployee(msg.sender);
        assert(found);
        Employee e = employees[idx];
        uint nextPayDay = e.lastPayDay + payDuration;
        assert (nextPayDay <= now);
        e.lastPayDay = nextPayDay;
        e.addr.transfer(e.salary);
    }
}
