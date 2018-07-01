
var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
    const owner = accounts[0];
    const employee_a = accounts[1];
    const employee_b = accounts[2];
    const outsider = accounts[3];
    const salary = 1;
    const payDuration = (30+1)*86400;
    const fund = 100;

    it("Test getPaid()", function () {
        var payroll;
        return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
            payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: owner});
        }).then(() => {
            return payroll.getPaid({from: employee_a});
        }).then(() => {
         assert(false, "Employee just got paid before the payday.");
        }).catch(error => {
            assert.include(error.toString(), "Error", "Employee should not get paid before the payday");
        });
    });

    it("An outsider calling getPaid()", function () {
        var payroll;
        return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
            payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: owner});
        }).then(() => {
        return payroll.getPaid({from: outsider});
        }).then(() => {
            assert(false, "Should not be successful");
        }).catch(error => {
            assert.include(error.toString(), "Error", "Should not call getPaid() by a non-employee");
        });
    });

    it("The employee calling getPaid() correctly", function () {
        var payroll;
        return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
        payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: owner});
        }).then(() => {
            return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
        }).then(() => {
            return payroll.getPaid({from: employee_a});
        });
    });
});