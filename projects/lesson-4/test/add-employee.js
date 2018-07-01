
var Payroll = artifacts.require("./Payroll.sol");

contract("Payroll", function (accounts) {
    const owner = accounts[0];
    const employee_a = accounts[1];
    const employee_b = accounts[2];
    const outsider = accounts[3];
    const salary = 1;

    it("An outsider calling addEmployee()",function () {
        var payroll;
        return Payroll.new().then(function (instance) {
            payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: outsider});
        }).then(() => {
            assert(false, "An outsider has succeeded.");
        }).catch(error => {
            assert.include(error.toString(), "Exception", "Only the owner can add new employees.");
        });
    });

    it("Calling addEmployee()", function() {
        var payroll;
        return Payroll.new().then(instance => {
            payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: owner})
        });
    });

    it("Adding an existing employee", function() {
        var payroll;
        return Payroll.new().then(instance => {
            payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: owner})
        }).then(function () {
            return payroll.addEmployee(employee_a, salary, {from: owner})
        }).then(() => {
            assert(false, "The employee has been added before.");
        }).catch(error => {
            assert.include(error.toString(), "Error", "Twice call can not be accepted.")
        })
    });
});