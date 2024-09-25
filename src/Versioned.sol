// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Version, Release } from  "./Types.sol";
import { IVersioned } from "./IVersioned.sol";
import { IVersionRegistry } from "./registry/IVersionRegistry.sol";

abstract contract Versioned is IVersioned {

    Version private _version;

    constructor(
        address registry,
        uint256 projectId,
        Release release
    ) {
        IVersionRegistry(registry).newRelease(projectId, release);
    }

    function version() public view returns (Version memory) {
        return _version;
    }

}
