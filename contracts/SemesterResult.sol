// SPDX-License-Identifier: FAST NUCES
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";



contract SemesterStore is Ownable {
    event SemesterOperation(string operation);
    struct Semester {
        string semesterType;
        uint year;
        string url;
    }

    mapping(string => Semester) semesters;

    function addSemester(string memory semesterType, uint year, string memory url) public onlyOwner {
        require(validateIDFormat(semesterType, year), "Format Invalid");
        string memory id = returnID(semesterType, year);
        require(!validateIDExists(semesterType, year, id), "Id exists!");
        semesters[id] = Semester(semesterType, year, url);
        emit SemesterOperation("Semester Added!");
    }

    function updateSemester(string memory semesterType, uint year, string memory url) public onlyOwner {
        require(validateIDFormat(semesterType, year), "Format Invalid");
        string memory id = returnID(semesterType, year);
        require(validateIDExists(semesterType, year, id), "Id doesnt exist!");
        semesters[id] = Semester(semesterType, year, url);
        emit SemesterOperation("Semester Updated!");
    }

    function getSemester(string memory id) public view returns (string memory) {
        return semesters[id].url;
    }
    
    function removeSemester(string memory id) public onlyOwner {
        delete semesters[id];
        emit SemesterOperation("Semester Removed!");
    }


    function returnID(string memory semesterType, uint yearInt) private pure returns (string memory) {
        string memory yearString = Strings.toString(yearInt);
        return string(abi.encodePacked(semesterType, "_", yearString));
    }

    function validateIDExists(string memory semesterType, uint yearInt, string memory id) private view returns (bool) {
        if(compare(semesters[id].semesterType, semesterType) && semesters[id].year == yearInt)
        {
            return true;
        }
        return false;
    }

    function validateIDFormat(string memory semesterType, uint yearInt) private pure returns (bool) {
        if (yearInt >= 2014 && yearInt <= 2099) {
            if (compare(semesterType, "FALL") || compare(semesterType, "SPRING") || compare(semesterType, "SUMMER")) {
            return true;
            }
        }
        return false;
    }

    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }
}
