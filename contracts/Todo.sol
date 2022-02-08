pragma solidity ^0.4.25;

contract Todo{
    uint256 public taskLength;
    mapping(address=>string[]) public taskLists;
    // 在solidity裡，array只能放同一種type的參數，所以在宣告的時候，
    // 會是string[]、int[]、uint[]、bool[]...；mapping 為映射的意思，
    // 以key-value的形式紀錄資料，筆者習慣把它形容是在solidity的JSON object，
    // 以這個例子解釋，可以看做是這樣的形式
    // taskLists = {address : ["string","string","string"]}


    function create(string _task) public returns(bool){
    	taskLists[msg.sender].push(_task);
    	return true;
    }
    function update(uint _index, string _task) public returns(bool){
        //update 特定貼文
        taskLists[msg.sender][_index] = _task;
        return true;
    }
    function deletes(uint _index) public returns(bool){
        delete taskLists[msg.sender][_index];
        return true;
    }
    function totalAmount() public{
        taskLength = taskLists[msg.sender].length;
    }
    
}