pragma solidity 0.8.24;

 contract MoneyClub {
   address public applicationAdmin;

   struct Users {
    string name;
    string savingGoal;
    address payable userAddress;
   }

   Users[] private users;

   mapping (uint => Users) private trackUsersMap;
   mapping (address => uint) private balancesMap;

   uint public savingsSpan = 100 days;

   function joinMoneyClub (string memory _name, string memory _savingGoal) public view {
      Users memory user;
      user.name = _name;
      user.savingGoal = _savingGoal;
      user.userAddress = payable(msg.sender);
   }

   // this is more like a receive fallback function, but we added balancesMap for easier tracking of 
   // those who deposit money
   function depositMoney () public payable {
      balancesMap[msg.sender] += msg.value;
   }

   function withdrawDueMoney (uint amountToWithdraw, address withdrawalDestinationAddress) public payable {
      balancesMap[msg.sender] -= amountToWithdraw;
      (bool successful, bytes memory data) = withdrawalDestinationAddress.call{value: msg.value}("");
      require(successful, "Couldn't successfully withdraw - error");
   }

   function emergencyWithdraw () public {

   }

   function knowTotalPersonalDeposit (address forMe) public view returns (uint) {
     return balancesMap[forMe];
    }

   function extendSavingPeriod () public {
    
   }

   function totalNumberOfUsers () public view returns (uint){
     return users.length;
   }

   function knowToTalDepositedMoney () public view returns (uint) {
     return address(this).balance;
   }


 }
