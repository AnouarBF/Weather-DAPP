// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployWeather} from "script/DeployWeather.s.sol";
import {Weather} from "src/Weather.sol";

contract TestWeather is Test {
    Weather weather;
    DeployWeather deployer;

    function setUp() external {
        deployer = new DeployWeather();
        weather = deployer.run();
    }

    function test_ValidChain() external view {
        assert(block.chainid == 11155111);
    }

    function test_revertInvalidSource() external {
        weather = new Weather(
            0xb83E47C2bC239B3bf370bc41e1459A34b41238D0,
            0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000,
            ""
        );

        vm.expectRevert(Weather.Weather__InvalidSource.selector);
        weather.getTemperature("Tangier", 0);
    }
}
