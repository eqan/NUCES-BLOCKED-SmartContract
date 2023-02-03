pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol";
import "hardhat/console.sol";
import "../contracts/SemesterResult.sol";

contract SemesterStoreTest {
    SemesterStore semesterStoreToTest;
    address owner;
    bytes32[] semesterTypes;

    function beforeAll () public {
        owner = msg.sender;
        semesterTypes.push(bytes32("FALL"));
        semesterTypes.push(bytes32("SPRING"));
        semesterTypes.push(bytes32("SUMMER"));
        semesterStoreToTest = new SemesterStore();
    }


    function checkGetAllSemesters() public {
        console.log("Running checkGetAllSemesters");
        semesterStoreToTest.addSemester("FALL", 2022, "https://www.example.com/fall2022");
        semesterStoreToTest.addSemester("SPRING", 2023, "https://www.example.com/spring2023");
        (SemesterStore.Semester[] memory allSemesters) = semesterStoreToTest.getAllSemesters();
        Assert.equal(allSemesters.length, 2, "There should be 2 semesters returned");
        Assert.equal(allSemesters[0].semesterType, "FALL", "Semester type should be correct");
        Assert.equal(allSemesters[0].year, 2022, "Semester year should be correct");
        Assert.equal(allSemesters[0].url, "https://www.example.com/fall2022", "Semester URL should be correct");
        Assert.equal(allSemesters[1].semesterType, "SPRING", "Semester type should be correct");
        Assert.equal(allSemesters[1].year, 2023, "Semester year should be correct");
        Assert.equal(allSemesters[1].url, "https://www.example.com/spring2023", "Semester URL should be correct");
        semesterStoreToTest.removeSemester("FALL_2022");
        semesterStoreToTest.removeSemester("SPRING_2023");
    }
    
    function checkAddSemester() public {
        console.log("Running checkAddSemester");
        semesterStoreToTest.addSemester("FALL", 2022, "https://www.example.com/fall2022");
        Assert.equal(semesterStoreToTest.getSemester("FALL_2022"), "https://www.example.com/fall2022", "Semester should have been added correctly");
    }

    function checkUpdateSemester() public {
        console.log("Running checkUpdateSemester");
        semesterStoreToTest.updateSemester("FALL_2022", "https://www.example.com/fall2022-updated");
        Assert.equal(semesterStoreToTest.getSemester("FALL_2022"), "https://www.example.com/fall2022-updated", "Semester should have been updated correctly");
    }

    function checkRemoveSemester() public {
        console.log("Running checkRemoveSemester");
        semesterStoreToTest.removeSemester("FALL_2022");
        Assert.equal(semesterStoreToTest.getSemester("FALL_2022"), "", "Semester should have been removed correctly");
    }
    

    function checkAddSemesterInvalidSemesterType() public {
        console.log("Running checkAddSemesterInvalidSemesterType");
        bool result = semesterStoreToTest.addSemester("INVALID", 2022, "https://www.example.com/invalid");
        require(result == false, "Adding a semester with an invalid type should fail");
    }
    
    function checkUpdateSemesterInvalid() public {
        console.log("Running checkUpdateSemesterInvalid");
        bool result = semesterStoreToTest.updateSemester("INVALID_2022", "https://www.example.com/invalid");
        require(result == false, "Updating a semester with an invalid type should not have been successful");
    }

    function checkRemoveSemesterInvalid() public {
        console.log("Running checkRemoveSemesterInvalid");
        require(semesterStoreToTest.removeSemester("INVALID_2022") == false, "Removing a non-existing semester should not have been successful");
    }
}
