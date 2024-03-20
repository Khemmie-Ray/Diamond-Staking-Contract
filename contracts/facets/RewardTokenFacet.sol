// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {RewardTokenStorage} from "../libraries/AppStorage.sol";
import "../interfaces/IERC20.sol";

contract RewardTokenFacet is IERC20 {
    RewardTokenStorage internal r;

    function name() external view returns(string memory) {
        return r._name;
    }

    function symbol() external view returns (string memory) {
        return r._symmbol;
    }

    function decimals() external view returns(uint) {
        return r._decimal;
    }

     function totalSupply() external view override returns(uint256) {
        return r._totalSupply;
    }

     function balanceOf(address account) external view override returns(uint256) {
        return r._balances[account];
    }

    function transfer(address to, uint256 amount) external overrides returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
        emit Transfer(owner, spender, amount);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return r.allowance[owner][spender];
    }

    function approve(address _owner, address spender, uint256 amount) external overrides returns (bool) {
        address _owner =msg.sender;
        _approve(owner, sender, amount);
        return true;    
    }

     function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Zero address invalid");
        require(spender != address(0), "Zero address invalid");

        r._allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burn(address account, uint256 amount) external virtual {
        require(account != address(0), "Zero address invalid");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = r._balances[account];
        require(accountBalance >= amount, "Burn amount exceeds balance");
        unchecked {
            r._balances[account] = accountBalance - amount;
            r._totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

     function _mint(address account, uint256 amount) external {
        require(account != address(0), "Zero address invalid");

        _beforeTokenTransfer(address(0), account, amount);

        r._totalSupply += amount;
        unchecked {
            r._balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    
    function _transfer(address from, ddress to, uint256 amount) external {
        require(from != address(0), "Zero address invalid");
        require(to != address(0), "Zero address invalid");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = s._balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            r._balances[from] = fromBalance - amount;
            r._balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) external {}

    function _afterTokenTransfer(address from, address to, uint256 amount) external virtual {}

      function _spendAllowance(address owner, address spender, uint256 amount) external {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}