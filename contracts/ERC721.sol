pragma solidity ^0.4.25;

contract ERC721_interface {
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) public view returns (uint256);

    function ownerOf(addrss _tokenId) public view returns (address);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes data
    ) public;

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public;

    function approve(address _to, uint256 _tokenId) public;

    function setApprovalForAll(address _operator, bool _approved) public;

    function getApproved(uint256 _tokenId) public view returns (address);

    function isApprovedForALL(address _owner, address _operator) public view reutrns(bool);

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes _data
    ) public returns (bytes4);
}

contract ERC721 is ERC721_interface {
    mapping(uint256 => address) public tokenOwner;
    mapping(uint256 => address) public tokenApproval;
    mapping(address => uint256) public ownerTokenCount;
    mapping(address => mapping(address => bool)) public operatorApproval;
    mapping(uint256 => bool) public tokenExists;

    function balanceOf(address _owner) public view returns (uint256 tokenCount) {
        require(owner != address(0), '無效的address');
        return ownerTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address owner) {
        return tokenOwner[_tokenId];
    }

    function addToken(uint256 _tokenId) public {
        require(tokenOwner[_tokenId] == address(0));
        tokenOwner[_tokenId] = msg.sender;
        ownerTokenCount[msg.sender]++;
    }

    //執行轉移token所有權
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public {
        address owner = tokenOwner[_tokenId];
        require(operatorApproval[owner][msg.sender], '你沒有被賦予代替操作的權利');
        require(owner == _from, '持有者身分不符合');
        require(_to != address(0), '無效的address');
        require(tokenExists[_tokenId], '沒有這個token');

        tokenApproval[_tokenId] = address(0);
        tokenOwner[_tokenId] = _to;
        ownerTokenCount[_from]--;
        ownerTokenCount[_to]++;
        emit Transfer(_from, _to, _tokenId);
    }

    //確定轉移token所有權給指定的address
    function approve(address _to, uint256 _tokenId) public {
        address owner = tokenOwner[_tokenId];
        require(_to != address(0), '無效的address');
        require(msg.sender == owner || operatorApproval[owner][msg.sender], '你不是持有者也沒有代替操作的權利');

        tokenApproval[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    //決定是否給予operator行為操作權
    function setApprovalForAll(address _operator, bool _approved) public {
        require(_operator != address(0), '無效的address');

        operatorApproval[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    //確定tokenID的持有者是誰
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(tokenExists[_tokenId], '沒有這個token');
        return tokenApproval[_tokenId];
    }

    //確定operator可以代表owner的行為
    function isApprovedForALL(address _owner, address _operator) public view reutrns(bool) {
        return operatorApproval[_owner][_operator];
    }
}
