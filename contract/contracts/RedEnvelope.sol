// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface RedEnvelopeInterface {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract RedEnvelope {
    address public owner;
    mapping(address => bool) private verifiedTokens;
    address[] public verifiedTokenList;

    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        string message;
    }

    event TransactionCompleted(
        address indexed sender,
        address indexed receiver,
        uint256 amount,
        string message
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "RedEnvelopeTransfer: caller is not the owner");
        _;
    }

    modifier onlyVerifiedToken(address _token) {
        require(verifiedTokens[_token] == true, "RedEnvelopeTransfer: token is not verified");
        _;
    }

    function addVerifiedToken(address _token) public onlyOwner {
        verifiedTokens[_token] = true;
        verifiedTokenList.push(_token);
    }

    function removeVerifiedToken(address _token) public onlyOwner {
        require(verifiedTokens[_token] == true, "RedEnvelopeTransfer: token is not in the list");
        verifiedTokens[_token] = false;

        // Removing the token from the verifiedTokenList
        for (uint256 i = 0; i < verifiedTokenList.length; i++) {
            if (verifiedTokenList[i] == _token) {
                verifiedTokenList[i] = verifiedTokenList[verifiedTokenList.length - 1];
                verifiedTokenList.pop();
                break;
            }
        }
    }

    function getVerifiedTokens() public view returns (address[] memory) {
        return verifiedTokenList;
    }

    function transfer(RedEnvelopeInterface token, address to, uint256 amount, string memory message) public onlyVerifiedToken(address(token)) returns (bool) {
        uint256 senderBalance = token.balanceOf(msg.sender);
        require(senderBalance >= amount, "RedEnvelopeTransfer: insufficient balance");

        bool success = token.transferFrom(msg.sender, to, amount);
        require(success, "RedEnvelopeTransfer: transfer failed");

        Transaction memory transaction = Transaction({
            sender: msg.sender,
            receiver: to,
            amount: amount,
            message: message
        });

        emit TransactionCompleted(transaction.sender, transaction.receiver, transaction.amount, transaction.message);

        return true;
    }
}