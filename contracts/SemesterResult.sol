// SPDX-License-Identifier: MIT
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
    uint256 semesterIndex = 0;

    mapping(string => Semester) semesters;
    mapping(uint => string) semesterIds;

    function addSemesters(Semester[] memory _semesters) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < _semesters.length; i++) {
            addSemester(_semesters[i].semesterType, _semesters[i].year, _semesters[i].url);
        }
        return true;
    }

    function addSemester(string memory semesterType, uint year, string memory url) public onlyOwner returns (bool)  {
        require(validateIDFormat(semesterType, year), "Format Invalid");
        string memory id = returnID(semesterType, year);
        require(!validateIDExists(semesterType, year, id), "Id exists!");
        semesterIds[semesterIndex] = id;
        semesters[id] = Semester(semesterType, year, url);
        semesterIndex++;
        emit SemesterOperation("Semester Added!");
        return true;
    }

    function updateSemester(string memory id, string memory url) public onlyOwner returns (bool)  {
        require(bytes(semesters[id].semesterType).length > 0, "Semester does not exist");
        semesters[id].url = url;
        emit SemesterOperation("Semester Updated!");
        return true;
    }

    function getSemester(string memory id) public view returns (string memory) {
        return semesters[id].url;
    }

    function getSemesterCount() public view returns (uint256) {
        return semesterIndex;
    }

    function removeSemesters(string[] memory ids) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < ids.length; i++) {
            removeSemester(ids[i]);
        }
        return true;
    }
    
    function removeSemester(string memory id) public onlyOwner  returns (bool) {
        require(bytes(semesters[id].semesterType).length > 0, "Semester does not exist");
        delete semesters[id];
        uint256 indexToDelete = findSemesterIndex(id);
        semesterIds[indexToDelete] = semesterIds[semesterIndex-1];
        semesterIndex-=1;
        emit SemesterOperation("Semester Removed!");
        return true;
    }

    function getAllSemestersWithPagination(uint from, uint to) onlyOwner public view returns (Semester[] memory) {
        require(validatePagination(from, to), "Pagination coordinates exceeds limit!");
        Semester[] memory _semesters = new Semester[](to - from + 1);
        uint index = 0;
        for (uint i = from; i <= to; i++) {
            string memory id  = semesterIds[i];
            if(!compare(id, "") && semesters[id].year > 0)
            {
                _semesters[index].semesterType = semesters[id].semesterType;
                _semesters[index].year = semesters[id].year;
                _semesters[index].url = semesters[id].url;
                index++;
            }
        }
        return _semesters;
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

    function validatePagination(uint from, uint to) private view returns(bool){
        if(from >=0  && to <= semesterIndex)
            return true;
        return false;
    }
        
    function findSemesterIndex(string memory id) private view returns (uint256) {
        for (uint256 i = 0; i < semesterIndex; i++) {
            if (compare(semesterIds[i], id)) {
                return i;
            }
        }
        revert("Semester not found in semesterIds");
    }
}