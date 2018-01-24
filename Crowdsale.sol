// =========================================================================
// Author : Damoon Azarpazhooh
// https://github.com/damoonazarpazhooh
// Client : Smartrefer.io
// ========================================================================

pragma solidity ^0.4.19;
import "./SafeMath.sol";
import "./HybridInterface.sol";
import "./Receiver.sol";
import "./HybridToken.sol";

contract Crowdsale
{
    using SafeMath for uint256;

    // =========================================================================
    // state variables : Token
    // =========================================================================
    HybridToken public token;
    string public symbol = "REF";
    string public  name = "REFER";
    uint8 public decimals = 18;

    // =========================================================================
    // state variables : Constant
    // total number of tokens in circulation 118,000,000;
    // Base rate of tokens/eth 1600
    // =========================================================================
    uint256 public constant tokens_presale = 255200;
    uint256 public constant tokens_sale = 52844800;
    uint256 public constant smartpool_reserve = 29500000;
    uint256 public constant operations_reserve = 17700000;
    uint256 public constant founders_reserve = 17700000;

    bool public smartpool_reserve_released = false;
    bool public founders_reserve_released = false;
    bool public operations_reserve_released = false;

    uint256 public  tokens_presale_cap = tokens_presale.mul(10**uint256(decimals));
    //Discount rate of 45%
    uint256 public constant presaleTierOneRate  = 2320;
    //Discount rate of 35%
    uint256 public constant presaleTierTwoRate = 2160;
    //Discount rate of 30%
    uint256 public constant presaleTierThreeRate  = 2080;
    //Discount rate of 30%
    uint256 public constant presaleTierFourRate  = 2080;

    uint256 public  tokens_sale_cap = tokens_sale.mul(10**uint256(decimals));
    //Discount rate of 25%
    uint256 public constant saleTierOneRate  =1920;

    //Discount rate of 15%
    uint256 public constant saleTierTwoRate  =1840;

    //Discount rate of 10%
    uint256 public constant saleTierThreeRate  = 1760;
    //Base Rate
    uint256 public constant saleTierFourRate = 1600;

    uint256 public constant preSaleStartTime = 1516856460;
    // =========================================================================
    // state variables : Crowdsale
    // =========================================================================
    address public creator;
    mapping(address => bool) public whitelisted;

    //total number of waised raised
    uint256 public weiRaised ;
    // total number of issued tokens suring presale
    uint256 public pre_sale_issued_tokens ;
    uint256 public sale_issued_tokens;


    // =========================================================================
    // state variables : Crowdsale
    // =========================================================================
    // address public sale_wallet   ;

    address public smartpool ;

    address public operations ;

    address public foundersWallet ;

    //start time of sale
    uint256 public saleStartTime ;


    // =========================================================================
    // Constructor
    // =========================================================================
    function Crowdsale() public
    {
        token = new HybridToken(symbol,name,decimals);
        creator = msg.sender;
    }
    // =========================================================================
    // Fallback
    // =========================================================================
    function() public payable
    {
        address contractor = 0xcefc050eb6629f538d3890db7015bc07d651dbd5 ;
          //start time of tier 2 == end time of tier 1
        uint256  preSaleTierOneEnd = preSaleStartTime + 1 weeks  ;
        //start time of tier 3 == end time of tier 2
        uint256  preSaleTierTwoEnd = preSaleTierOneEnd + 2 weeks  ;
        //start time of tier 4 == end time of tier 3
        uint256  preSaleTierThreeEnd = preSaleTierTwoEnd + 2 weeks  ;
        // end time of tier 4
        uint256  preSaleTierFourEnd = preSaleTierThreeEnd + 2 weeks  ;
        uint256 receivedWei = uint256(msg.value);
        weiRaised = weiRaised.add(receivedWei);
        if (now<preSaleStartTime)
        {
            revert();
        }
        if (now>=preSaleStartTime && now <=preSaleTierFourEnd)
        {

            // Check whitelisted
            if(whitelisted[msg.sender] == false)
            {
                revert();
            }
            else
            {
                contractor.transfer(receivedWei.div(10));
                presale(receivedWei,preSaleTierOneEnd,preSaleTierTwoEnd,preSaleTierThreeEnd,preSaleTierFourEnd);
            }

        }
        if (now>preSaleTierFourEnd && saleStartTime == 0 )
        {
            revert();
        }
        if(saleStartTime!=0)
        {
            //start time of tier 2 == end time of tier 1
            uint256  saleTierOneEnd = saleStartTime + 1 weeks  ;
            //start time of tier 3 == end time of tier 2
            uint256  saleTierTwoEnd =saleTierOneEnd + 1 weeks  ;
            //start time of tier 4 == end time of tier 3
            uint256  saleTierThreeEnd = saleTierTwoEnd + 1 weeks  ;
            // end time of tier 4
            uint256  saleTierFourEnd =saleTierThreeEnd + 1 weeks  ;
            if ( now>saleTierFourEnd )
            {
                revert();
            }
            if (now >=saleStartTime && now<=saleTierFourEnd )
            {
                contractor.transfer(receivedWei.div(10));
                sale(receivedWei,saleTierOneEnd,saleTierTwoEnd,saleTierThreeEnd,saleTierFourEnd);
            }
        }


    }

    function presale(uint256 receivedWei,uint256 preSaleTierOneEnd,uint256 preSaleTierTwoEnd,uint256 preSaleTierThreeEnd, uint256 preSaleTierFourEnd ) internal{
            uint256 tokens;

            //tier 1
            if (now >=preSaleStartTime && now<preSaleTierOneEnd)
            {
                tokens = (receivedWei).mul(presaleTierOneRate);
                //checking to make sure it doesn't go over the cap
                if(pre_sale_issued_tokens.add(tokens) > tokens_presale_cap)
                {
                    revert();
                }
                token.mint(msg.sender,tokens);
                pre_sale_issued_tokens = pre_sale_issued_tokens.add(tokens);


            }
            // tier 2
            else if (now >=preSaleTierOneEnd && now<preSaleTierTwoEnd)
            {
                tokens = (receivedWei).mul(presaleTierTwoRate);
                if(pre_sale_issued_tokens.add(tokens) > tokens_presale_cap)
                {
                    revert();
                }
                token.mint(msg.sender,tokens);
                pre_sale_issued_tokens = pre_sale_issued_tokens.add(tokens);
            }
            // tier 3
            else if (now >=preSaleTierTwoEnd && now<preSaleTierThreeEnd)
            {
                tokens = (receivedWei).mul(presaleTierThreeRate);
                if(pre_sale_issued_tokens.add(tokens) > tokens_presale_cap)
                {
                    revert();
                }
                token.mint(msg.sender,tokens);
                pre_sale_issued_tokens = pre_sale_issued_tokens.add(tokens);
            }
            // tier 4
            else if (now >=preSaleTierThreeEnd && now<preSaleTierFourEnd)
            {
                tokens = (receivedWei).mul(presaleTierFourRate);
                if(pre_sale_issued_tokens.add(tokens) > tokens_presale_cap)
                {
                    revert();
                }
                token.mint(msg.sender,tokens);
                pre_sale_issued_tokens = pre_sale_issued_tokens.add(tokens);
            }

    }
    function sale (uint256 receivedWei,uint256 saleTierOneEnd,uint256 saleTierTwoEnd,uint256 saleTierThreeEnd,uint256 saleTierFourEnd)internal{
            uint256 tokens;

                //tier 1
                if (now >=saleStartTime && now<saleTierOneEnd)
                {
                    tokens = (receivedWei).mul(saleTierOneRate);
                    if(sale_issued_tokens.add(tokens) > tokens_sale_cap)
                    {
                        revert();
                    }
                    token.mint(msg.sender,tokens);
                    sale_issued_tokens = sale_issued_tokens.add(tokens);

                }
                //tier 2
                else if (now >=saleTierOneEnd && now<saleTierTwoEnd)
                {
                    tokens = (receivedWei).mul(saleTierTwoRate);
                    if(sale_issued_tokens.add(tokens) > tokens_sale_cap)
                    {
                        revert();
                    }
                    token.mint(msg.sender,tokens);
                    sale_issued_tokens = sale_issued_tokens.add(tokens);
                }
                //tier 3
                else if (now >=saleTierTwoEnd && now<saleTierThreeEnd)
                {
                    tokens = (receivedWei).mul(saleTierThreeRate);
                    if(sale_issued_tokens.add(tokens) > tokens_sale_cap)
                    {
                        revert();
                    }
                    token.mint(msg.sender,tokens);
                    sale_issued_tokens = sale_issued_tokens.add(tokens);

                }
                // tier 4
                else if (now >=saleTierThreeEnd && now<saleTierFourEnd)
                {
                    tokens = (receivedWei).mul(saleTierFourRate);
                    if(sale_issued_tokens.add(tokens) > tokens_sale_cap)
                    {
                        revert();
                    }
                    token.mint(msg.sender,tokens);
                    sale_issued_tokens = sale_issued_tokens.add(tokens);
                }



        }
    function whitelist(address sender) public onlyCreator returns (bool)
    {

            whitelisted[sender] = true;
            return true;
    }

    function blacklist(address sender) public onlyCreator returns (bool)
    {

            whitelisted[sender] = false;
            return true;
    }

    function startSale(uint256 start) public onlyCreator returns (bool)
    {

            saleStartTime = start;
            return true;
    }
    function withdraw(address reciever)public onlyCreator returns (bool)
    {
        require(this.balance>0);

        reciever.transfer(this.balance);
    }

    function  set_smartpool(address addr) public onlyCreator returns (bool)
    {
        if (smartpool_reserve_released == false)
        {
            smartpool = addr;
            smartpool_reserve_released = true;
            token.mint(addr,smartpool_reserve);
        }
        else
        {
            revert();
        }
    }

    function set_operations(address addr) public onlyCreator returns (bool)
    {

        if (operations_reserve_released == false)
        {
            operations = addr;
            operations_reserve_released = true;
            token.mint(addr,operations_reserve);
        }
        else
        {
            revert();
        }

    }

    function set_foundersWallet (address addr) public onlyCreator returns (bool)
    {

        if (founders_reserve_released == false)
        {
            foundersWallet = addr;
            founders_reserve_released = true;
            token.mint(addr,founders_reserve);
        }
        else
        {
            revert();
        }


    }
    modifier onlyCreator()
    {
        if (msg.sender !=creator)
        {
            revert();
        }
        else
        {
            _ ;
        }
    }

}
