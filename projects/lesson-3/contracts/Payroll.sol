pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{
    
    //通过SafeMath定义了uint的命令空间，可直接执行简单运算
    using SafeMath for uint;
    
    struct struEmployee{
        address addrOfEmployee;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 30 days;

    //员工对象
    mapping(address => struEmployee) public mapEmployees ;
    
    //总薪水
    uint public ntotalSalary = 0;
    
    //员工数量
    uint public nEmployeeNum = 0;
    
    function Payroll() payable public {
       
    }
    
    //判断员工是否存在
    modifier employeeExists(address addrOfEmployee) {
        var employee = mapEmployees[addrOfEmployee];
        assert(employee.addrOfEmployee != 0x0); 
        _;
    }
    
    //员工工资地址修改modifier
    modifier employeeChangeAddr(address oldAddress,address newAddress) {
        require(oldAddress != newAddress);
        
        require(newAddress != 0x0);
        
        var employee = mapEmployees[oldAddress];
        assert(employee.addrOfEmployee != 0x0);
        _;
    }
    
    //提前支付部分工资
    function partialPaid(struEmployee employee) private{
        
        uint partialdPaid = employee.salary * (now - employee.lastPayday)/payDuration;
        
        employee.addrOfEmployee.transfer(partialdPaid);
    }
    
    //增加工资基金
    function addFund() payable public returns(uint) {
        
        return address(this).balance;
    }
    
    //获取当前合约中存放的工资基金
    function getFund() public view returns(uint) {
        
        return address(this).balance;
    }
    
    //添加员工
    function addEmployee(address addrOfEmployee,uint salary) public  onlyOwner{
        
        var employee = mapEmployees[addrOfEmployee];
        assert(employee.addrOfEmployee == 0x0); 

        ntotalSalary = ntotalSalary.add(salary.mul(1 ether));
        
        mapEmployees[addrOfEmployee]= struEmployee(addrOfEmployee,salary.mul(1 ether),now) ;
        
        nEmployeeNum = nEmployeeNum.add(1);
        
    }
    
    //删除员工
    function removeEmployee(address addrOfEmployee) public onlyOwner employeeExists(addrOfEmployee) {

        var employee = mapEmployees[addrOfEmployee];
        
        partialPaid(employee);
        
        ntotalSalary = ntotalSalary.sub(employee.salary);
        
        delete mapEmployees[employee.addrOfEmployee];
        nEmployeeNum = nEmployeeNum.sub(1);
    }
    
    //更新员工
    function updateEmployee(address addrOfEmployee, uint salary) public onlyOwner employeeExists(addrOfEmployee){
        
        var employee = mapEmployees[addrOfEmployee];
        
        assert(employee.addrOfEmployee != 0x0);
        
        ntotalSalary = ntotalSalary.sub(employee.salary);
        
        partialPaid(employee);
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;
        
        ntotalSalary = ntotalSalary.add(employee.salary);
        
    }
    
    //修改员工工资地址
    function changePaymentAddress(address oldAddress,address newAddress) public onlyOwner employeeChangeAddr(oldAddress,newAddress){

        var employee = mapEmployees[oldAddress];
        
        partialPaid(employee);

        mapEmployees[newAddress] = struEmployee(newAddress,employee.salary,now);
        
        delete mapEmployees[oldAddress];

    }
    
    //查询员工的薪水和最近支付时间
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
    
    //支付工资
    function getPaid() public employeeExists(msg.sender){
        
        var employee = mapEmployees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        if(nextPayday >now) revert();

        employee.lastPayday = nextPayday;
        employee.addrOfEmployee.transfer(employee.salary);
    }
}
