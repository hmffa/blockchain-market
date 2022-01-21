pragma solidity ^0.4.20;
pragma experimental ABIEncoderV2;

contract MyContract {

    uint public numberOfOffer;
    uint public orderID;
    address[] public buyersAddresses; // stores the addresses of buyers


    struct offerModel {
        uint ID;
        address sellerWalletAddress;
        string sellerName;
        uint itemCount;
        uint itemRemaining;
        string itemName;
        string itemSpecification;
        uint itemPrice;

    }

    // we map a unique ID for each offer
    mapping (uint => offerModel) public offers;


    function createOffer(string _sellerName , uint _itemCount, string _itemName , string _itemSpecification , uint _itemPrice) external {
        numberOfOffer ++;
        offers[numberOfOffer].ID = numberOfOffer;
        offers[numberOfOffer].sellerWalletAddress = msg.sender;
        offers[numberOfOffer].sellerName = _sellerName;
        offers[numberOfOffer].itemCount = _itemCount;
        offers[numberOfOffer].itemRemaining = _itemCount;
        offers[numberOfOffer].itemName = _itemName;
        offers[numberOfOffer].itemSpecification = _itemSpecification;
        offers[numberOfOffer].itemPrice = _itemPrice;

    }

    // function searchOffers (string _itemName) public view returns(offerModel memory) {
    //     for(uint i=0;i<numberOfOffer;i++)
    //     {
    //         if(keccak256(offers[i].itemName) == keccak256(_itemName)){
    //             return offers[i];
    //         }
    //     }
    // }


    function getAllOffers() external view returns (offerModel[] memory) {
        offerModel[] memory allOffers = new offerModel[](numberOfOffer);
        for (uint256 i=0; i < numberOfOffer; i++) allOffers[i] = offers[i+1];
        return allOffers;
    }

    // function viewOffers () view public returns(uint) {
    //     return offers;
    // }

    
    struct buyerModel {
        uint orderID;
        string deliveryAddress;
        uint orderCount;
        string itemName;
        string itemSpecification;
        uint itemPrice;

    }

    mapping (uint => buyerModel) public orders;

    
    
    function placeOrder (uint _offerID , uint _orderCount, string _buyerAddress) external payable {
        require(offers[_offerID].itemRemaining > 0);        
        require(msg.value == (offers[_offerID].itemPrice * _orderCount));
        orderID++;
        offers[_offerID].itemRemaining = offers[_offerID].itemRemaining - _orderCount;
        orders[orderID].orderID = orderID;
        orders[orderID].deliveryAddress = _buyerAddress;
        orders[orderID].orderCount = _orderCount;
        orders[orderID].itemName = offers[_offerID].itemName;
        orders[orderID].itemSpecification = offers[_offerID].itemSpecification;
        orders[orderID].itemPrice = offers[_offerID].itemPrice;
        if(offers[_offerID].itemRemaining == 0){
            address payable _seller = offers[_offerID].sellerWalletAddress;
            _seller.transfer(offers[_offerID].itemPrice * offers[_offerID].itemCount);
        }
        

    }


}
