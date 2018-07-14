pragma solidity 0.4.24;

contract CarContract{
    
    //Model a car
    struct Car{
        uint256 id;
        string model;
        uint256 modelYear;
        uint256 carCost;
        bool canBeTested;
        bool voteCarService;
    }
    //vote structure
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
    //owner balance
    address owner = msg.sender;
    mapping(address => uint256) public balances;
    
    //Read/write cars
    mapping(uint256 => Car) public cars;
    // mapping(uint256 => VoteCar) public vote;
 
    //Read/write votes mapping
    mapping(uint256 => CarInfo) public votecar;
    
    
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
    function depositCarPrice(uint256 _carPrice) private returns (uint256)  {
        uint256 finalPrice = (_carPrice / 10);
        return finalPrice;
    }

    //start
    address minter;

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


    //end
    
    //add new car
    function addNewCar (string carModel, uint256 carYear, uint256 _carCost, bool testOption, bool voteOption) public payable  {
        
        //get user balance
       uint userBalance = queryBalance(msg.sender);
       
       uint256 priceToDeposit = depositCarPrice(_carCost);
  
       require(msg.sender.balance > priceToDeposit);
      
       if(userBalance > priceToDeposit) { return; }
       //if( (_carCost < balances[owner]) && (userBalance < priceToDeposit) )
        //balances[owner] -= _carCost;
        //increase car count
         carsCount++;
        cars[carsCount] = Car(carsCount, carModel, carYear,_carCost, testOption, voteOption);
       
        msg.sender.call.value(priceToDeposit);
        send(owner, priceToDeposit);   
    }
    //client buy a car logic
      //depositCar function
    function depositCar(uint256 _id, string model, uint modelYear, bool canBeTested, bool _hasBeenVoted) public{
        
        uint256 userBalance = queryBalance(owner);
        
        uint256 carPrince = getCarPrice(_id);
        uint256 deposit = depositCarPrice(carPrince);
        
        if( (userBalance < carPrince) && (userBalance < deposit) ) { return; }
        //depositCarNumbers++;
        //clientCar[depositCarNumbers] = ClientCar(_id, model, modelYear, canBeTested, _hasBeenVoted);
        
        //pay
        send(owner, deposit);
    }
    
    function buyCar(uint256 _id, uint256 _carCost) public{
        uint256 userBalance = queryBalance(owner);
        
        uint256 carPrince = getCarPrice(_id);
       if( (userBalance < carPrince)  ) { return; }
        
        send(owner, carPrince);
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

    //start vote contract
   
   
    
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
    function getCarPaintVote(uint256 _id)  public returns (uint256) {
     return votecar[_id].carPaint;
}
    
    //return car coupe vote
    function getCarCoupeVote(uint256 _id)  public returns (uint256) {
     return votecar[_id].carCoupe;
    }
    
    //return car engive vote 
    function getCarEngineVote(uint256 _id) public returns (uint256) {
     return votecar[_id].carEngine;
}
    //end vote contract
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
    function depositCarPrice(uint256 _carPrice)  private returns (uint256)  {
        uint256 finalPrice = (_carPrice / 10);
        return finalPrice;
    }
    
    
    //depositCar function
    function depositCar(uint256 _id, string model, uint modelYear, bool canBeTested, bool _hasBeenVoted) public{
        
        Coin coinShop = new Coin();
        uint256 userBalance = coinShop.queryBalance(owner);
        
        CarContract car = new CarContract();
        uint256 carPrince = car.getCarPrice(_id);
        uint256 deposit = depositCarPrice(carPrince);
        
        if( (userBalance < carPrince) && (userBalance < deposit) ) { return; }
        depositCarNumbers++;
        clientCar[depositCarNumbers] = ClientCar(_id, model, modelYear, canBeTested, _hasBeenVoted);
        
        //pay
        coinShop.send(owner, deposit);
        
    }
    
    function buyCar(uint256 _id, uint256 _carCost) public{
        Coin coinShop = new Coin();
        uint256 userBalance = coinShop.queryBalance(owner);
        
        CarContract car = new CarContract();
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
    function getCarPaintVote(uint256 _id)  public returns (uint256) {
     return votecar[_id].carPaint;
}
    
    //return car coupe vote
    function getCarCoupeVote(uint256 _id)  public returns (uint256) {
     return votecar[_id].carCoupe;
    }
    
    //return car engive vote 
    function getCarEngineVote(uint256 _id) public returns (uint256) {
     return votecar[_id].carEngine;
}

}