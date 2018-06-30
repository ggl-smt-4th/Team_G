let Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[2];
  const guest1 = accounts[3];
  const salary = 1;

  let payroll;

  beforeEach("Setup contract for each test cases", () => {
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  it("Test call removeEmployee() by owner", () => {
    // Remove employee
    return payroll.removeEmployee(employee, {from: owner});
  });

  it("Test call removeEmployee() by guest", () => {
    return payroll.removeEmployee(employee, {from: guest}).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
    });
  });

  it("Test call removeEmployee() employee does not exist", () => {
    return payroll.removeEmployee(guest1, {from: owner}).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "This employee does not exist!");
    });
  });

  it("Test call removeEmployee() employee is still exist", () => {
    return payroll.removeEmployee(employee, {from: owner}).then(() => {
      var struEmployeeTmp = payroll.mapEmployees[employee];
      if(struEmployeeTmp.addrOfEmployee!=0x0)
          assert(false, "failed to removeEmployee"); 
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "This employee is still exist!");
    });
  });


});