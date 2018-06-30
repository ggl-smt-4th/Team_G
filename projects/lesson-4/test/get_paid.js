var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
	const owner = accounts[0];
	const employee1 = accounts[1];
	const employee2 = accounts[2];
	const totalFund = 20;
	const salary = 9;
	const runway = totalFund / salary;
	const payDuration = (30 + 1) * 86400;

	let payroll;

	beforeEach("Setup contract for each test cases", () => {
		return Payroll.new.call(owner, {from: owner, value: web3.toWei(totalFund, 'ether')}).then(instance => {
			payroll = instance;
		}).then(() => {
			return payroll.addEmployee(employee1, salary, {from: owner});
		});
	});
	
	it("Test getPaid() cannot be called too frequently. ", () => {
		return payroll.getPaid({from: employee1}).then(assert.fail).catch(error => {
			assert.include(error.toString(), "Error: VM Exception", "Cannot get paid before next pay day.");
		});
	});

	it("Test run out of fun after calling getPaid() several times. ", () => {
		web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration + 1], id: 0});
		return payroll.getPaid({from: employee1}).then(() => {
			assert(true, "The first salary can be paid.");
		}).then(() => {
			web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration + 1], id: 0});
			return payroll.getPaid({from: employee1}).then(() => {
				assert(true, "The second salary can be paid.");
			}).then(() => {
				web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration + 1], id: 0});
				return payroll.getPaid({from: employee1}).then(assert.fail).catch(error => {
					assert.include(error.toString(), "Error: VM Exception", "No enough fund.");
				});
			});
		});
	});

	it("Test getPaid() cannot be called by non-employee. ", () => {
		web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration + 1], id: 0});
		return payroll.getPaid({from: employee2}).then(assert.fail).catch(error => {
                        assert.include(error.toString(), "Error: VM Exception", "Cannot get paid by non existing employee.");
		});
	});
});	
