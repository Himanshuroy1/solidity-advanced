// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is ERC20 {

    // Define a structure to represent an item in the store
    struct Item {
        uint id;
        string name;
        uint price;
        uint supply;
    }

    // Arrays to hold items, each with a maximum capacity of 100,000
    Item[100000] public collections;
    Item[100000] public DegenStore;

    // Constructor that initializes the Degen token and sets up store items
    constructor() ERC20("Degen", "DGN") {
        DegenStore[0] = Item(1, "Dragon Armor", 1000, 1);
        DegenStore[1] = Item(2, "Phoenix Wings", 800, 500);
        DegenStore[2] = Item(3, "Shadow Cloak", 900, 250);
        DegenStore[3] = Item(4, "Emerald Coin", 100, 1000);
        DegenStore[4] = Item(5, "Diamond Coin", 100, 1000);
    }

    // String listing the available items in the DegenStore
    string public degenStoreDescription = "1. Dragon Armor, 2. Phoenix Wings, 3. Shadow Cloak, 4. Emerald Coin, 5. Diamond Coin";

    // Function to mint new tokens to the sender's address
    function mint(uint amount) external {
        _mint(msg.sender, amount);
    }

    // Function to burn (destroy) a certain number of tokens from the sender's balance
    function burn(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient DEGEN Tokens");
        _burn(msg.sender, amount);
    }

    // View function to return the balance of the sender
    function balance() external view returns(uint) {
        return balanceOf(msg.sender);
    }

    // Function to send tokens from the sender to a recipient
    function sendToken(address recipient, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens");
        transfer(recipient, amount);
    }

    // Function to redeem an item from the DegenStore by burning the required amount of tokens
    function redeemItem(uint256 id) public payable {
        require(DegenStore[id - 1].supply > 0, "Item is out of stock");
        require(balanceOf(msg.sender) >= DegenStore[id - 1].price, "Not enough DGN tokens");

        // Decrease the supply of the redeemed item in the store
        DegenStore[id - 1].supply -= 1;

        // Burn the equivalent amount of tokens from the sender's balance
        _burn(msg.sender, DegenStore[id - 1].price);

        // Add the redeemed item to the sender's collection
        collections[id - 1] = Item(id, DegenStore[id - 1].name, DegenStore[id - 1].price, collections[id - 1].supply + 1);
    }
}
