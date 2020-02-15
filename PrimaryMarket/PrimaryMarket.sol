pragma solidity ^0.5.16;


// Primitive market game for election primaries
contract PrimaryMarket {
    
    event EventProcessed(string candidate, string eventName, uint pointsPerCredit);
    event Buy(address user, string candidate, uint amount);
    event Sell(address user, string candidate, uint amount);
    
    string constant CREDITS = "credits";
    
    address private _admin;
    address[] private _users;
    
    mapping(string => mapping(address => uint)) public _balances;
    mapping(address => uint) public _points;
    
    constructor() public {
        _admin = msg.sender;
        _users.push(_admin);
    }
    
    function addCandidate(string memory candidate, uint amount) public {
        if(msg.sender == _admin)
            _balances[candidate][_admin] = amount;
    }
    
    function addUser(address user, uint amount) public {
        if(msg.sender == _admin) {
            _users.push(user);
            _balances[CREDITS][user] = amount;
        }
    }
    
    function buy(string memory candidate, uint amount) public {
        _balances[CREDITS][msg.sender] += amount;
        _balances[candidate][msg.sender] -= amount;
        emit Buy(msg.sender, candidate, amount);
    }
    
    function sell(string memory candidate, uint amount) public {
        _balances[CREDITS][msg.sender] -= amount;
        _balances[candidate][msg.sender] += amount;
        emit Sell(msg.sender, candidate, amount);
    }
    
    function processEvent(string memory candidate, string memory eventName, uint pointsPerCredit) public {
        if(msg.sender != _admin) return;
        for(uint i=0; i<_users.length; i++) {
            emit EventProcessed(candidate, eventName, pointsPerCredit);
            address currentUser = _users[i];
            //if(currentUser == _admin) return;
            uint userBalance = _balances[candidate][currentUser];
            if(userBalance > 0) 
                _points[currentUser] += userBalance * pointsPerCredit;
        }
    }
    
    function getLeader() public view returns (address l) {
        address leaderSoFar = _admin;
        uint maxPointsSoFar = 0;
        for(uint i=0; i<_users.length; i++) {
            address currentUser = _users[i];    
            if(_points[currentUser] > maxPointsSoFar) {
                maxPointsSoFar = _points[currentUser];
                leaderSoFar = currentUser;
            }
        }
        return leaderSoFar;
    }
    
    //TODO: Close the market
    function closeMarket() public {
        
    }
    
    function getPoints(address user) public view returns (uint x) {
        return _points[user];
    }
    
    function getBalance(address user, string memory candidate) public view returns (uint x) {
        return _balances[candidate][user];
    }
    
    function getAdmin() public view returns (address a) {
        return _admin;
    }
}
