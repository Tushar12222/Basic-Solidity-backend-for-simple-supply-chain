
//SPDX-License-Identifier: MIT
pragma solidity>=0.5.0 < 0.9.0; //version control so that code that is deployed before the new patch is still valid
import "./Item.sol";
import "./Ownable.sol";
contract ItemManager is Ownable{ //ItemmManager contract inherits functions from Ownable

 struct S_Item {
 Item _item;
 ItemManager.SupplyChainSteps _step;  //a user defined datatype to hold information about the item 
 string _identifier;
 }
 mapping(uint => S_Item) public items; //mapping to hold information about the items that are created
 uint index;// state variable to help store the items created into the items mapping

 enum SupplyChainSteps {Created, Paid, Delivered} //Enum created to make the code more readable

 event SupplyChainStep(uint _itemIndex, uint _step, address _address);// event created to emit any activity that takes place in the supply chain

 function createItem(string memory _identifier, uint _priceInWei) public onlyOwner{ //a function 
 Item item = new Item(this, _priceInWei, index);// using the instance of Item contract to initialize a new item 
 items[index]._item = item;
 items[index]._step = SupplyChainSteps.Created;// steps to store the values into the items mapping
 items[index]._identifier = _identifier;
 emit SupplyChainStep(index, uint(items[index]._step), address(item));// emitting the activity to all the nodes that an item was created and the required information
 index++;
 }

 function triggerPayment(uint _index) public payable { //customer or end user can pay for the product of their liking by mentioning the specific index and the amount they have to pay for that product
 Item item = items[_index]._item;
 require(address(item) == msg.sender, "Only items are allowed to update themselves");
 require(item.priceInWei() == msg.value, "Not fully paid yet");// condition to make sure the payment is done in full and not in installments
 require(items[index]._step == SupplyChainSteps.Created, "Item is further in the supply chain");// to check if the index of the said item is correct
 items[_index]._step = SupplyChainSteps.Paid;//updating the information that the item has been paid for
 emit SupplyChainStep(_index, uint(items[_index]._step), address(item)); //emitting the event that a paymnent was triggered for the said item , at said index
 }

 function triggerDelivery(uint _index) public onlyOwner{ //after the payment is triggered , the owner of the contract or the manufacturer can trigger the delivery
 require(items[_index]._step == SupplyChainSteps.Paid, "Item has not yet been paid for");//checking if the payment has been successfull
 items[_index]._step = SupplyChainSteps.Delivered;//updating the information that the item has been delivered
 emit SupplyChainStep(_index, uint(items[_index]._step), address(items[_index]._item));//emitting the information to the nodes that the said item has been delivered
 }
}