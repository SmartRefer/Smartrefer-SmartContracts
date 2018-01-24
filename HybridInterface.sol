pragma solidity ^0.4.19;
contract HybridInterface
{
    function totalSupply() public view returns (uint256);
    function balanceOf(address tokenOwner) public view returns (uint256 balance);
    function transfer(address to, uint256 tokens) public returns (bool success);

    // =========================================================================
    // ERC20 specific Functions and events
    // =========================================================================
    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
    function approve(address spender, uint256 tokens) public returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    // =========================================================================
    // ERC223 specific Functions and events
    // =========================================================================
    function transfer(address to, uint256 tokens,bytes data) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint256 tokens, bytes data);

}
