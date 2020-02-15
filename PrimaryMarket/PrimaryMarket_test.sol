pragma solidity >=0.4.0 <0.7.0;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./PrimaryMarket.sol";

//Remix tests for PrimaryMarket.sol
contract PrimaryMarketTest {
    
    PrimaryMarket testMarket;
    address player0 = address(0);

    function beforeAll() public {
      testMarket = new PrimaryMarket();
      
      testMarket.addUser(player0, 100);
      
      testMarket.addCandidate("Bernie", 1000);
      testMarket.addCandidate("Buttigieg", 1000);
      
      testMarket.processEvent("Buttigieg", "Iowa", 1);
      testMarket.processEvent("Bernie", "New Hampsire", 1);
    }
    
    function newPlayerHasZeroPoints() public {
      uint points = testMarket.getPoints(player0);
      Assert.equal(points, 0, "error message");
    }
    
    function newPlayerDoesNotOwnBernie() public {
      uint points = testMarket.getBalance(player0, "Bernie");
      Assert.equal(points, 0, "error message");
    }
    
    function adminHasPoints() public {
        address admin = testMarket.getAdmin();
        uint points = testMarket.getPoints(admin);
        Assert.equal(points, 2000, "error");
    }
    
    function adminStartsWithAThousandBernieShares() public {
        address admin = testMarket.getAdmin();
        uint points = testMarket.getBalance(admin, "Bernie");
        Assert.equal(points, 1000, "error message");
    }
    
    function adminIsTheLeader() public {
        address admin = testMarket.getAdmin();
        address leader = testMarket.getLeader();
        Assert.equal(admin, leader, "error message");
    }
}
