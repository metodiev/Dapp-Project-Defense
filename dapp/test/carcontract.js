var CarContract = artifacts.require("./CarContract.sol");

contract("CarContract", function(accounts) {
  var carInstance;

  it("initializes with two candidates", function() {
    return CarContract.deployed().then(function(instance) {
      return instance.carsCount();
    }).then(function(count) {
      assert.equal(count, 2);
    });
  });
  it("it initializes the candidates with the correct values", function() {
    return CarContract.deployed().then(function(instance) {
        carInstance = instance;
      return carInstance.candidates(1);
    }).then(function(candidate) {
      assert.equal(candidate[0], 1, "contains the correct id");
      assert.equal(candidate[1], "Candidate 1", "contains the correct name");
      assert.equal(candidate[2], 0, "contains the correct votes count");
      return electionInstance.candidates(2);
    }).then(function(candidate) {
      assert.equal(candidate[0], 2, "contains the correct id");
      assert.equal(candidate[1], "Candidate 2", "contains the correct name");
      assert.equal(candidate[2], 0, "contains the correct votes count");
    });
  });
});
