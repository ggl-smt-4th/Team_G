/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract MyPayroll {
    uint salary = 1 ether;
    address employee;
    address employer;
    uint constant payDuration = 10 seconds;
    uint lastPaydata = now;

    function MyPayroll() {
        employer = msg.sender;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calcutateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnougFund() returns (bool) {
        return calcutateRunway() > 0;
    }

    function updateEmployee(address e) {
        if (msg.sender != employer) {
            revert();
        }

        employee = e;
        lastPaydata = now;
    }

    function updateSalary(uint s) {
        if (msg.sender != employer) {
            revert();
        }

        salary = s;
        lastPaydata = now;
    }

    function getPaid() {
        if (msg.sender != employee) {
            revert();
        }
        uint nextPaydata = lastPaydata + payDuration;
        if (nextPaydata > now) {
            revert();
        }

        lastPaydata = nextPaydata;
        employee.transfer(salary);
    }
}
