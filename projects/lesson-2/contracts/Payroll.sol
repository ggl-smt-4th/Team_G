pragma solidity ^0.4.14;

contract Payroll{
    
    uint constant payDuration = 10 seconds;
    //
    struct struEmployee{
        address addrOfEmployee;
        uint salary;
        uint lastPayday;
    }

    
    address addrOfBoss;
    struEmployee[] struEmployees;
    
    //构造函数
    function Payroll() {
        
        addrOfBoss = msg.sender;
    }
    
    //
    function partialPaid(struEmployee employee) private{
        
        uint partialdPaid = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.addrOfEmployee.transfer(partialdPaid);
    }
    
    function findEmployee(address addrOfEmployee) private returns (struEmployee,uint) {
        
        for(uint i=0; i<struEmployees.length; i++)
        {
            if( struEmployees[i].addrOfEmployee == addrOfEmployee) 
            {
                return (struEmployees[i],i);
            }
        
        }
    }
    
    //存入工资
    function addfund() payable returns(uint) {
        
        return this.balance;
    }
    
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
    
    function removeEmployee(address addrOfEmployee) public {
        require(msg.sender == addrOfBoss);
        
        var (employee,index) = findEmployee(addrOfEmployee);
        
        assert(employee.addrOfEmployee != 0x0);


        partialPaid(employee);
        delete struEmployees[index];
        struEmployees[index] = struEmployees[struEmployees.length - 1] ;
        struEmployees.length -= 1;
    }
    
    function updateEmployee(address addrOfEmployee, uint salary) public {
        require(msg.sender == addrOfBoss);
        // TODO: your code here
        
        var (employee,index) = findEmployee(addrOfEmployee);
        
        partialPaid(employee);
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
        
    }
    
    function calculateRunWay() returns (uint) {
        
        uint ntotalSalary = 0;
        
        for(uint i=0;i<struEmployees.length;i++) {
            
            ntotalSalary += struEmployees[i].salary;
        }
            
        assert(ntotalSalary!=0);
        
        return this.balance/ntotalSalary;
    }
    
    function hasEnoughFund() returns (bool){
        
        return calculateRunWay()>0;
    }
    
    function getpaid() {
        
        var (employee,index) = findEmployee(msg.sender);
        assert(employee.addrOfEmployee != 0x0);
        
        
        uint nextPayday = employee.lastPayday + payDuration;
        if(nextPayday >now) revert();

        employee.lastPayday = nextPayday;
        employee.addrOfEmployee.transfer(employee.salary);
    }

}
