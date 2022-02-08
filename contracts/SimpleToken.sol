pragma solidity^0.4.25;


contract SimpleToken{
	address owner;
	uint public totalSupply;
    //uint256 = 2**256
    //unsign integer 也就是沒有負數符號的整數
    //key-value
    mapping(address => uint) balances;
    //balances = {address type : uint type}，

    // 以這個例子解釋balances = {address type : uint type}，
    // balance中文意思為餘額，
    // 在這個contract代表的意義就是指address有多少token，
    // 也就是這個address對應的數字為多少

    //代表要在deploy的時候輸入uinttype的參數，代表這個Token的初始供給量

    constructor(uint _initialSupply)public{
        totalSupply = _initialSupply;
        owner = msg.sender;
        balances[owner] = totalSupply
    }
    function balanceOf(address _someone)public view returns(uint){
    	return balances[_someone];
    }
    // balanceOf function 主要功能是查詢指定address 的token餘額，輸入address type 的參數，
    // return balances[_someone] 回傳某個address所對應的數字


    function transfer(address _to,uint _value) public return(bool){
        require(_value > 0,'need more than zero');
        require(balances[msg.sender] >= _value);
        // 判斷執行transfer function的address，擁有的Token必須大於要傳送的value
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        //當所規定的條件都符合時，就會將雙方的所記錄的balances餘額，進行增加token和扣除token的動作
        return true;
    }
}