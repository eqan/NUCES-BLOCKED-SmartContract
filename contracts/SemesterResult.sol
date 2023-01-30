
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SemesterResultStore is Ownable {
    enum SemesterType {
        FALL,
        SUMMER,
        WINTER
    }

    struct Result {
        uint id;
        SemesterType type;
        uint year;
        string url;
    }

    mapping(uint => Result) results;

    function addResult(uint id, uint8 type, uint year, string memory url) public onlyOwner {
        results[id] = Result(id, SemesterType(type), year, url);
    }

    function updateResult(uint id, uint8 type, uint year, string memory url) public onlyOwner {
        require(results[id].id == id, "Result does not exist");
        results[id] = Result(id, SemesterType(type), year, url);
    }

    function getResult(uint id) public view returns (uint, uint8, uint, string memory) {
        Result storage result = results[id];
        return (result.id, uint8(result.type), result.year, result.url);
    }
}