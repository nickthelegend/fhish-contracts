// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FhishGateway {
    address public owner;
    address public relayerAddress;

    mapping(uint256 => DecryptRequest) public pendingRequests;
    uint256 public requestCount;

    struct DecryptRequest {
        address requester;
        uint256 ciphertextHandle;
        address callbackContract;
        bytes4 callbackSelector;
        bool fulfilled;
    }

    event DecryptionRequested(uint256 indexed requestId, uint256 ciphertextHandle, address callbackContract);
    event DecryptionFulfilled(uint256 indexed requestId, uint32 plaintext);

    modifier onlyRelayer() {
        require(msg.sender == relayerAddress, "Not relayer");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function requestDecrypt(uint256 ciphertextHandle, address callbackContract, bytes4 callbackSelector) external returns (uint256 requestId) {
        requestCount++;
        requestId = requestCount;
        
        pendingRequests[requestId] = DecryptRequest({
            requester: msg.sender,
            ciphertextHandle: ciphertextHandle,
            callbackContract: callbackContract,
            callbackSelector: callbackSelector,
            fulfilled: false
        });

        emit DecryptionRequested(requestId, ciphertextHandle, callbackContract);
    }

    function fulfillDecrypt(uint256 requestId, uint32 plaintext) external onlyRelayer {
        DecryptRequest storage req = pendingRequests[requestId];
        require(!req.fulfilled, "Already fulfilled");
        req.fulfilled = true;

        (bool success, ) = req.callbackContract.call(
            abi.encodeWithSelector(req.callbackSelector, requestId, plaintext)
        );
        require(success, "Callback failed");

        emit DecryptionFulfilled(requestId, plaintext);
    }

    function setRelayer(address relayer) external onlyOwner {
        relayerAddress = relayer;
    }
}
