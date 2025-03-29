// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { FFIHelper } from "./FFIHelper.sol";
import { Script, console } from "forge-std/Script.sol";
import { PoolManager } from "v4-core/PoolManager.sol";
import { IPoolManager } from "v4-core/interfaces/IPoolManager.sol";

contract DeployPoolManager is Script, FFIHelper {

  IPoolManager manager;

  function run() public {
    vm.startBroadcast();

    /// @dev deploy manager
    manager = new PoolManager(OWNER);
  }

}
