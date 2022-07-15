// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// Import OpenZeppelin Contracts for NFT
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "../libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><defs>";

    string[] gradients = ["<linearGradient id='grad' x1='0%' y1='0%' x2='73.135%' y2='68.2%'><stop offset='0%' style='stop-color:#4158D0;stop-opacity:1' /><stop offset='46%' style='stop-color:#C850C0;stop-opacity:1' /><stop offset='100%' style='stop-color:#FFCC70;stop-opacity:1' /></linearGradient>", "<linearGradient id='grad' x1='94%' y1='0%' x2='0%' y2='34.20%'><stop offset='0%' style='stop-color:#0093E9;stop-opacity:1' /><stop offset='100%' style='stop-color:#80D0C7;stop-opacity:1' /></linearGradient>", "<linearGradient id='grad' x1='0%' y1='0%' x2='0%' y2='100%'><stop offset='0%' style='stop-color:#00DBDE;stop-opacity:1' /><stop offset='100%' style='stop-color:#FC00FF;stop-opacity:1' /></linearGradient>", "<linearGradient id='grad' x1='0%' y1='0%' x2='94.55%' y2='32.55%'><stop offset='0%' style='stop-color:#21D4FD;stop-opacity:1' /><stop offset='100%' style='stop-color:#B721FF;stop-opacity:1' /></linearGradient>"];
    
    string midSvg = "</defs><style>.base { position:absolute; top:50%; transform: translateY(-50%); margin:0; color: white; font-weight: bold; font-family: 'Verdana', 'Helvetica', 'Arial', sans-serif; font-size: 24px; text-align: center; }</style><rect width='100%' height='100%' fill='url(#grad)' /><foreignObject x='10%' y='20%' width='80%' height='60%' dominant-baseline='middle'><p class='base' xmlns='http://www.w3.org/1999/xhtml'>";

    string[] firstWords=["Apocalyptic","Equilibrium","Mitigate","Serpentine","Bamboozled","Exquisite","Nefarious","Silhouette","Bizarre","Onomatopoeia","Sinister","Blasphemy","Statuesque"];
    string[] secondWords=["Bumblebee","Hyperbolic","Phosphorous","Stoicism","Capricious","Hypnosis","Picturesque","Synergistic","Clandestine","Incognito","Plebeian","Tectonic","Cognizant"];
    string[] thirdWords=["Indigo","Quadrinomial","Totalitarian","Conundrum","Insidious","Trapezoid","Kaleidoscope","Rambunctious","Sabotage","Villainous","Diabolical","Whimsical","Melancholy","Wizardry"];
    
    constructor() ERC721 ("SquareNFT","SQUARE") {
        console.log("This is my NFT contract. Whoa!");
    }

  function pickRandomGradient(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("GRADIENT", Strings.toString(tokenId))));
    rand = rand % gradients.length;
    return gradients[rand];
  }
  
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    string memory gradient = pickRandomGradient(newItemId);
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first," ", second," ", third));

    string memory finalSvg = string(abi.encodePacked(baseSvg, gradient, midSvg, combinedWord, "</p></foreignObject></svg>"));
    string memory json = Base64.encode(bytes(string(
                abi.encodePacked(
                    '{"name": "',
                    combinedWord,
                    '", "description": "A highly acclaimed collection of Cool triads.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '", "attributes" : [{ "trait_type" : "first" , "value" : "',first,
                    '"},{ "trait_type" : "second" , "value" : "',second,
                    '"},{ "trait_type" : "third" , "value" : "',third,
                    '"}]}'
                )
            )));

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");


    _safeMint(msg.sender, newItemId);
    _setTokenURI(newItemId, finalTokenUri);
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}