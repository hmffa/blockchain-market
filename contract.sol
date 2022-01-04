pragma solidity ^0.6.0;

contract MyContract {


struct offerModel {
    address sellerWalletAddress;
    string sellerName;
    uint itemCount;
    string itemName;
    string itemSpecification;
    uint itemPrice;


}


function createOffer() public payable {}

}