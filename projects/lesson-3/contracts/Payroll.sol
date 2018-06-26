pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        address id;
	uint salary;
	uint lastPayDay;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    address owner;
    mapping(address => Employee) employees;

    function Payroll() public payable {}

    modifier addrNotFound(address addr) {
	require(employees[addr].id == 0x0);
	_;
    }

    modifier addrFound(address addr) {
	require(employees[addr].id != 0x0);
	_;
    }

    function _partialPay(address id, uint salary, uint lastPayDay) private {
	uint payment = salary.mul(now.sub(lastPayDay)).div(payDuration);
	id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner addrNotFound(employeeId) {
	require(salary > 0);
	employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
	totalSalary = totalSalary.add(salary * 1 ether);
    }

    function removeEmployee(address employeeId) public onlyOwner addrFound(employeeId) {
	uint salary = employees[employeeId].salary;
	uint lastPayDay = employees[employeeId].lastPayDay;
	delete employees[employeeId];
	totalSalary = totalSalary.sub(salary);
	_partialPay(employeeId, salary, lastPayDay);	
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner {
	employees[newAddress] = Employee(newAddress, employees[oldAddress].salary, employees[oldAddress].lastPayDay);
	delete employees[oldAddress];
    }

    // The employee should be partially paid based on old salay, followed by
    // setting new salary and lastPayDay as now.
    function updateEmployee(address employeeId, uint salary) public onlyOwner addrFound(employeeId) {
	salary = salary.mul(1 ether);
	uint oldSalary = employees[employeeId].salary;
	uint oldLastPayDay = employees[employeeId].lastPayDay;
	employees[employeeId].salary = 5 ether;
	//employees[employeeId].salary = salary;
	employees[employeeId].lastPayDay = now;
	totalSalary = totalSalary.add(salary.sub(oldSalary));
	_partialPay(employeeId, oldSalary, oldLastPayDay);
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

    function getPaid() public addrFound(msg.sender) {
	uint lastPayDay = employees[msg.sender].lastPayDay;
	uint nextPayDay = lastPayDay.add(payDuration);
	assert(nextPayDay < now);
	lastPayDay = nextPayDay;
	msg.sender.transfer(employees[msg.sender].salary);
    }
}
