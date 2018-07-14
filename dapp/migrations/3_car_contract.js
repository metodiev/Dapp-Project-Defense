var CarContract = artifacts.require("./CarContract.sol");

module.exports = function(deployer) {
  deployer.deploy(CarContract);
};