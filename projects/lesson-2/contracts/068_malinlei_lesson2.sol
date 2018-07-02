pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
       address id;
       uint salary;
       uint LastPayday; 
    }
   //gas 变化情况25622、27184、28746、30308、31870、33432、34994、36556、38118、39680
   //当添加一个员工的时候,方法内部会多循环一次
   //添加全局变量totalSalay_opt 来记录总的工资数 会比每次循环减少开支
    uint constant payDuration = 30 day;

    address owner;
    Employee[] employees;
     uint totalSalay_opt=0;
    function Payroll() payable public {
        owner = msg.sender;
    }
    function _partialPaid(Employee employee)private {
        uint payment=employee.salary*(now-employee.LastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    function findEmployee(address employeeAddress) private returns(Employee,uint){
      for(uint i=0;i<employees.length;i++){
          if(employees[i].id==employeeAddress){
              return (employees[i],i);
          }
      }
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee,index)=findEmployee(employeeAddress);
        assert(employee.id==0x0);
        employees.push(Employee(employeeAddress,salary*1 ether,now));
        totalSalay_opt+=salary*1 ether;
    }

    function removeEmployee(address employeeAddress) public {
        require(msg.sender == owner);
        // TODO: your code here
          var (employee,index)=findEmployee(employeeAddress);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length-=1;
         totalSalay_opt-=employee.salary;
    }
    
    function search() returns(address,uint,uint){
        return (owner,employees.length,employees[0].salary);
    }
    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
        var (employee,index)=findEmployee(employeeAddress);
        assert(employee.id!=0x0);
        _partialPaid(employee);
        totalSalay_opt=totalSalay_opt-employee.salary+salary*1 ether;
        employees[index].salary=salary*1 ether;
         employees[index].LastPayday=now;
    }


    function addFund() payable public returns (uint) {
        return this.balance;
    }
    function calculateRunway_opt() public view returns(uint){
        return this.balance/totalSalay_opt;
    }
    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        uint totalSalay=0;
        for(uint i=0;i<employees.length;i++){
            totalSalay+=employees[i].salary;
        }
        return this.balance/totalSalay;
        
    }

    function hasEnoughFund() public view returns (bool) {
       // return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
        var (employee,index)=findEmployee(msg.sender);
        assert(employee.id!=0x0);
        uint nextPayday=employees[index].LastPayday+payDuration;
        assert(nextPayday<now);
        employees[index].LastPayday=nextPayday;
        employee.id.transfer(employee.salary);
    }
}
