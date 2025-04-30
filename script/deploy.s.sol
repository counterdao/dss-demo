// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.29;

import {Script, console} from "forge-std/Script.sol";
import {DSSDemo} from "../src/counter.sol";

contract Deploy is Script {
    address internal dss = 0xcE78254bCD05040953d28FcB640c465f086BEC9b;
    address internal ctr = 0xA86c903CabAb19f193A6252DD99bdFD747cD40Ee;

    function run() public {
        vm.startBroadcast();

        new DSSDemo(dss, ctr);

        vm.stopBroadcast();
    }
}
