// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

error HelperConfig__InvalidNetwork();

contract HelperConfig is Script {
    NetworkConfig public activeNetwork;

    struct NetworkConfig {
        address ROUTER;
        bytes32 DON_ID;
    }

    uint constant ETH_SEPOLIA_ID = 11155111;
    uint constant ARBITRUM_SEPOLIA_ID = 421614;
    uint constant ZKSYNC_SEPOLIA_ID = 300;

    constructor() {
        if (block.chainid == ETH_SEPOLIA_ID) {
            activeNetwork = get_ethereum_Sepolia_config();
        } else if (block.chainid == ARBITRUM_SEPOLIA_ID) {
            activeNetwork = get_Arbitrum_sepolia_config();
        } else if (block.chainid == ZKSYNC_SEPOLIA_ID) {
            activeNetwork = get_zksync_sepolia_config();
        } else {
            revert HelperConfig__InvalidNetwork();
        }
        // else if(block.chainid == ANVIL_LOCALHOST){
        //     activeNetwork = get_Localhost_config();
        // }
    }

    function get_ethereum_Sepolia_config()
        internal
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory sepolia_config = NetworkConfig({
            ROUTER: 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0,
            DON_ID: 0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000
        });
        return sepolia_config;
    }

    function get_Arbitrum_sepolia_config()
        internal
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory arbitrum_config = NetworkConfig({
            ROUTER: 0x234a5fb5Bd614a7AA2FfAB244D603abFA0Ac5C5C,
            DON_ID: 0x66756e2d617262697472756d2d7365706f6c69612d3100000000000000000000
        });
        return arbitrum_config;
    }

    function get_zksync_sepolia_config()
        internal
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory zksync_config = NetworkConfig({
            ROUTER: 0x2053f087Df166772423Aeb8d270d64fD71f303E9,
            DON_ID: 0x66756e2d7a6b73796e632d7365706f6c69612d31000000000000000000000000
        });

        return zksync_config;
    }

    // function get_Localhost_config() internal returns (NetworkConfig memory) {
    //     if(activeNetwork.ROUTER != address(0)) {
    //         return activeNetwork;
    //     }

    //     vm.startBroadcast();

    //     vm.stopBroadcast();

    //     NetworkConfig
    // }
}
