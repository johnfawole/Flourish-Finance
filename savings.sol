pragma solidity 0.8.19;

 contract MoneyClub {
   // this is the address of the deployer
   address private applicationAdmin;

   struct Users {
    string name;
    string savingGoal;
    address userAddress;
   }

   address[] private userAddressArray;
      // this is the normal duration
   uint constant savingsSpan = 100 days;
   uint private theBeginning = block.timestamp;
   // the fee to pay for urgentWithdrawal, created at state, implemented locally
   uint private penaltyFeePercentage = 10;
   // against reentrancy
   bool private checkmate;
   
   // map to track balances
   mapping(address => Users) private usersMap;
   mapping (address => uint) private balancesMap;
   mapping (address => bool) private registeredUsers;
   mapping (address => uint) private registrationTime;

   constructor () {
    applicationAdmin = payable(msg.sender);
   }

   // modifiers

   modifier onlyOwner () {
    require(msg.sender == applicationAdmin);
    _;
   }

   modifier onlyRegisteredUsers () {
    require(registeredUsers[msg.sender], "only registered users can call this function");
    _;
   }

   modifier checkmateReentrancy () {
    require(!checkmate, "you cannot reenter this function");
    checkmate = true;
      _;
      checkmate = false;
     }

   // people can join the club, and also provide their particulars
   function joinMoneyClub (string memory _name, string memory _savingGoal, address _userAddress) public{
    require(!registeredUsers[msg.sender], "error - this address has registered once and for all");
    require(msg.sender != address(0), "error - zero addresses unallowed");

    usersMap[msg.sender] = Users(_name, _savingGoal, _userAddress);

    registeredUsers[msg.sender] = true;

    registrationTime[msg.sender] = block.timestamp;
   }

   // this is more like a receive fallback function, but we added balancesMap for easier tracking of 
   // those who deposit money
   // of course, only those who have joined can deposit
   function depositMoneyToLock () public payable onlyRegisteredUsers{
      require(msg.value > 0, "you must have more than 0.1 Ether to deposit");

      balancesMap[msg.sender] += msg.value;
   }

   // this is for withdrawal after the saving period ends
   function withdrawDueMoney (address withdrawalDestinationAddress) public payable onlyRegisteredUsers checkmateReentrancy
   {
        require(address(this).balance > 0, "no money to withdraw");
        require(block.timestamp <= registrationTime[msg.sender] + theBeginning + savingsSpan, "the saving period has not started");

      (bool successful, bytes memory data) = withdrawalDestinationAddress.call{value: msg.value}("");
      require(successful, "Couldn't successfully withdraw - error");
   }
   // this is for premature withdrawal
   function urgentWithdrawal (uint amountToWithdraw, address withdrawalDestinationAddress) public payable onlyRegisteredUsers checkmateReentrancy 
   {
      require(block.timestamp <= registrationTime[msg.sender] + theBeginning + savingsSpan, "the saving period has not started");

      uint penaltyFee = (amountToWithdraw * penaltyFeePercentage) / 100;
      uint withdrawableAmount = amountToWithdraw - penaltyFee;

// we cannot make two low-level calls
// hence, we pay the admin with an old transfer call
// and the user with the actual low-level call
      payable(applicationAdmin).transfer(penaltyFee);

      (bool successful, bytes memory urgentWithdrawalStatus) = withdrawalDestinationAddress.call{value: withdrawableAmount}("");
      require(successful, "Couldn't successfully withdraw - error");   
   }

   // for users who want to keep saving and not withdraw
   // they can add the extra span they want to save for
   function extendSavingPeriod (uint spanExtension) public view onlyRegisteredUsers {

      uint extraTime = spanExtension * 30 days;
      extraTime += registrationTime[msg.sender] + theBeginning + savingsSpan; 
   }
   // technically, we push leaving members to the end of the array
   // and remove with ".pop"
   function leaveClub (address _putYourAddress) public onlyRegisteredUsers{

    delete usersMap[_putYourAddress];

   }
   
   // to get the total number of users
   function totalNumberOfUsers () public view onlyOwner returns (uint){
     // the best option is to for loop it out

     return userAddressArray.length;
   }

   // we get to know how much everyone has deposited
   function knowToTalDepositedMoney () public view onlyOwner returns (uint) {
     return address(this).balance;
   }
      // to ascertain personal deposit
   // user will have to provide address
   function knowTotalPersonalDeposit (address forMe) public view onlyRegisteredUsers returns (uint) {
     return balancesMap[forMe];
    }
 }
