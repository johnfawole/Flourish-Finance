


pragma solidity 0.8.24;
 
 contract spendAndSave {

   struct Users {
    string name;
    address userAddress;
   }

    address private applicationAdmin;
    address private yourDisciplineAddress;
    uint private PercentageToSave = 20;

    mapping (address => uint) private spendingMap;
    mapping(address => Users) private usersMap;
    mapping (address => bool) private registeredUsers;


    bool internal checkmate;

    modifier checkmateReentrancy () {
    require(!checkmate, "you cannot reenter this function");
    checkmate = true;
      _;
      checkmate = false;
     }

    modifier onlyRegisteredUsers () {
    require(registeredUsers[msg.sender], "only registered users can call this function");
    _;
   }

    function joinMoneyClub (string memory _name, address _userAddress) public{
    require(!registeredUsers[msg.sender], "error - this address has registered once and for all");
    require(msg.sender != address(0), "error - zero addresses unallowed");

    usersMap[msg.sender] = Users(_name, _userAddress);

    registeredUsers[msg.sender] = true;
   }

    function setDisciplineWallet (address _disciplineWallet) public view onlyRegisteredUsers{
       _disciplineWallet = yourDisciplineAddress;
    }

    function depositMoney () public payable onlyRegisteredUsers {
      require(msg.value > 0, "you must have more than 0.1 Ether to deposit");

      spendingMap[msg.sender] += msg.value;
    }

 
    function spendToSave (uint amountToWithdraw, address destinationAddress) public payable checkmateReentrancy onlyRegisteredUsers{
        uint remainingMoney;
        uint toBeSaved;

        toBeSaved = amountToWithdraw * PercentageToSave / 100;
        remainingMoney = amountToWithdraw - toBeSaved;

        payable(yourDisciplineAddress).transfer(toBeSaved);
        payable(destinationAddress).transfer(remainingMoney);
    }


 }
