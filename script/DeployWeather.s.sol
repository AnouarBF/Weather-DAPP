// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Weather} from "../src/Weather.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployWeather is Script {
    string public constant SOURCE =
        "const city = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://wttr.in/${city}?format=3&m`,"
        "responseType: 'text'"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data);";

    address router;
    bytes32 don_id;

    function run() external returns (Weather) {
        HelperConfig helper = new HelperConfig();
        (router, don_id) = helper.activeNetwork();

        vm.startBroadcast(); /********************************** */
        Weather weather = new Weather(router, don_id, SOURCE);
        vm.stopBroadcast(); /*********************************** */

        return weather;
    }
}
