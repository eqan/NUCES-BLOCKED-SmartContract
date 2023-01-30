pragma solidity ^0.8.0;

contract SemesterResultStore {
    enum SemesterType { FALL, SUMMER, WINTER }

    struct Result {
        uint id;
        SemesterType type;
        uint year;
        bytes32 url;
    }

    mapping (uint => Result) private results;
    uint public resultCount;

    function addResult(uint id, SemesterType type, uint year, string memory url) public {
        require(results[id].id == 0, "Result already exists");
        results[id] = Result(id, type, year, bytes32(keccak256(abi.encodePacked(url))));
        resultCount++;
    }

    function getResult(uint id) public view returns (uint, SemesterType, uint, string memory) {
        require(results[id].id != 0, "Result does not exist");
        return (results[id].id, results[id].type, results[id].year, string(abi.decodePacked(results[id].url)));
    }
}
