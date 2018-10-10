pragma solidity ^0.4.18;

contract HTLC {
//Global VARS
    string public version;
    // chuỗi hash cua so 1 từ keccak256(), nhớ thêm 0x
    // digest = 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
    bytes32 public digest; 
    address public dest;   // địa chỉ của người nhận
    uint public timeOut;   // thời gian hủy contract và refund tiền về 
    address issuer;        // địa chỉ người đã deploy contract.
    
    event deXemNao(bytes32 digest);       //tạo 1 event xem digest
    event TT(bytes32 _h1, bytes32 _h2);   //in ra 2 giá trị thông qua event để  kiểm tra
//MODIFIERS
    // check dieu kien truoc khi no thuc thi
    modifier onlyIssuer {assert(msg.sender == issuer); _; }


//Operations

/*constructor */
    //constructor được tạo ra thêm payable để khi deploy là truywwnf vào value (tức balance) của
    // contract được
    function HTLC(bytes32 _hash, address _dest, uint _timeLimit) public payable {
        // assert kiểm tra các thông số hợp lệ, sai ném ra lỗi
        // lưu ý, nếu assert fail sẽ làm tốn số  gas còn lại
        assert(digest != 0 || _dest != 0 || _timeLimit != 0);
        digest = _hash;
        dest = _dest;
        timeOut = now + (_timeLimit * 1 seconds);
        issuer = msg.sender; 
    }
 /* public */   
    // Hàm claim: kiểm tra secret key, nếu đúng thì hủy contract và chuyển tiền đến địa chỉ dest
    //selfdestruct tuc la chuyen het balance cua contract den địa chỉ dest
    //no ton it gas hon address.send(this.balance)
    function claim(uint _hash) public returns(bool result) {
        require(digest == keccak256(_hash));
        emit deXemNao(digest);
        emit TT(digest, keccak256(_hash));
        selfdestruct(dest);
        return true;
    }
    // cho phep contract nhan duoc tien
    function () public payable {} 


    //if the time expires; the issuer(người deploy contract) can reclaim funds and destroy the contract
    function refund() onlyIssuer public returns(bool result) {
        require(now >= timeOut);
        //chuyen het balance cua contract den dest
        //no ton it gas hon address.send(this.balance)
        selfdestruct(issuer);
        return true;
    }
    
    // them constant de remix hien ra output
    function getBalance() constant returns (uint balance){
        balance = this.balance;
        return balance;
    }
    
    // thử hàm transfer để chuyển tiền qua lại giữa các tài khoản
    // có thể dùng thay selfdestruct() nhưng tốn gas hơn.
    function fundTransfer(address receiver, uint256 amount) {
        bool ret = receiver.send(amount);
    }    

}

// Tạo 1 contract SHA3Test để tìm đươc chuỗi hash từ secret key cho trước.
contract SHA3Test
{
    function getSHA3Hash(uint input) constant returns (bytes32 hashedOutput)
    {
        hashedOutput = sha3(input);
    }
    
}

// Tóm tắt các lý thuyết liên quan 

// Sự khác nhau giữa assert và require:
// 1, assert ném ra error chặt hơn cho người dùng biết nhưng sẽ tốn phần gas còn lại khi nó 
// fail( tức nó tốn phần gas (gas limit - gas đã dùng)).
// 2, require chỉ đưa ra error nhưng nó ko tốn phần gas còn lại. Dùng bao nhiêu mất bấy nhiêu khi
// fail.