//SPDX-License-Identifier: MIT
pragma solidity>=0.5.0 < 0.9.0; //version control so that code that is deployed before the new patch is still valid
contract Ownable { //contract to hold the manufacturer address
 address public _owner;

 constructor () { // constructor which is called only once during contract deployment to store the manufacturer's address
 _owner = msg.sender;
 }

 /**
 * @dev Throws if called by any account other than the owner.
 */
 modifier onlyOwner() { //modifier which when inherited by a contract can be used for a function to make the function only accessible to the owner
 require(isOwner(), "Ownable: caller is not the owner");
 _;
 }
 /**
 * @dev Returns true if the caller is the current owner.
 */
 function isOwner() public view returns (bool) { //function to check if the current user address is the user
 return (msg.sender == _owner);
 }
}