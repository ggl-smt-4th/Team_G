pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address addr;
        uint salary;
        uint lastPayDay;
    }

    uint constant payDuration = 30 days;
    uint256 constant UINT256_MAX = ~uint256(0);

    address owner;
    Employee[] employees;
    uint totalSalary = 0;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _findEmployee(address employeeId) private view returns (uint, bool) {
        for (uint i = 0; i < employees.length; i++) {
            if (employeeId == employees[i].addr) {
                return (i, true);
            }
        }
        return (0, false);
    }
    
    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (_, found) = _findEmployee(employeeAddress);
        assert(!found);
        employees.push(Employee(employeeAddress, salary * 1 ether, now));
        totalSalary += (salary * 1 ether);
    }

    function _payRemaining(Employee e) private {
        e.addr.transfer(e.salary * (now - e.lastPayDay) / payDuration);
    }

    event e (address id, uint s);
    event index(uint i);
    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (idx, found) = _findEmployee(employeeId);
        assert(found);
        uint lastIdx = employees.length - 1;
        Employee storage toRemoveEmployee = employees[idx];
        employees[idx] = employees[lastIdx];
        emit index(idx);
        emit e(toRemoveEmployee.addr, toRemoveEmployee.salary);
        totalSalary -= toRemoveEmployee.salary;
        _payRemaining(toRemoveEmployee);
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (idx, found) = _findEmployee(employeeAddress);
        assert(found);
        totalSalary += (salary * 1 ether - employees[idx].salary);
        employees[idx].salary = salary * 1 ether;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        if (totalSalary == 0) {
            return UINT256_MAX;
        }
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (idx, found) = _findEmployee(msg.sender);
        assert(found);
        Employee storage e = employees[idx];
        uint nextPayDay = e.lastPayDay + payDuration;
        assert (nextPayDay <= now);
        e.lastPayDay = nextPayDay;
        e.addr.transfer(e.salary);
    }
}
