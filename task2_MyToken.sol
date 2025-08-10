// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 自定义错误
error InvalidReceiver(address receiver);
error InsufficientBalance(address sender, uint256 balance, uint256 needed);
error InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

contract MyToken {
    // 状态变量
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    
    // 余额映射
    mapping(address => uint256) public balanceOf;
    
    // 授权映射
    mapping(address => mapping(address => uint256)) public allowance;
    
    // 事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 构造函数
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        _mint(msg.sender, 1000000 * 10**decimals); // 初始发行100万代币
    }

    // 查询余额
    function checkBalance(address account) public view returns (uint256) {
        return balanceOf[account];
    }

    // 转账函数
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    // 授权转账
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        _spendAllowance(from, msg.sender, value);
        _transfer(from, to, value);
        return true;
    }

    // 授权函数
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    // ============= 内部函数 =============
    
    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal {
        if (to == address(0)) revert InvalidReceiver(to);
        
        uint256 fromBalance = balanceOf[from];
        if (fromBalance < value) revert InsufficientBalance(from, fromBalance, value);
        
        balanceOf[from] = fromBalance - value;
        balanceOf[to] += value;
        
        emit Transfer(from, to, value);
    }

    function _approve(
        address owner,
        address spender,
        uint256 value
    ) internal {
        if (owner == address(0) || spender == address(0)) revert InvalidReceiver(address(0));
        
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 value
    ) internal {
        uint256 currentAllowance = allowance[owner][spender];
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) revert InsufficientAllowance(spender, currentAllowance, value);
            allowance[owner][spender] = currentAllowance - value;
        }
    }

    function _mint(address account, uint256 value) internal {
        if (account == address(0)) revert InvalidReceiver(account);
        
        totalSupply += value;
        balanceOf[account] += value;
        emit Transfer(address(0), account, value);
    }
}