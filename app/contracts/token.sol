pragma solidity ^0.4.11;
contract Token {
  string public name;
  string public symbol;
  string public image;
  uint8 public decimals;
  uint public _supply;

  /* This creates an array with all balances */
  mapping( address => uint ) _balances;
  mapping( address => mapping( address => uint ) ) _approvals;
  
  event Transfer(address indexed from, address indexed to, uint value);/* This generates a public event on the blockchain that will notify clients */
  event Approval( address indexed owner, address indexed spender, uint value);
  event Burn(address indexed from, uint256 value); /* This notifies clients about the amount burnt */
  
  function Token( 
      uint initial_balance,
      string tokenName,
      uint8 decimalUnits,
      string tokenSymbol,
      string tokenImage
     ) {
    _balances[msg.sender] = initial_balance; // Give the creator all initial tokens
    _supply = initial_balance;               // Update total supply
    name = tokenName;                        // Set the name for display purposes
    symbol = tokenSymbol;                    // Set the symbol for display purposes
    decimals = decimalUnits;                 // Amount of decimals for display purposes
    image = tokenImage;                      // Set Image
    
  }
  function totalSupply() constant returns (uint supply) {
    return _supply;
  }
  function balanceOf( address who ) constant returns (uint value) {
    return _balances[who];
  }
  // function image() constant returns (string image) {
  //   return image;
  // }
  /* Send coins */
  function transfer( address to, uint value) returns (bool ok) {
    if( _balances[msg.sender] < value ) {
      throw;
    }
    if( !safeToAdd(_balances[to], value) ) {
      throw;
    }
    if (to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
    if (_balances[msg.sender] < value) throw;           // Check if the sender has enough
    if (_balances[to] + value < _balances[to]) throw; // Check for overflows
    _balances[msg.sender] -= value;   // Subtract from the sender
    _balances[to] += value;           // Add the same to the recipient
    Transfer( msg.sender, to, value );// Notify anyone listening that this transfer took place
    return true;
  }
  /* A contract attempts to get the coins */
  function transferFrom( address from, address to, uint value) returns (bool ok) {
    if(to == 0x0) throw;                              // Prevent transfer to 0x0 address. Use burn() instead
    if(_balances[to] + value < _balances[to]) throw;  // Check for overflows
    if(value > _approvals[from][msg.sender]) throw;    // Check _approvals
    if( _balances[from] < value ) throw;              // if you don't have enough balance, throw
    if( _approvals[from][msg.sender] < value ) throw; // if you don't have approval, throw
    if( !safeToAdd(_balances[to], value) ) throw;
    _approvals[from][msg.sender] -= value;            // transfer and return true
    _balances[from] -= value;
    _balances[to] += value;
    Transfer( from, to, value );
    return true;
  }
  
  /* Allow another contract to spend some tokens in your behalf */
  function approve(address spender, uint value) returns (bool ok) {
    // TODO: should increase instead
    _approvals[msg.sender][spender] = value;
    Approval( msg.sender, spender, value );
    return true;
  }
  
  function allowance(address owner, address spender) constant returns (uint _allowance) {
    return _approvals[owner][spender];
  }
  
  function safeToAdd(uint a, uint b) internal returns (bool) {
    return (a + b >= a);
  }
  
  function burn(uint256 value) returns (bool success) {
    if (_balances[msg.sender] < value) throw;            // Check if the sender has enough
    _balances[msg.sender] -= value;                      // Subtract from the sender
    _supply -= value;                                // Updates _supply
    Burn(msg.sender, value);
    return true;
  }

  function burnFrom(address from, uint256 value) returns (bool success) {
    if (_balances[from] < value) throw;                // Check if the sender has enough
    if (value > _approvals[from][msg.sender]) throw;    // Check _approvals
    _balances[from] -= value;                          // Subtract from the sender
    _supply -= value;                               // Updates _supply
    Burn(from, value);
    return true;
  }
}