App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function () {
    return App.initWeb3();
  },

  initWeb3: function () {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initCarContract();
  },


  initCarContract: function () {
    $.getJSON("CarContract.json", function (CarContract) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.CarContract = TruffleContract(CarContract);
      // Connect provider to interact with contract
      App.contracts.CarContract.setProvider(App.web3Provider);
      App.voteCoupe();
      App.voteEngine();
      App.votePaint();
      App.carCatalogue();
      return App.carBuy();
    });
  }
  ,
  carContract: function () {
    $.getJSON("CarContract.json", function (CarContract) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.CarContract = TruffleContract(CarContract);
      // Connect provider to interact with contract
      App.contracts.CarContract.setProvider(App.web3Provider);

      return App.carRender();
    });
  },
  //car sell
  carSell: function () {
    var carInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.CarContract.deployed().then(function (instance) {
      carInstance = instance;

      var carModel = document.getElementById("carmodel").value;
      var carYear = document.getElementById("caryear").value;
      var carPrice = document.getElementById("carprice").value;
      var carTest = document.getElementById("cartest").value;
      var carVoted = document.getElementById("carvote").value;

      //check for symbols
      var symbolStr = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;
      alert(symbolStr.test(carModel))
      if ((isNaN(carYear) && isNaN(carPrice) )  || (symbolStr.test(carModel))) {
        alert("Invalid Input");
        return;
      }

      carInstance.addNewCar(carModel, carYear, carPrice, carTest, carVoted);
      
      App.carBuy();
    });
  },
  //fill car select option
  carBuy: function () {
    var carInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.CarContract.deployed().then(function (instance) {
      carInstance = instance;
      console.log(carInstance);
      return carInstance.carsCount();
    }).then(function (carsCount) {
      var carResults = $("#carResults");
      carResults.empty();

      var carSelect = $('#carSelect');
      carSelect.empty();

      for (var i = 1; i <= carsCount; i++) {
        carInstance.cars(i).then(function (car) {
          var id = car[0];
          var name = car[1];
          var voteCount = car[2];

          // Render candidate Result
          var carTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
          carResults.append(carTemplate);

          // Render car option
          var carOption = "<option value='" + id + "' >" + name + "</ option>"
          carSelect.append(carOption);
        });
      }
    });
  },
  //order a car
  orderCar: function () {
    var selectedCar = document.getElementById("carSelect").value;
    alert(selectedCar);

    var checkBoxDepositCar = document.getElementById("depositcar");
    var checkBoxBuyCar = document.getElementById("buycar");

    //check only one checkbox to be checked
    if (checkBoxDepositCar.checked == true && checkBoxBuyCar.checked == true) {
      alert("Only one box can be checked at time");

      document.getElementById("depositcar").checked = false;
      document.getElementById("buycar").checked = false;
    }
    //check if checkbox is checked
    if (checkBoxDepositCar.checked == true) {
      alert("depositCar");

      // Load contract data
      App.contracts.CarContract.deployed().then(function (instance) {
        carInstance = instance;
        carInstance.cars(selectedCar).then(function (car) {
          var id = car[0];
          var model = car[1];
          var modelYear = car[2];
          var canBeTested = car[4];
          var hasBeenVoted = car[5];
          carInstance.depositCar(selectedCar, model, modelYear, canBeTested, hasBeenVoted);
        });
        // depositCar(uint256 _id, string model, uint modelYear, bool canBeTested, bool _hasBeenVoted)

      });
    }

    //check if checkbox is checked
    if (checkBoxBuyCar.checked == true) {
      alert("buycar");

      // Load contract data
      App.contracts.CarContract.deployed().then(function (instance) {
        carInstance = instance;
        carInstance.cars(selectedCar).then(function (car) {
          var id = car[0];
          var carCost = car[3];

          carInstance.buyCar(id, carCost);
        });

        //buyCar(uint256 _id, uint256 _carCost)
      });
    }
  },
  //vote functions
  voteCoupe: function () {
    var carInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.CarContract.deployed().then(function (instance) {
      carInstance = instance;
      //vote coupe logic
      var selectedCar = document.getElementById("carCoupeSelect").value;
      alert(selectedCar);
      var _carCoupeVote = document.getElementById("carcoupe").value;
      alert(_carCoupeVote);
      //carCoupeVote(uint256 _id, uint256 _carCoupeVote)
      carInstance.carCoupeVote(selectedCar, _carCoupeVote);
      console.log(carInstance);
      return carInstance.carsCount();
    }).then(function (carsCount) {
      var carResults = $("#carResults");
      carResults.empty();

      var carCoupeSelect = $('#carCoupeSelect');
      carCoupeSelect.empty();

      for (var i = 1; i <= carsCount; i++) {
        carInstance.cars(i).then(function (car) {
          var id = car[0];
          var name = car[1];
          var voteCount = car[2];

          // Render candidate Result
          var carTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
          carResults.append(carTemplate);

          // Render car option
          var carOption = "<option value='" + id + "' >" + name + "</ option>"
          carCoupeSelect.append(carOption);
        });
      }
    });
  },

  carCatalogue: function(){

    var carInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load contract data
    App.contracts.CarContract.deployed().then(function (instance) {
      carInstance = instance;
      //vote coupe logic
    
    
      //carCoupeVote(uint256 _id, uint256 _carCoupeVote)
      carInstance.carCoupeVote(selectedCar, _carCoupeVote);
      console.log(carInstance);
      return carInstance.carsCount();
    }).then(function (carsCount) {
      var carResults = $("#carResults");
      carResults.empty();

      var carCoupeSelect = $('#carCoupeSelect');
      carCoupeSelect.empty();

      for (var i = 1; i <= carsCount; i++) {
        carInstance.cars(i).then(function (car) {
          var id = car[0];
          var model = car[1];
          var modelYear = car[2];
          alert(voteCount);
          // Render candidate Result
          var carTemplate = "<tr><th>" + id + "</th><td>" + model + "</td><td>" + modelYear  + "</td></tr>";
          carResults.append(carTemplate);

          // Render car option
          var carOption = "<option value='" + id + "' >" + name + "</ option>"
          carCoupeSelect.append(carOption);
        });
      }
    });
  

  },
  voteEngine: function () {
    var carInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.CarContract.deployed().then(function (instance) {
      carInstance = instance;

      //vote engine logic
      var selectedCar = document.getElementById("carEngineSelect").value;
      alert(selectedCar);
      var _carEngineVote = document.getElementById("carEngine").value;
      alert(_carEngineVote);
      //carEngineVote(uint256 _id, uint256 _carEngineVote)
      carInstance.carEngineVote(selectedCar, _carEngineVote);

      console.log(carInstance);
      return carInstance.carsCount();
    }).then(function (carsCount) {
      var carResults = $("#carResults");
      carResults.empty();

      var carEngineSelect = $('#carEngineSelect');
      carEngineSelect.empty();

      for (var i = 1; i <= carsCount; i++) {
        carInstance.cars(i).then(function (car) {
          var id = car[0];
          var name = car[1];
          var voteCount = car[2];

          // Render candidate Result
          var carTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
          carResults.append(carTemplate);

          // Render car option
          var carOption = "<option value='" + id + "' >" + name + "</ option>"
          carEngineSelect.append(carOption);
        });
      }
    });
  },

  votePaint: function () {
    var carInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.CarContract.deployed().then(function (instance) {
      carInstance = instance;

      //vote paint logic
      var selectedCar = document.getElementById("carPaintSelect").value;
      alert(selectedCar);
      var _carPaintVote = document.getElementById("carPaint").value;
      alert(_carPaintVote);
      //carEngineVote(uint256 _id, uint256 _carEngineVote)
      carInstance.getCarPaintVote(selectedCar, _carPaintVote);
      console.log(carInstance);
      return carInstance.carsCount();
    }).then(function (carsCount) {
      var carResults = $("#carResults");
      carResults.empty();

      var carPaintSelect = $('#carPaintSelect');
      carPaintSelect.empty();

      for (var i = 1; i <= carsCount; i++) {
        carInstance.cars(i).then(function (car) {
          var id = car[0];
          var name = car[1];
          var voteCount = car[2];

          // Render candidate Result
          var carTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
          carResults.append(carTemplate);

          // Render car option
          var carOption = "<option value='" + id + "' >" + name + "</ option>"
          carPaintSelect.append(carOption);
        });
      }
      
    });
  },

};

$(function () {
  $(window).load(function () {
    App.init();
  });
});