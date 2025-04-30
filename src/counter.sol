// SPDX-License-Identifier: AGPL-3.0-or-later

// counter.sol -- frob an inc, get CTR

// Copyright (C) 2025 Horsefacts <horsefacts@terminally.online>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.8.29;

import {DSSLike} from "dss/src/dss.sol";

interface SumLike {
    function incs(address) external view returns (uint256, uint256, uint256, uint256, uint256);
}

interface CTRLike {
    function balanceOf(address) external view returns (uint256);
    function push(address, uint256) external;
}

struct Inc {
    uint256 net;
    uint256 tab;
    uint256 tax;
    uint256 num;
    uint256 hop;
}

contract DSSDemo {
    uint256 constant WAD = 1 ether;

    DSSLike public immutable dss; // DSS module
    CTRLike public immutable ctr; // CTR token
    DSSLike public immutable val; // Counter

    constructor(address _dss, address _ctr) {
        dss = DSSLike(_dss);
        ctr = CTRLike(_ctr);

        val = DSSLike(dss.build("val", address(0)));
        val.bless();
        val.use();
    }

    function see() public view returns (uint256) {
        return val.see();
    }

    function hit() external {
        val.hit();
        _give(msg.sender, 10 * WAD);
    }

    function dip() external {
        val.dip();
        _give(msg.sender, 10 * WAD);
    }

    function inc() public view returns (Inc memory) {
        SumLike sum = SumLike(dss.sum());
        (uint256 net, uint256 tab, uint256 tax, uint256 num, uint256 hop) = sum.incs(address(val));
        return Inc(net, tab, tax, num, hop);
    }

    function _give(address dst, uint256 wad) internal {
        if (ctr.balanceOf(address(this)) >= wad) ctr.push(dst, wad);
    }
}
