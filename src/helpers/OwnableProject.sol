// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


abstract contract OwnableProject {

    mapping(uint256 => address) private _projectOwners;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableProjectUnauthorizedAccount(uint256 projectId, address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error InvalidProjectOwner(uint256 projectId, address owner);

    event ProjectOwnershipTransferred(uint256 indexed projectId, address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyProjectOwner(uint256 projectId) {
        _checkProjectOwner(projectId);
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function projectOwner(uint256 projectId) public view virtual returns (address) {
        return _projectOwners[projectId];
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkProjectOwner(uint256 projectId) internal view virtual {
        if (projectOwner(projectId) != msg.sender) {
            revert OwnableProjectUnauthorizedAccount(projectId, msg.sender);
        }
    }

    /**
     * @dev Forces project owner.
     * Notice: Use with caution.
     */
    function _forceProjectOwner(uint256 projectId, address owner) internal virtual {
        _projectOwners[projectId] = owner;
    }

    /**
     * @dev Leaves the project without owner. It will not be possible to call
     * `onlyProjectOwner` functions. Can only be called by the current projectOwner.
     */
    function renounceProjectOwnership(uint256 projectId) public virtual onlyProjectOwner(projectId) {
        _transferProjectOwnership(projectId, address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferProjectOwnership(uint256 projectId, address newOwner) public virtual onlyProjectOwner(projectId) {
        if (newOwner == address(0)) {
            revert InvalidProjectOwner(projectId, address(0));
        }
        _transferProjectOwnership(projectId, newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferProjectOwnership(uint256 projectId, address newOwner) internal virtual {
        address oldOwner = projectOwner(projectId);
        _projectOwners[projectId] = newOwner;
        emit ProjectOwnershipTransferred(projectId, oldOwner, newOwner);
    }
}
