//spdx-licence-identifier: MIT
pragma solidity ^0.8.0
contract utopian {
    string public constant name="utopia";
    string public constant symbol="UTO";
    uint8 public constant decimals=18;

    event Approval(address indexed tokenowner, address indexed spender, uint tokens);

    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping (address => uint256) balances;
    mapping (address => mapping(address => uint256)) allowed;
    uint256 totalsupply_;
    using safemath for uint256;

    constructor(uint256 total){
        totalsupply_=total;
        balances[msg.sender]=totalsupply_;

    }

    function totalsupply() public view returns(uint256){
        return totalsupply_;
    }

    function balanceof(address tokenowner) public view returns(uint){
        return balances[tokenowner];
    }

    function transfer(address receiver, uint numtokens) public returns (bool){
        require(numtokens<=balances[msg.sender]);
        balances[msg.sender]=balances[msg.sender].sub(numtokens);
        balances[receiver]=balances[receiver].add(numtokens);
        emit Transfer(msg.sender,receiver,numtokens);
        return true;
    }

    function approve(address delegate, uint numtokens) public returns(bool){
        allowed[msg.sender] [delegate] =numtokens;
        emit Approval(msg.sender, delegate, numtokens);
        return true;
    }

    function allowance(address owner,address delegate) public view returns(uint){
        return allowed[owner] [delegate];
    }

    function transferfrom(address owner, address buyer, uint numtokens) public returns (bool){
        require(numtokens<=balances[owner]);
        require(numtokens<=allowed[owner] [msg.sender]);
        balances[owner] = balances[owner].sub(numtokens);
        allowed[owner][msg.sender]=allowed[owner] [msg.sender].sub(numtokens);
        balances[buyer]=balances[buyer].add(numtokens);
        emit Transfer(owner,buyer,numtokens);
        return true;
    }
}

library safemath{
    function sub(uint256 a, uint256 b) internal pure returns(uint256){
        assert(b<=a);
        return a-b;

    }

    function add(uint256 a, uint256 b) internal pure returns(uint256){
        uint256 c=a+b;
        assert(c>=a);
        return c;
    }
}