// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC165Checker } from "@oz/utils/introspection/ERC165Checker.sol";
import { IVersionRegistry } from "./IVersionRegistry.sol";
import { Project, Version, Release } from "../Types.sol";
import { OwnableProject } from "../helpers/OwnableProject.sol";
import { VersionManager } from "./VersionManager.sol";
import {ERC165} from "@oz/utils/introspection/ERC165.sol";

contract VersionRegistry is ERC165, VersionManager, OwnableProject {

    using ERC165Checker for address;

    address immutable public registry;
    Version public version;

    constructor(Version memory _version) {
        registry = address(this);
        version = _version;
    }

    function newProject(
        address owner,
        Version memory initialVersion,
        address implementation,
        bytes4[] memory interfaceIds
    ) public returns(uint256 projectId) {
        projectId = _newProject(owner, initialVersion, implementation, interfaceIds);
        _forceProjectOwner(projectId, owner);
    }

    function newMajorRelease(
        uint256 projectId,
        address implementation,
        bytes4[] memory interfaceIds
    ) public onlyProjectOwner(projectId) {
        _newRelease(projectId, Release.Major, implementation, interfaceIds);
    }

    function newMinorRelease(
        uint256 projectId,
        address implementation,
        bytes4[] memory addedInterfaceIds
    ) public onlyProjectOwner(projectId) {
        _newRelease(projectId, Release.Minor, implementation, addedInterfaceIds);
    }

    // ERC-165 //

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IVersionRegistry).interfaceId || super.supportsInterface(interfaceId);
    }

}
