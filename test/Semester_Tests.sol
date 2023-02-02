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

    function checkAddSemester() public {
        console.log("Running checkAddSemester");
        semesterStoreToTest.addSemester("FALL", 2022, "https://www.example.com/fall2022");
        Assert.equal(semesterStoreToTest.getSemester("FALL_2022"), "https://www.example.com/fall2022", "Semester should have been added correctly");
    }

    function checkUpdateSemester() public {
        console.log("Running checkUpdateSemester");
        semesterStoreToTest.updateSemester("FALL", 2022, "https://www.example.com/fall2022-updated");
        Assert.equal(semesterStoreToTest.getSemester("FALL_2022"), "https://www.example.com/fall2022-updated", "Semester should have been updated correctly");
    }

    function checkRemoveSemester() public {
        console.log("Running checkRemoveSemester");
        semesterStoreToTest.removeSemester("FALL_2022");
        Assert.equal(semesterStoreToTest.getSemester("FALL_2022"), "", "Semester should have been removed correctly");
    }

    function checkAddSemesterInvalid() public {
        console.log("Running checkAddSemesterInvalid");
        semesterStoreToTest.addSemester("INVALID", 2022, "https://www.example.com/invalid");
        Assert.equal(semesterStoreToTest.getSemester("INVALID_2022"), "", "Semester with invalid semester type should not have been added");
    }
}
