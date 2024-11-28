// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";



contract TokenFactory {
    event TokenCreated(
        address indexed tokenAddress, 
        address indexed creator, 
        string name, 
        string symbol
    );

    function createToken(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        bool mintable,
        bool burnable
    ) public returns (address) {
        SimpleToken token = new SimpleToken(
            name, 
            symbol, 
            initialSupply, 
            msg.sender,
            mintable,
            burnable
        );
        
        emit TokenCreated(address(token), msg.sender, name, symbol);
        return address(token);
    }
}


contract SimpleToken is ERC20, Ownable, ERC20Permit {
    bool private _isMintable;
    bool private _isBurnable;

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        address creator,
        bool mintable,
        bool burnable
    ) ERC20(name, symbol) Ownable(creator) ERC20Permit(name) {
        _transferOwnership(creator);
        _mint(creator, initialSupply);
        
        _isMintable = mintable;
        _isBurnable = burnable;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(_isMintable, "Minting is not allowed for this token");
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        require(_isBurnable, "Burning is not allowed for this token");
        _burn(msg.sender, amount);
    }
}