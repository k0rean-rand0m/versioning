// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@oz/utils/introspection/ERC165Checker.sol";

contract InterfaceManager {

    using ERC165Checker for address;

    error NotAllInterfacesAreSupported();

}
