// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Version {
    uint256 major;
    uint256 minor;
}

struct Project {
    uint256 id;
    address owner;
    uint256 releases;
    Version initial;
    Version latest;
}

enum Release {
    Initial,
    Major,
    Minor
}
