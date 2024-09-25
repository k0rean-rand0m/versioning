// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Version } from "./Types.sol";

interface IVersioned {

    function version() external view returns (Version memory);
    function registry() external view returns (address);

}
