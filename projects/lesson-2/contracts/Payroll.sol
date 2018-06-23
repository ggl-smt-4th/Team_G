pragma solidity ^0.4.14;

contract Payroll{
    
    uint constant payDuration = 30 days;
    
    //员工信息对象
    struct struEmployee{
        address addrOfEmployee;
        uint salary;
        uint lastPayday;
    }

    
    address addrOfBoss; //雇主地址
    struEmployee[] struEmployees; //多个员工
    
    //构造函数
    function Payroll() {
        
        addrOfBoss = msg.sender;
    }
    
    //提前支付
    function partialPaid(struEmployee employee) private{
        
        uint partialdPaid = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.addrOfEmployee.transfer(partialdPaid);
    }
    
    //根据地址查找员工
    function findEmployee(address addrOfEmployee) private returns (struEmployee,uint) {
        
        for(uint i=0; i<struEmployees.length; i++)
        {
            if( struEmployees[i].addrOfEmployee == addrOfEmployee) 
            {
                return (struEmployees[i],i);
            }
        
        }
    }
    
    //存入工资基金
    function addfund() payable returns(uint) {
        
        return this.balance;
    }
    
    //添加雇员
    function addEmployee(address addrOfEmployee,uint salary) public{
        
        require(msg.sender == addrOfBoss);

        for(uint i=0; i<struEmployees.length; i++)
        {
            if( struEmployees[i].addrOfEmployee == addrOfEmployee) 
            {
                revert();
            }
        }

        struEmployees.push(struEmployee(addrOfEmployee,salary * 1 ether,now));
    }
    
    //删除员工
    function removeEmployee(address addrOfEmployee) public {
        require(msg.sender == addrOfBoss);
        
        var (employee,index) = findEmployee(addrOfEmployee);
        
        assert(employee.addrOfEmployee != 0x0);

        partialPaid(employee);
        delete struEmployees[index];
        struEmployees[index] = struEmployees[struEmployees.length - 1] ;
        struEmployees.length -= 1;
    }
    
    //更新员工信息
    function updateEmployee(address addrOfEmployee, uint salary) public {
        require(msg.sender == addrOfBoss);
        // TODO: your code here
        
        var (employee,index) = findEmployee(addrOfEmployee);
        
        partialPaid(employee);
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
        
    }
    
    //计算工资基金还能发多少次工资
    function calculateRunWay() returns (uint) {
        
        uint ntotalSalary = 0;
        
        for(uint i=0;i<struEmployees.length;i++) {
            
            ntotalSalary += struEmployees[i].salary;
        }
            
        assert(ntotalSalary!=0);
        
        return this.balance/ntotalSalary;
    }
    
    //工资基金是否够发工资
    function hasEnoughFund() returns (bool){
        
        return calculateRunWay()>0;
    }
    
    //员工领取工资
    function getpaid() {
        
        var (employee,index) = findEmployee(msg.sender);
        assert(employee.addrOfEmployee != 0x0);
        
        
        uint nextPayday = employee.lastPayday + payDuration;
        if(nextPayday >now) revert();

        employee.lastPayday = nextPayday;
        employee.addrOfEmployee.transfer(employee.salary);
    }

}
