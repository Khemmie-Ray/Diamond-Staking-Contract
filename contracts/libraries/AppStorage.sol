// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

struct ERC20AppStorage {
    mapping(address => uint256)  _balances;
    mapping(address => mapping(address => uint256))  _allowances;

    uint256  _totalSupply;
    string  _name;
    string  _symbol;
    uint8 _decimal;
}

struct RewardTokenStorage {
    mapping(address => uint256)  _balances;
    mapping(address => mapping(address => uint256))  _allowances;

    uint256  _totalSupply;
    string  _name;
    string  _symbol;
    uint8 _decimal;
}

struct StakingStorage {
    uint256 APY;  

    mapping(address => uint256) stakedBalances;
    mapping(address => uint256) stakingStartTime;
}