// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract FundMe {
    
    address public owner;
    uint256 public minimumFund = 50; // "usd"
    mapping(address => uint256) public addressToAmountFunded;
    address[] public allFunders;
    
    constructor() {
        owner = msg.sender;
    }
    
    /*
     * Network: Rinkeby
     * Aggregator: ETH/USD
     * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    */
    
    modifier onlyOwner {
        require(msg.sender == owner, 'function accessible by contract owner only');
        _;
    }
    
    function fund()
        public 
        payable
    {
        uint256 minUSD = minimumFund * 10 ** 18;
        require(getConversionRate(msg.value) >= minUSD, "You need to spend more ETH!");
        // keep track of every address' fund amount
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
        allFunders.push(msg.sender);
    }
    
    
    function getBalance()
        public
        view
        returns(uint256)
    {
        return address(this).balance;
    }
    
    
    function withdraw()
        public 
        onlyOwner 
    {
        payable(msg.sender).transfer(address(this).balance);
        // reset all funded amounts
        for (uint256 i = 0; i < allFunders.length; i++)
        {
            addressToAmountFunded[(allFunders[i])] = 0;
        }
    }
    
    
    function getLatestPrice()
        public
        view
        returns(uint256)
    {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e); // address for the Rinkeby Network
        (,int price,,,) = priceFeed.latestRoundData();
        
        return uint256(price * 10000000000);
    }
    
    
    function getConversionRate(uint256 _ethAmount) 
        public
        view
        returns(uint256)
    {
        uint256 ethPrice = getLatestPrice();
        uint256 ethAmountInUsd = (ethPrice * _ethAmount) / 10 ** 18;
        return ethAmountInUsd;
    }
    
}