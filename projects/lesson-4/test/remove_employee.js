var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
	const owner = accounts[0];
	const employee1 = accounts[1];
	const employee2 = accounts[2];
	const totalFund = 20;
	const salary = 1;
	const runway = totalFund / salary;

	let payroll;

	beforeEach("Setup contract for each test cases", () => {
		return Payroll.new.call(owner, {from: owner, value: web3.toWei(totalFund, 'ether')}).then(instance => {
			payroll = instance;
		});
	});

	// Test removing existing and not existing employees by owner.
	it("Test removeEmployee() by owner. ", () => {
		return payroll.addEmployee(employee1, salary, {from: owner}).then(() => {
                        assert(true, "Employee should be successfully added.");
                }).then(() => {
			return payroll.removeEmployee(employee1, {from: owner}).then(() => {
				assert(true, "Existing employee can be successfully removed.");
			}).then(() => {
				return payroll.removeEmployee(employee2, {from: owner}).then(assert.fail).catch(error => {
					assert.include(error.toString(), "Error: VM Exception", "Not existing employee cannot be removed.");
				});
			});
		});
	});

	// Test remove employee not by owner.
	it("Test removeEmployee() not by owner. ", () => {
		return payroll.addEmployee(employee1, salary, {from: owner}).then(() => {
                        assert(true, "Employee should be successfully added.");
                }).then(() => {
			return payroll.removeEmployee(employee1, {from: employee2}).then(assert.fail).catch(error => {
                        	assert.include(error.toString(), "Error: VM Exception", "Employees cannot be removed by account other than owner.");
                        });
		});
	});
});	
