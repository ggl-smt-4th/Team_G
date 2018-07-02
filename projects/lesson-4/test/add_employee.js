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
	
	// Test adding two employees and duplicate employees by owner.
	it("Test addEmployee() by owner. ", () => {
		return payroll.addEmployee(employee1, salary, {from: owner}).then(() => {
			assert(true, "First employee should be successfully added.");
		}).then(() => {
			return payroll.calculateRunway();
		}).then(rw => {
			assert.equal(rw.toNumber(), runway, "The runway should be correct");
		}).then(() => {
			return payroll.addEmployee(employee2, salary, {from: owner}).then(() => {
				assert(true, "The second employee should be successfully added.");
			}).then(() => {
				return payroll.calculateRunway();
			}).then(rw => {
				assert.equal(rw.toNumber(), runway /2, "The runway should be correct");
			});
		}).then(() => {
                        return payroll.addEmployee(employee2, salary, {from: owner});
		}).then(assert.fail).catch(error => {
			assert.include(error.toString(), "Error: VM Exception", "The same employee cannot be added twice.");
		});
	});

	// Test add employee not by owner.
	it("Test addEmployee() not by owner. ", () => {
                return payroll.addEmployee(employee1, salary, {from: employee1}).then(assert.fail).catch(error => {
			assert.include(error.toString(), "Error: VM Exception", "Only owner can add employee");
        	});
	});

	// Test addEmployee() with negative salary.
	  it("Test addEmployee() with negative salary", () => {
      		return payroll.addEmployee(employee1, -salary, {from: owner}).then(assert.fail).catch(error => {
      			assert.include(error.toString(), "Error: VM Exception", "Negative salary!");
    		});
  	});
}); 
