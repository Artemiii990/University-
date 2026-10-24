// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {University} from "../src/University.sol";

contract UniversityScript is Script {
    University public university;

    function run() public {
        vm.startBroadcast();

        university = new University();

        vm.stopBroadcast();
    }
}
