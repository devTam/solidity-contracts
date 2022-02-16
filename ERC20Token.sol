// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {
    // Total amount of tokens in existence
    function totalSupply() external view returns (uint256);

    // Amount of tokens of a given token address that are currently in existence
    function balanceOf(address _owner) external view returns (uint256 balance);

    // Transfer tokens from one address to another
    function transfer(address _to, uint256 _value)
        external
        returns (bool success);

    // Allowance is the amount of tokens that are allowed to be transferred from one address to another
    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining);

    // Transfer tokens from one address to another and approve the transfer to a third address
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    // Approve the transfer of tokens from one address to another
    function approve(address _spender, uint256 _value)
        external
        returns (bool success);

    // Event emitted when a transfer is made
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // Event emitted when an approval is created
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

contract MyERC20Token is IERC20 {
    // Name symbol and decimal of token
    string public name = "Tam";
    string public symbol = "TAM";
    uint8 public decimals = 18;
    // Total amount of tokens in existence
    uint256 public _totalSupply;
    // creator of the token
    address public owner;
    // Amount of tokens of a given token address that are currently in existence
    mapping(address => uint256) public _balances;
    // Allowance is the amount of tokens that are allowed to be transferred from one address to another, for approval
    mapping(address => mapping(address => uint256)) public _allowances;

    constructor() {
        _totalSupply = 1000000;
        owner = msg.sender;
        _balances[owner] = _totalSupply;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    // Amount of tokens of a given token address that are currently in existence
    function balanceOf(address _owner)
        external
        view
        override
        returns (uint256 balance)
    {
        return _balances[_owner];
    }

    // Transfer tokens from one address to another
    function transfer(address _to, uint256 _value)
        external
        override
        returns (bool success)
    {
        require(_to != address(0));
        require(_value > 0 && _value <= _balances[msg.sender]);
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        external
        override
        returns (bool success)
    {
        require(_spender != address(0));
        require(_value > 0 && _value <= _balances[msg.sender]);
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override returns (bool success) {
        require(_from != address(0));
        require(_to != address(0));
        require(_value > 0 && _value <= _balances[_from]);
        require(_value <= _allowances[_from][_to]);
        _balances[_from] -= _value;
        _balances[_to] += _value;
        _allowances[_from][_to] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        external
        view
        override
        returns (uint256 remaining)
    {
        return _allowances[_owner][_spender];
    }
}
