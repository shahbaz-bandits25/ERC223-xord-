pragma solidity ^0.8.4;

//import 'browser/ERC223.sol';
//import 'browser/ERC223Recieving.sol';

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
//
// ----------------------------------------------------------------------------
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    //function transfer(address to, uint tokens ) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

   // event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address  tokenOwner, address  spender, uint tokens);
}

 interface ERC223Interface {
     function transfer(address _to, uint _tokens) external ;
     event Transfer(address  from, address  to, uint value);
 }

// ----------------------------------------------------------------------------
// Safe Math Library
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
}


 contract ERC223ReceivingContract { 
     
      struct tokens
      {
        address sender;
        uint value;
             
     }
     
     
     function tokenFallback(address _from, uint _value) public pure
     {
        //   tokens memory TOK;
        //   TOK.sender = _from;
        //   TOK.value = _value;
         
     }
     
 }
 
 //MAin contract

contract ShahbazToken is ERC20Interface , ERC223Interface ,SafeMath , ERC223ReceivingContract {
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it

    uint256 public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor()   {
        name = "ShahbazToken";
        symbol = "ST";
        decimals = 18;
        _totalSupply = 100000000000000000000000000;

        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply()override external view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

     function balanceOf(address tokenOwner)override external view returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) override external view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) override external returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // function transfer(address to, uint tokens ) override external returns (bool success) {
    //     require( to != address(0));
    //     require(tokens <= balances[msg.sender]);
    //     balances[msg.sender] = safeSub(balances[msg.sender], tokens);
    //     balances[to] = safeAdd(balances[to], tokens);
    //     emit Transfer(msg.sender, to, tokens);
    //     return true;
    // }

    function transferFrom(address from, address to, uint tokens) override external returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
     function  isContract(address _targetContract) private view returns (bool exist)
     {
         uint size;
         assembly 
         {
            size := extcodesize(_targetContract)
          }
        
        return (size > 0);
     }
      
      function transfer(address _to, uint _tokens) override external
      {
          //require(_tokens <=  0 , "Please Send More Tokens");
          require(isContract(_to) , "Contract Does'not Exist");
          ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
          receiver.tokenFallback(msg.sender , _tokens);
          emit Transfer(msg.sender, _to, _tokens);
          //return true;
      }
}

