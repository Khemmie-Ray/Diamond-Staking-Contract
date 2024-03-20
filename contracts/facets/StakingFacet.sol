// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import "./IToken.sol";
import "../interfaces/IERC20.sol";
import {StakingStorage} from "../libraries/AppStorage.sol";

contract StakingFacet {
    IERC20 public stakingToken;
    IERC20 public rewardToken; 
    
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0");
        require(IToken(stakingToken).balanceOf(msg.sender) >= amount, "Insufficient funds");
        stakedBalances[msg.sender] += amount;
        stakingStartTime[msg.sender] = block.timestamp;  

        stakingToken.transferFrom(msg.sender, address(this), amount);

        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "Nothing to unstake");

        uint256 reward = calcReward(msg.sender);

        stakedBalances[msg.sender] = 0;
        stakingStartTime[msg.sender] = 0;

        stakingToken.transfer(msg.sender, stakedAmount);

        emit Unstaked(msg.sender, stakedAmount);

        if (reward > 0) {
            emit RewardPaid(msg.sender, reward);
        }
    }

    function calcReward(address user) public view returns (uint256) {
        uint256 stakedAmount = stakedBalances[user];
        if (stakedAmount == 0) return 0;

        uint256 stakingDuration = block.timestamp - stakingStartTime[user];
        uint256 reward = (stakedAmount * APY * stakingDuration) / (365 days * 100);
        return reward;
    }
}