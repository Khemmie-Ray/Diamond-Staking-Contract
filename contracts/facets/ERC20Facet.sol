// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../libraries/ERC20AppStorage.sol";
import "../interfaces/IERC20.sol";

contract ERC20Facet is IERC20 {
    ERC20AppStorage internal s;

    function name() external view returns(string memory) {
        return s._name;
    }

    function symbol() external view returns (string memory) {
        return s._symmbol;
    }

    function decimals() external view returns(uint) {
        return s._decimal;
    }

     function totalSupply() external view override returns(uint256) {
        return s._totalSupply;
    }

     function balanceOf(address account) external view override returns(uint256) {
        return s._balances[account];
    }

    function transfer(address to, uint256 amount) external overrides return (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

     function approve(address spender, uint256 amount) external overrides return (bool) {
        address owner = msg.sender;
        _transfer(owner, spender, amount);
        return true;
    }
}