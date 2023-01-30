pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SemesterResultStore is Ownable {
    enum SemesterType {
        FALL,
        SUMMER,
        WINTER
    }

    struct Result {
        SemesterType type;
        uint year;
        string url;
    }

    mapping(bytes32 => Result) results;

    function addResult(uint8 type, uint year, string memory url) public onlyOwner {
        bytes32 key = abi.encodePacked(SemesterType(type), year);
        results[key] = Result(SemesterType(type), year, url);
    }

    function updateResult(uint8 type, uint year, string memory url) public onlyOwner {
        bytes32 key = abi.encodePacked(SemesterType(type), year);
        require(results[key].type == SemesterType(type) && results[key].year == year, "Result does not exist");
        results[key] = Result(SemesterType(type), year, url);
    }

    function removeResult(uint8 type, uint year) public onlyOwner {
        bytes32 key = abi.encodePacked(SemesterType(type), year);
        require(results[key].type == SemesterType(type) && results[key].year == year, "Result does not exist");
        delete results[key];
    }

    function getResult(uint8 type, uint year) public view returns (uint8, uint, string memory) {
        bytes32 key = abi.encodePacked(SemesterType(type), year);
        Result storage result = results[key];
        return (uint8(result.type), result.year, result.url);
    }
}