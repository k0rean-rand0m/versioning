// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { Project, Version, Release } from "../Types.sol";
import {IVersioned} from "../IVersioned.sol";

interface IVersionRegistry is IVersioned {

    function newProject(address owner, Version memory version) external returns(uint256 projectId);
    function newRelease(uint256 projectId, Release release) external;

    function project(uint256 projectId) external view returns(Project memory);
    function latest(uint256 projectId) external view returns(address implementation);
    function latest(uint256 projectId, uint256 major) external view returns(address implementation);
    function minorVersions(uint256 projectId, uint256 major) external view returns(uint256 amount);

}
