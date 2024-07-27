import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Script} from "forge-std/Script.sol";
import {PriceFeed} from "../../../src/PriceFeed.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract PriceFeedTest is StdCheats, Test, Script {
    PriceFeed priceFeed;
    HelperConfig helperConfig;
    uint256 optimismFork;
    string OPTIMISM_MAINNET_RPC_URL = vm.envString("OPTIMISM_MAINNET_RPC_URL");

    function setUp() public {
        helperConfig = new HelperConfig();

        optimismFork = vm.createFork(OPTIMISM_MAINNET_RPC_URL);
        vm.selectFork(optimismFork);

        priceFeed = new PriceFeed(
            helperConfig.getOptimismMainnetConfig().priceFeed,
            helperConfig.getOptimismMainnetConfig().priceFeed2
        );
    }

    function testGetPrice() public {
        int answer = priceFeed.INRtoUSD();
        int answer2 = priceFeed.ETHtoUSD();
        assertGt(answer, 0.010 * 1e8);
        assertLt(answer, 0.013 * 1e8);
        assertGt(answer2, 3255.34 * 1e8);
        assertLt(answer2, 3259.34 * 1e8);
    }
}
