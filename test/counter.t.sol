// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.6.12;

import "forge-std/Test.sol";

import {DSSDemo, Inc} from "../src/counter.sol";

import {ERC20} from "solady/tokens/ERC20.sol";

contract MockCTR is ERC20 {
    constructor() {
        _mint(msg.sender, 100_000 ether);
    }

    function name() public pure override returns (string memory) {
        return "CounterDAO";
    }

    function symbol() public pure override returns (string memory) {
        return "++";
    }

    function push(address dst, uint256 wad) external {
        transfer(dst, wad);
    }
}

contract DSSDemoTest is Test {
    address public dss = 0xcE78254bCD05040953d28FcB640c465f086BEC9b;
    address public me = address(this);

    MockCTR public ctr;
    DSSDemo public demo;

    function setUp() public {
        vm.createSelectFork("mainnet", 22379273);
        ctr = new MockCTR();
        demo = new DSSDemo(dss, address(ctr));
        ctr.push(address(demo), 100_000 ether);
    }

    function test_has_dss() public view {
        assertEq(address(demo.dss()), address(dss));
    }

    function test_val_initialized_to_zero() public view {
        uint256 val = demo.see();
        assertEq(val, 0);
    }

    function test_hit_increases_val_counter() public {
        uint256 val = demo.see();
        assertEq(val, 0);

        demo.hit();

        assertEq(demo.see(), 1);
    }

    function test_hit_gives_ctr() public {
        assertEq(ctr.balanceOf(me), 0);

        demo.hit();

        assertEq(ctr.balanceOf(me), 10 ether);
    }

    function test_dip_decreases_val_counter() public {
        demo.hit();

        uint256 val = demo.see();
        assertEq(val, 1);

        demo.dip();

        assertEq(demo.see(), 0);
    }

    function test_dip_gives_ctr() public {
        assertEq(ctr.balanceOf(me), 0);

        demo.hit();
        demo.dip();

        assertEq(ctr.balanceOf(me), 20 ether);
    }

    function test_inc_gets_counter_info() public {
        demo.hit();
        demo.hit();
        demo.hit();
        demo.dip();

        Inc memory count = demo.inc();
        assertEq(count.net, 2);
        assertEq(count.tab, 3);
        assertEq(count.tax, 1);
        assertEq(count.num, 4);
        assertEq(count.hop, 1);
    }
}
