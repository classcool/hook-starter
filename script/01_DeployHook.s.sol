// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { CSMM } from "../src/CSMM.sol";
import { FFIHelper } from "./FFIHelper.sol";
import { console } from "forge-std/Test.sol";
import { IHooks } from "v4-core/interfaces/IHooks.sol";
import { IPoolManager } from "v4-core/interfaces/IPoolManager.sol";
import { Hooks } from "v4-core/libraries/Hooks.sol";

import { PoolSwapTest } from "v4-core/test/PoolSwapTest.sol";
import { HookMiner } from "v4-periphery/src/utils/HookMiner.sol";

address constant OWNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

/// @notice Deploys Hook contract
contract DeployHookScript is FFIHelper {

  IPoolManager manager;
  IHooks public hook;
  PoolSwapTest router;

  function setUp() public {
    manager = IPoolManager(_getDeployedPoolManager());
    console.log(address(manager));
  }

  function run() public {
    vm.startBroadcast(OWNER);

    /// @dev get hook flags
    uint160 hookFlags =
      uint160(Hooks.BEFORE_SWAP_FLAG | Hooks.BEFORE_ADD_LIQUIDITY_FLAG | Hooks.BEFORE_SWAP_RETURNS_DELTA_FLAG);

    /// @dev compute create2 salt
    (address hookAddress, bytes32 salt) =
      HookMiner.find(CREATE2_FACTORY, hookFlags, type(CSMM).creationCode, abi.encode(address(manager), OWNER));

    /// @dev deploy hook
    hook = new CSMM{ salt: salt }(manager, OWNER);
    assert(address(hook) == hookAddress);

    router = new PoolSwapTest(manager);

    vm.stopBroadcast();
  }

}
