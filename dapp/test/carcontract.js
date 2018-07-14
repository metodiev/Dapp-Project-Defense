var CarContract = artifacts.require("./CarContract.sol");

contract("CarContract", function(accounts) {
  var carInstance;

  it("makes sure that there is no negative number ammount of cars", function() {
    return CarContract.deployed().then(function(instance) {
      return instance.carsCount();
    }).then(function(count) {
      assert(count => 0);
    });
  });
  it("makes sure that there is no negative number ammount of cars", function() {
    return CarContract.deployed().then(function(instance) {
    return  instance.cars(0).then(function (car) {
      
     var carId = car[0];
     var modelCar = car[1];
     var modelYear = car[2];
     var carCost = car[3];
     var canBeTested = car[4];
     assert (canBeTested == true || canBeTested == false);
     assert(carCost >= 0); 
     assert(modelYear <=2018);
     assert(modelCar.length >= 0);
     assert(carId >= 0);
    });
  });
});
it("makes sure the structure has no empty value", function() {
  return CarContract.deployed().then(function(instance) {
  return  instance.votecar(0).then(function (votecar) {
  var carId = votecar[0];
  var carModel = votecar[1];
  var modelYear = votecar[2];
  var canBeTested = votecar[3];
  var carPaint = votecar[5];
  var carCoupe = votecar[6];
  var carEngine = votecar[7];
  assert(carEngine >=0 && carEngine <5);
  assert(carCoupe >=0 && carCoupe <5);
  assert(carPaint >=0 && carPaint <5);
  assert(canBeTested == true || canBeTested == false);
  assert(modelYear <= 2018);
  assert(carModel.length >= 0);
  assert(carId >= 0);

  });
});
});
});

