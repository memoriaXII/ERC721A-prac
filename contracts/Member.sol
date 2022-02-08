pragma solidity^0.4.25;


contract USER{

    struct User{
        string name;
        string email;
        int gender; // 0= male 1= female
        int age; 
        address addr;
    }
    //宣告User變數為struct type。
    //struct在solidity 裡可以當作是宣告object，其中value的命名，也需要將type放在第一位再來才命名變數名稱
    address[] allUser;
    uint userId; //User[] users 會面臨到一個問題，就是id如何確認，就算用一個參數來記錄id，會是從1開始，而不是從0開始，除非有處理差異值
    mapping (address => uint) userToId;
    mapping (uint => address) idToAddr;
    mapping (address => User) public users;

    // 這邊有兩個mapping type userToId和idToAddr，裡面的key-value是顛倒的，看起來好像能做得事情差不多，
    // 不過目的卻不相同，userToId一個可以判斷address有沒有在記錄過資料，
    // idToAddr可以搭配int 
    // userId目前累積的user總量透過迴圈將所有在contract儲存過資料的address放在address[] allUser顯現出來
    
    
    function create(string _name,string _email,int _gender,int _age) public returns(bool){
        userId++;
        idToAddr[userId] = msg.sender;
        userToId[msg.sender] = userId;
        users[msg.sender] =  User({
            name: _name,
            email: _email,
            gender: _gender,
            age: _age,
            addr: msg.sender
        });
        return true;
        
    }

    function readAll() public returns(address[]){
        delete allUser;
        for(uint i = 1; i <= userId ; i++){
            address userAddr = idToAddr[i];
            allUser.push(userAddr); //memory type的array不支援push，只有storage才可以
        }
        return allUser;
        
    }
    
    function update
    (
        string _name,
        string _email,
        int _gender,
        int _age
    ) 
        public 
        returns(bool)
    {
        require(userToId[msg.sender] != 0 ,"Can not find your Id");
        users[msg.sender] = User({
            name: _name,
            email: _email,
            gender: _gender,
            age: _age,
            addr: msg.sender
        });
        return true;
    }

    function deletes() public returns(bool){
        delete users[msg.sender];
        return true;
    }
    
}