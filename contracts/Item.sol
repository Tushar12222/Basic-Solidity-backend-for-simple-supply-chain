//SPDX-License-Identifier: MIT
pragma solidity>=0.5.0 < 0.9.0; //version control so that code that is deployed before the new patch is still valid
import "./ItemManager.sol";
contract Item { //contract responsible for receiving the payment and then sending the payment back to ItemManager and hence when we create an item , we create a new instance of the contract Item(OOP concept)
 uint public priceInWei; // Wei is the smallest denomination of ether, one ether = 10^8 wei. This state variable holds information about the actual price of an item in wei
 uint public paidWei; //holds the amount of wei paid for that item
 uint public index; //holds the index of an item

 ItemManager parentContract; // contract object to hold information about the ItemManager contract which is used in the following functions

 constructor(ItemManager _parentContract, uint _priceInWei, uint _index) { //constructor to initialize the state variables
 priceInWei = _priceInWei;
 index = _index;
 parentContract = _parentContract;
 }

 receive() external payable { //function to receive payment from the user
 require(msg.value == priceInWei, "We don't support partial payments");// condition to make sure the price paid is in full and not in installments
 require(paidWei == 0, "Item is already paid!");// to make sure the customer does not make a redundant transaction for the same item
 paidWei += msg.value;//updating the payment made to the paidWei to avoid redundant payment for the same item.
 (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));//sending the wei received by the Item contract to the ItemManager contract's function trigger payment by using the address of the parent contract and the function signature of the trigger payment function along with the item index.
 require(success, "Delivery did not work");// if the payment does not happen successfully, the delivery is stopped.
 }

 fallback() external { //to enable deployment on Remix IDE

 }

}
 