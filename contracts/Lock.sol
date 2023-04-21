// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UdemyCompletion is ERC1155, Ownable {

    //! define the name and symbol of the ERC1155 token
    string public name;
    string public symbol;

    //max supply for a type of NFT and how many of those are minted so far
    //The first token Id will have a supply of 10, the second tokenId will have a supply of 20, and the 3rd tokenId will have a supply of 30.
    //The benifit of using an array here is we can push new certificates/nft's over time. we could also use mapping
    uint256[] public supplies;
    uint8[] public minted;

    mapping(uint => string) public tokenURI;

    //Initial Eth cost per NFT
    uint256[] public prices;


    constructor(uint256 _supply, string memory _uri,uint256 _price) ERC1155("") {
        //! set the name and symbol
        name="UdemyCertificationCourse";
        symbol="UCC";
        addNewEdition(_supply,_uri,_price);

    }


    function setURI(uint _id, string memory _uri) external onlyOwner {
        require(_id <= supplies.length, "Token doesn't exist");
        tokenURI[_id] = _uri;
        emit URI(_uri, _id);
    }


    function uri(uint _id) public override view returns (string memory) {
        return tokenURI[_id];
    }

    //Anyone can mint our nft
    function 
    mint(uint256 id)
    public 
    payable 
    {
        require(id<=supplies.length,"id should be the index of the supplies array,i.e which NFT certificate you want");
        require(minted[id]<=supplies[id]+1,"minted certificate should be less than the supply of the given NFT");
        //check if you have appropriate funds to mint the NFT
        require(msg.value >= prices[id], "Not enough ether");
        //what I'm saying here is, whoever calls this funtion can mint 1 NFT
        _mint(msg.sender, id, 1, "");
        minted[id]+=1;

    }
    //! what is "id"?
    /*
    * Id is the Id of the type of certificate
    */

    //new certificate/NFT added
    //price is uint 256, so we have to send it in wei instead of ethrer
function addNewEdition(uint256 supply, string memory _uri, uint256 price) public onlyOwner {
    supplies.push(supply);
    minted.push(0);
    tokenURI[supplies.length-1] = _uri;
    //add the price to the respective array
    prices.push(price);

    emit URI(_uri, supplies.length-1);
}

    function withdraw() external payable onlyOwner {
    
    require(address(this).balance>0,'Balance is 0');
    
    //you can use- transfer, send, or call
    (bool success,)=msg.sender.call{
        value:address(this).balance
    
    }("");
    
    require(success,"Tx. failed");
    
    }

}