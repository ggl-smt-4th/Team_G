
let Payroll = artifacts.require("./Payroll.sol");

contract("Payroll", function (accounts) {
    const owner = accounts[0];
    const employee_a = accounts[1];
    const employee_b = accounts[2];
    const outsider = accounts[3];
    const salary = 1;

    it("Calling removeEmployee()",function () {
        var payroll;
        return Payroll.new().then(function (instance) {
            payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: owner});
        }).then(function () {
            return payroll.removeEmployee(employee_a, {from: outsider});
        }).then(() => {
            assert(false, "Outsider has succeeded.");
        }).catch(error => {
            assert.include(error.toString(), "Error: VM Exceptio", "Cannot call removeEmployee() by guest.");
        });
    });

    it("Removing an outsider in removeEmployee()", function() {
        var payroll;
        return Payroll.new().then(function (instance) {
            payroll = instance;
            return payroll.removeEmployee(outsider, salary, {from: owner});
        }).then(() => {
            assert(false, "An outsider has been removed incorrectly.");
        }).catch(error => {
            assert.include(error.toString(), "Error: ", "You cannot remove an outsider.");
        });
    });

    it("The owner calling removeEmployee() correctly", function() {
        var payroll;
        return Payroll.new().then(function (instance) {
            payroll = instance;
            return payroll.addEmployee(employee_a, salary, {from: owner});
        }).then(() =>{
            return payroll.removeEmployee(employee_a, {from: owner});
        });
    });
});