// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0<0.9.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

/*  KaseiCoinCrowdsale contract
    * OpenZeppelin import inheritance - Crowdsale, MintedCrowdsale
*/

contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale {
    // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE
    // Provide parameters for all of the features of Crowdsale; `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint rate,
        address payable wallet,  // collector of sales
        KaseiCoin token,         // actual 'KaseiCoin' token for crowdsale
        uint goal,               // goal for crowdsale
        uint open,               // open of crowdsale
        uint close               // close of crowdsale

        ) public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
        {}
}

contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        // uint initialSupply
        uint goal
    ) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin token;
        token = new KaseiCoin(name, symbol, 0);
        
        // Assign the token contract???s address to the `kasei_token_address` variable.
        kasei_token_address = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kCrowdSale;
        kCrowdSale = new KaseiCoinCrowdsale(1, wallet, token, goal, now, now + 30 minutes);
            
        // Assign the `KaseiCoinCrowdsale` contract???s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address (kCrowdSale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(kasei_crowdsale_address);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }   
   
}
