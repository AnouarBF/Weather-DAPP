// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Deploy on Sepolia

import {FunctionsClient} from "@chainlink/contracts@1.3.0/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts@1.3.0/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

contract Weather is FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    string public s_lastCity;
    string public s_requestedCity;
    string public s_lastTemperature;

    // State variables to store the last request ID, response, and error
    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;

    // Hardcoded for Sepolia
    // Supported networks https://docs.chain.link/chainlink-functions/supported-networks
    address immutable i_ROUTER;
    bytes32 immutable i_DON_ID;
    string private s_SOURCE;
    //Callback gas limit
    uint32 constant GAS_LIMIT = 300000;
    // Event to log responses
    event Response(
        bytes32 indexed requestId,
        string temperature,
        bytes response,
        bytes err
    );

    error UnexpectedRequestID(bytes32 requestId);

    constructor(
        address router,
        bytes32 don_id,
        string memory source
    ) FunctionsClient(i_ROUTER) {
        i_ROUTER = router;
        i_DON_ID = don_id;
        s_SOURCE = source;
    }

    function getTemperature(
        string memory city,
        uint64 subscriptionId
    ) external returns (bytes32 requestId) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(s_SOURCE); // Initialize the request with JS code
        string[] memory args = new string[](1);
        args[0] = city;
        req.setArgs(args); // Set the arguments for the request
        //////////////////////////////////////////////////////////////////////////////////////////////////////////
        // Send the request and store the request ID
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            GAS_LIMIT,
            i_DON_ID
        );
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // set the city for which we are obtaining the temperature
        s_requestedCity = city;
        return s_lastRequestId;
    }

    // Receive the weather in the city requested
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }

        s_lastError = err;
        s_lastResponse = response;

        s_lastTemperature = string(response);
        s_lastCity = s_requestedCity;

        // Emit an event to log the response
        emit Response(
            requestId,
            s_lastTemperature,
            s_lastResponse,
            s_lastError
        );
    }
}
