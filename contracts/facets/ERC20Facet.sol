// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { LibAppStorage } from "../libraries/LibAppStorage.sol";
import { LibDiamond } from "../libraries/LibDiamond.sol";

contract ERC20Facet {
    LibAppStorage.ERC20AppStorage internal s;
    event Approval(address indexed _owner, address indexed _spender, uint256 _amount);

    function name() public view returns(string memory) {
        return s._name;
    }

    function symbol() public view returns (string memory) {
        return s._symbol;
    }

    function decimals() public view returns(uint) {
        return s._decimal;
    }

    function totalSupply() public view returns(uint256) {
        return s._totalSupply;
    }

    function balanceOf(address _account) public view returns(uint256) {
        return s._balances[_account];
    }

    function transfer(address _to, uint256 _amount) public  returns (bool) {
        LibAppStorage._transferFrom(msg.sender, _to, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return s._allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _amount) external returns (bool) {
        // address owner = msg.sender;
        s._allowances[msg.sender][_spender] = _amount;
        emit Approval (msg.sender, _spender, _amount);
        return true;    
    }

    function mintTo(address _user) external {
        LibDiamond.enforceIsContractOwner();
        uint256 amount = 100_000_000e18;
        s._balances[_user] += amount;
        s._totalSupply += uint96(amount);
        emit LibAppStorage.Transfer(address(0), _user, amount);
    } 

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        uint256 s_allowance = s._allowances[_from][address(this)];
        if (msg.sender == _from || s._allowances[_from][msg.sender] >= _amount) {
            s._allowances[_from][msg.sender] = s_allowance - _amount;
            LibAppStorage._transferFrom(_from, _to, _amount);

            emit Approval(_from, msg.sender, s_allowance - _amount);

            return true;
        } else {
            revert("ERC20: Not enough allowance to transfer");
        }
    }
}