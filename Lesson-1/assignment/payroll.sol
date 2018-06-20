pragma solidity ^0.4.14;

contract Payroll{
    
    uint constant payDuration = 10 seconds; //支付周期
    
    address addrOfBoss; //雇主地址
    address addrOfEmployee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c; //员工地址
    uint salary = 1 ether; //薪水
    uint lastPayday = now; //最近一次支付时间
    
    //构造函数
    function Payroll(){
        
        addrOfBoss = msg.sender;
    }
    
    //老板存入工资
    function addfund() payable returns(uint) {
        
        return this.balance;
    }
    
    //计算还能发多少次工资
    function calculateRunWay() returns (uint) {
        
        return addfund() / salary;
    }
    
    //是否有足够的工资
    function hasEnoughFund() returns (bool){
        
        return calculateRunWay()>0 ;
    }
    
    //员工领取工资
    function getPaid(){
        
        require(msg.sender == addrOfEmployee); //判断是否为员工地址
        
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday >now) revert();

        lastPayday = nextPayday;
        addrOfEmployee.transfer(salary); //给员工支付工资
    }
    
    //更新员工地址和薪水
    function updateEmployee(address newAddress,uint newSalary) {
        
        if(msg.sender != addrOfBoss) revert(); //判断是否为雇主地址，即是否为雇主调用该函数
        
        if(addrOfEmployee==newAddress && salary==newSalary) revert(); //如果地址和薪水都没变，则无需执行后续代码
        
        //给之前的员工地址按时间支付应付工资
        if(addrOfEmployee != 0x00){
            
            uint salaryNeedPaid = (now-lastPayday)/payDuration * salary ;
            addrOfEmployee.transfer(salaryNeedPaid);
        }
        
        //更新地址、薪水以及最近一次支付时间
        addrOfEmployee = newAddress ;
        salary = newSalary * 1 ether ;
        lastPayday = now ;
    }

}
