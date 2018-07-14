pragma solidity 0.4.24;

contract SellCar{
    
    //Model a car
    struct Car{
        uint256 id;
        string model;
        uint256 modelYear;
        uint256 carCost;
        bool canBeTested;
        bool voteCarService;
    }
    
    //owner balance
    address owner = msg.sender;
    mapping(address => uint256) public balances;
    
    //Read/write cars
    mapping(uint256 => Car) public cars;
    // mapping(uint256 => VoteCar) public vote;
    
     // Store Cars Count
    uint256 public carsCount;
    
    //constructor for car contract
   /* constructor (uint _id, string _model, uint256 _modelYear, uint256 _carCost, bool _canBeTested, bool _voteCarService) public payable{
        
        Car(_id, _model, _modelYear, _carCost, _canBeTested, _voteCarService);
        
    }*/
    //empty constructor
    
    //constructor for car contract
    constructor () public payable{
        
    }
    
    //deposit car advert to be sure the Car add is not fake
    function depositCarAdvert(uint256 _carPrice) payable returns (uint256) {
        uint256 finalPrice = (_carPrice / 10);
        return finalPrice;
    }
    
    //add new car
    function addNewCar (string carModel, uint256 carYear, uint256 _carCost, bool testOption, bool voteOption) public payable  {
        
        //get user balance
       Coin coinShop = new Coin();
       uint userBalance = coinShop.queryBalance(msg.sender);
       
       uint256 priceToDeposit = depositCarAdvert(_carCost);
  
       require(msg.sender.balance > priceToDeposit);
       if(userBalance < priceToDeposit) { return; }
       //if( (_carCost < balances[owner]) && (userBalance < priceToDeposit) )
        //balances[owner] -= _carCost;
        coinShop.send(owner, priceToDeposit);
        //increase car count
        carsCount++;
        cars[carsCount] = Car(carsCount, carModel, carYear,_carCost, testOption, voteOption);
    }
    

    //add voting 
    function addVoting(uint256 _id, bool _voteCarService) returns (bool){
        _voteCarService = cars[_id].voteCarService;
        return _voteCarService;
    }
    
    //can be canBeTested
     function addTestOption(uint256 _id, bool _tesetService) returns (bool){
        _tesetService = cars[_id].canBeTested;
        return _tesetService;
    }
    
    function getCarPrice(uint256 _id) returns(uint256){
        return cars[_id].carCost;
    }
}

contract Coin {
    address minter;
    mapping (address => uint) balances;
    function Coin() {
        minter = msg.sender;
    }
    function mint(address owner, uint amount) {
        if (msg.sender != minter) return;
        balances[owner] += amount;
    }
    function send(address receiver, uint amount) {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
    }
    function queryBalance(address addr) constant returns (uint balance) {
        return balances[addr];
    }
}


contract ClientCarContract{
    
    struct ClientCar{
        uint256 id;
        string Model;
        uint modelYear;
        bool canBeTested ;
        bool hasBeenVoted;
    }
    
    //Read/write cars
    mapping(uint256 => ClientCar) public clientCar;
    
    //owner balance
    address owner = msg.sender;
    mapping(address => uint) public balances;
    
   // Store client deposit Cars
    uint256 public depositCarNumbers;
    
    //deposit car 
     //deposit car advert to be sure the Car add is not fake
    function depositCar(uint256 _carPrice) payable returns (uint256) {
        uint256 finalPrice = (_carPrice / 10);
        return finalPrice;
    }
    
    
    //depositCar function
    function depositCar(uint256 _id, string model, uint modelYear, bool canBeTested, bool _hasBeenVoted) private{
        
        Coin coinShop = new Coin();
        uint256 userBalance = coinShop.queryBalance(owner);
        
        SellCar car = new SellCar();
        uint256 carPrince = car.getCarPrice(_id);
        uint256 deposit = depositCar(carPrince);
        
        if( (userBalance < carPrince) && (userBalance < deposit) ) { return; }
        depositCarNumbers++;
        clientCar[depositCarNumbers] = ClientCar(_id, model, modelYear, canBeTested, _hasBeenVoted);
        
        //pay
        coinShop.send(owner, deposit);
        
    }
    
    function buyCar(uint256 _id, uint256 _carCost){
        Coin coinShop = new Coin();
        uint256 userBalance = coinShop.queryBalance(owner);
        
        SellCar car = new SellCar();
        uint256 carPrince = car.getCarPrice(_id);
       if( (userBalance < carPrince)  ) { return; }
        
        coinShop.send(owner, carPrince);
    }
    
}

contract VoteCar{
    
    struct CarInfo {
        uint256 id;
        string model;
        uint modelYear;
        bool canBeTested ;
        bool hasBeenVoted;
        uint carPaint;
        uint carCoupe;
        uint carEngine;
    }
    
    //Read/write cars
    mapping(uint256 => CarInfo) public votecar;
    
    
    function carPaintVote(uint256 _id, uint256 _carPaintVote) public{
       
       votecar[_id].id  = _id;
        //votecar.id = _id;
        votecar[_id].carPaint = _carPaintVote;
        
    }
    
    function carCoupeVote(uint256 _id, uint256 _carCoupeVote){
        votecar[_id].id = _id;
        votecar[_id].carCoupe = _carCoupeVote;
        
    }
    
    function carEngineVote(uint256 _id, uint256 _carEngineVote){
         votecar[_id].id = _id;
        votecar[_id].carEngine = _carEngineVote;
    }
    
    //return car pint vote
    function getCarPaintVote(uint256 _id) returns (uint256){
        return votecar[_id].carPaint;
    }
    
    //return car coupe vote
     function getCarCoupeVote(uint256 _id) returns (uint256){
        return votecar[_id].carCoupe;
    }
    
    //return car engive vote 
      function getCarEngineVote(uint256 _id) returns (uint256){
        return votecar[_id].carEngine;
    }

}