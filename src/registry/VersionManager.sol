// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Project, Release, Version } from "../Types.sol";
import { ERC165Checker } from "@oz/utils/introspection/ERC165Checker.sol";

abstract contract VersionManager {

    using ERC165Checker for address;

    error WrongReleaseType();
    error NotAllInterfacesAreSupported();
    error ProjectDoesNotExist(uint256 projectId);
    error MajorVersionDoesNotExist(uint256 projectId, uint256 major);
    error VersionDoesNotExist(uint256 projectId, uint256 major, uint256 minor);

    event ProjectCreated(uint256 indexed projectId, address indexed owner);
    event NewRelease(uint256 indexed projectId, Release release, Version version, address implementation);

    uint256 private _projectsTotal;
    mapping(uint256 id => Project) private _projects;

    mapping(uint256 projectId =>
        mapping(uint256 major =>
            mapping(uint256 minor => address))) private _implementations;

    mapping(uint256 projectId =>
        mapping(uint256 major => uint)) private _minorVersions;

    modifier projectExists(uint256 projectId) {
        if(projectId >= _projectsTotal) revert ProjectDoesNotExist(projectId);
        _;
    }

    // Public functions //

    function project(
        uint256 projectId
    ) projectExists(projectId) internal view virtual returns(Project memory) {
        return _projects[projectId];
    }

    function latest(
        uint256 projectId
    ) public view virtual returns(address) {
        Version memory version = project(projectId).latest; // Performs project existence check.
        return _implementations[projectId][version.major][version.minor];
    }

    function latest(
        uint256 projectId,
        uint256 major
    ) projectExists(projectId) public view virtual returns(address) {
        uint256 minorVersions = _minorVersions[projectId][major];
        if (minorVersions == 0) {
            revert MajorVersionDoesNotExist(projectId, major);
        }
        return _implementations[projectId][major][minorVersions-1];
    }

    // Internal functions //

    function _newRelease(
        uint256 projectId,
        Release release,
        address implementation,
        bytes4[] memory interfaceIds
    ) projectExists(projectId) internal virtual {

        if (release == Release.Initial) {
            revert WrongReleaseType();
        }
        if (!implementation.supportsAllInterfaces(interfaceIds)) {
            revert NotAllInterfacesAreSupported();
        }

        Project memory _project = project(projectId);
        Version memory newVersion;

        if (release == Release.Major) {
            newVersion = Version(_project.latest.major + 1, 0);
        } else {
            newVersion = Version(_project.latest.major, _project.latest.minor + 1);
        }

        _project.latest = newVersion;
        _project.releases += 1;
        _projects[projectId] = _project;

        _setImplementation(projectId, newVersion, implementation);

        emit NewRelease(projectId, release, newVersion, implementation);
    }

    function _newProject(
        address owner,
        Version memory version,
        address implementation,
        bytes4[] memory interfaceIds
    ) internal virtual returns(uint256 projectId) {

        if (!implementation.supportsAllInterfaces(interfaceIds)) {
            revert NotAllInterfacesAreSupported();
        }

        projectId = _projectsTotal;

        _projects[projectId] = Project({
            id: projectId,
            owner: owner,
            releases: 1,
            initial: version,
            latest: version
        });
        _projectsTotal = projectId + 1;
        _setImplementation(projectId, version, implementation);

        emit ProjectCreated(projectId, owner);
        emit NewRelease(projectId, Release.Initial, version, implementation);
    }

    function _checkAndSetInterfaces(
    ) private {
    }

    function _setImplementation(
        uint256 projectId,
        Version memory version,
        address implementation
    ) private  {
        _minorVersions[projectId][version.major] += 1;
        _implementations[projectId][version.major][version.minor] = implementation;
    }

}
