# Token README

This README file provides detailed information on the DegenToken smart contract, an ERC20 token built using OpenZeppelin's ERC20 implementation. The contract incorporates an in-game store (DegenStore) that allows users to redeem virtual items by spending DegenTokens (DGN). It also includes functionality for minting, burning, and transferring tokens.

## Overview

The **DegenToken** contract introduces an ERC20 token called **Degen (DGN)**, which can be minted, transferred, and burned. Additionally, users can interact with an in-game store (DegenStore) where they can redeem items by burning tokens. The contract includes five predefined items with specific prices and supplies.

### Key Features
- **Minting Tokens**: Users can mint new Degen tokens to their account.
- **Burning Tokens**: Users can burn tokens from their account.
- **Token Transfers**: Users can send tokens to other addresses.
- **In-Game Store**: Users can redeem store items by spending DGN tokens. The token equivalent to the item's price is burned upon purchase.
- **Collection Tracking**: Users' redeemed items are stored in a collection.

## Contract Details

### DegenStore Items

The in-game store offers five items with predefined prices and supply:

1. **Dragon Armor**: 1 available at 1000 DGN.
2. **Phoenix Wings**: 500 available at 800 DGN.
3. **Shadow Cloak**: 250 available at 900 DGN.
4. **Emerald Coin**: 1000 available at 100 DGN.
5. **Diamond Coin**: 1000 available at 100 DGN.

These items are managed through the `DegenStore` array, and their availability decreases as users redeem them.

### Smart Contract Functions

- **`mint(uint amount)`**: Allows the caller to mint the specified number of tokens and add them to their balance.
- **`burn(uint amount)`**: Burns the specified number of tokens from the caller’s balance. The user must have enough tokens to burn.
- **`balance()`**: Returns the current token balance of the caller.
- **`sendToken(address recipient, uint amount)`**: Allows the caller to send tokens to another address.
- **`redeemItem(uint256 id)`**: Allows the caller to redeem an item from the store. The item must be available, and the caller must have enough tokens to pay for it. The item's supply is reduced, and the equivalent token amount is burned from the caller's balance.

## Usage Instructions

### Prerequisites

- Install **MetaMask** or another Web3 wallet to interact with Ethereum-based networks.
- Use **Remix IDE** (https://remix.ethereum.org/) for compiling and deploying the contract.
  
### Deploying the Contract

1. Open **Remix IDE** and create a new file (e.g., `DegenToken.sol`).
2. Paste the following contract code:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is ERC20 {
    
    struct Item {
        uint id;
        string name;
        uint price;
        uint supply;
    }

    Item [100000] public collections;
    Item [100000] public DegenStore;

    constructor() ERC20("Degen", "DGN") {
        DegenStore[0] = Item(1, "Dragon Armor", 1000, 1);
        DegenStore[1] = Item(2, "Phoenix Wings", 800, 500);
        DegenStore[2] = Item(3, "Shadow Cloak", 900, 250);
        DegenStore[3] = Item(4, "Emerald Coin", 100, 1000);
        DegenStore[4] = Item(5, "Diamond Coin", 100, 1000);
    }

    string public degenStoreDescription = "1. Dragon Armor, 2. Phoenix Wings, 3. Shadow Cloak, 4. Emerald Coin, 5. Diamond Coin";

    function mint(uint amount) external {
        _mint(msg.sender, amount);
    }

    function burn(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient DEGEN Tokens");
        _burn(msg.sender, amount);
    }

    function balance() external view returns(uint) {
        return balanceOf(msg.sender);
    }

    function sendToken(address recipient, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens");
        transfer(recipient, amount);
    }

    function redeemItem(uint256 id) public payable {
        require(DegenStore[id - 1].supply > 0, "Item is out of stock");
        require(balanceOf(msg.sender) >= DegenStore[id - 1].price, "Not enough DGN tokens");

        DegenStore[id - 1].supply -= 1;
        _burn(msg.sender, DegenStore[id - 1].price);
        collections[id - 1] = Item(id, DegenStore[id - 1].name, DegenStore[id - 1].price, collections[id - 1].supply + 1);
    }
}
```

3. Navigate to the **Solidity Compiler** tab, select the appropriate version (0.8.26 or compatible), and click **Compile**.
4. After compilation, go to the **Deploy & Run Transactions** tab. Deploy the contract on a test network like **Ropsten** or **Rinkeby**.

### Interacting with the Contract

After deploying the contract, you can interact with it via the Remix interface:

1. **Mint Tokens**: Call the `mint(uint amount)` function with the desired amount.
2. **Check Balance**: Call the `balance()` function to check your token balance.
3. **Burn Tokens**: Call `burn(uint amount)` with the amount of tokens you wish to burn.
4. **Send Tokens**: Use `sendToken(address recipient, uint amount)` to transfer tokens to another user.
5. **Redeem Items**: Call `redeemItem(uint256 id)` to redeem an item by its ID from the store.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Authors

- Himanshu Roy

---

This README provides an updated and concise guide for understanding and deploying the DegenToken contract.
