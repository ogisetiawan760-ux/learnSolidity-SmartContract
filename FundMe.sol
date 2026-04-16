// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import{PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256; 

    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFuded;

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd , "didn't send enough ETH");//1e18 = 1 ETH = 10000000000000000000 = 1 * 10 ** 18
        funders.push(msg.sender);
        addressToAmountFuded[msg.sender] += msg.value;
    }

    function withdraw()public {
        for(uint256 funderIndex = 0;funderIndex < funders.length;funderIndex++){
            address funder   = funders[funderIndex];
            addressToAmountFuded[funder]= 0;

        }
        //riset the array
        funders = new address[](0);
        (bool callSucces ,)= payable(msg.sender).call{value : address(this).balance}("");
        require(callSucces,"call failed");
    }

  
}
