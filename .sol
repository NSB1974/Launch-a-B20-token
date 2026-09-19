// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Minimal interface for the Base B20 Factory precompile
interface IB20Factory {
    enum B20Variant { ASSET, STABLECOIN }

    function createB20(
        B20Variant variant,
        bytes32 salt,
        bytes calldata params,
        bytes[] calldata initCalls
    ) external returns (address token);
}

contract BaseB20Deployer {
    // The exact precompile address for the B20 Factory on Base
    address public constant B20_FACTORY_ADDRESS = 0xB20f000000000000000000000000000000000000;

    event TokenCreated(address indexed tokenAddress);

    /**
     * @notice Deploys a new native B20 Asset token
     * @param tokenName The name of your token
     * @param tokenSymbol The symbol of your token
     * @param adminAndMinter The address that will hold the initial admin & minter role
     * @param salt Unique bytes32 entropy to deterministically derive the token address
     */
    function launchAssetToken(
        string memory tokenName,
        string memory tokenSymbol,
        address adminAndMinter,
        bytes32 salt
    ) external returns (address token) {
        
        // 1. Encode creation parameters: Name, Symbol, Admin Address, Decimals (e.g., 18)
        bytes memory params = abi.encode(tokenName, tokenSymbol, adminAndMinter, uint8(18));

        // 2. Setup initialization roles/limits (Optional setup post-creation)
        // For simplicity, we are leaving initCalls empty. The admin can manage configuration later.
        bytes[] memory initCalls = new bytes[](0);

        // 3. Call the native Base precompile factory
        token = IB20Factory(B20_FACTORY_ADDRESS).createB20(
            IB20Factory.B20Variant.ASSET,
            salt,
            params,
            initCalls
        );

        emit TokenCreated(token);
    }
}

