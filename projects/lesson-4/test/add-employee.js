var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];  //当前账号的第1个地址为雇主地址
  const employee = accounts[1]; //当前账号的第2个地址为雇员地址
  const employee_null = 0x0; //空地址
  const guest = accounts[5]; //非雇员地址，用于测试以非雇主身份添加雇员
  const salary = 1; //雇员薪水

  it("Test call addEmployee() by owner", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  //测试为雇员赋值负薪水
  it("Test call addEmployee() with negative salary", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, -salary, {from: owner});
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    });
  });

  //测试为雇员赋值零薪水
  it("Test call addEmployee() with zero salary", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, 0, {from: owner});
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Zero salary can not be accepted!");
    });
  });

  //测试为以非雇主身份添加雇员
  it("Test addEmployee() by guest", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: guest});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest");
    });
  });

  //测试添加空地址的雇员
  it("Test addEmployee() by 0x0 address", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(employee_null, salary, {from: owner});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "0x0 address cannot be accepted!");
    });
  });

  //测试添加雇员失败的情况
  it("Test addEmployee() failed to add employee", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
          assert(false, "failed to add employee");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "failed to add employee!");
    });
  });

});
