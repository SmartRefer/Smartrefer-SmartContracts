pragma solidity ^0.4.19;

// =========================================================================
// Borrowed from https://github.com/Dexaran/ERC223-token-standard
// =========================================================================
contract ERC223ReceivingContract
{
// =========================================================================
// The fallback funcion is called when by ERC223 transfer function to notify
// the receiving contract
// =========================================================================
    function tokenFallback(address _from, uint256 _value, bytes _data);
}
// =========================================================================
// Contract function to receive approval and execute function in one call
// Borrowed from MiniMeToken
// =========================================================================
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
