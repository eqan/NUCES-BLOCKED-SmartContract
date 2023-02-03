pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol";
import "hardhat/console.sol";
import "../contracts/Certificate.sol";

contract CertificateStoreTest {
    address owner;
    CertificateStore certificateStoreToTest;
    function beforeAll() public {
        owner = msg.sender;
        certificateStoreToTest = new CertificateStore();
    }

    function addCertificateTest() public {
        certificateStoreToTest.addCertificate(1, "John Doe", "johndoe@email.com", "www.example.com");
        (uint id, string memory name, string memory email, string memory url) = certificateStoreToTest.getCertificate(1);
        Assert.equal(id, 1, "The id of the added certificate should be 1");
        Assert.equal(url, "www.example.com", "The url of the added certificate should be www.example.com");
    }

    function updateCertificateTest() public {
        certificateStoreToTest.addCertificate(1, "John Doe", "johndoe@email.com", "www.example.com");
        certificateStoreToTest.updateCertificate(1, "Jane Doe", "janedoe@email.com", "www.newexample.com");
        (uint id, string memory name, string memory email, string memory url) = certificateStoreToTest.getCertificate(1);
        Assert.equal(id, 1, "Certificate id should be 1");
        Assert.equal(url, "www.newexample.com", "Certificate url should be updated to www.newexample.com");
    }

    function removeCertificateTest() public {
        certificateStoreToTest.addCertificate(1, "John Doe", "johndoe@email.com", "www.example.com");
        certificateStoreToTest.removeCertificate(1);
        (uint id, string memory name, string memory email, string memory url) = certificateStoreToTest.getCertificate(1);
        Assert.equal(id, 0, "Certificate id should be 0 after removal");
        Assert.equal(url, "", "Certificate url should be empty after removal");
    }

    function getCertificateByIndexTest() public {
        certificateStoreToTest.addCertificate(1, "John Doe", "johndoe@email.com", "www.example.com");
        certificateStoreToTest.addCertificate(2, "Jane Doe", "janedoe@email.com", "www.newexample.com");
        (uint id, string memory name, string memory email, string memory url) = certificateStoreToTest.getCertificate(2);
        Assert.equal(id, 2, "The id of the second certificate should be 2");
        Assert.equal(name, "Jane Doe", "The name of the second certificate should be Jane Doe");
        Assert.equal(email, "janedoe@email.com", "The email of the second certificate should be janedoe@email.com");
        Assert.equal(url, "www.newexample.com", "The url of the second certificate should be www.newexample.com");
    }

    function testGetCertificatesWithPagination() public {
        certificateStoreToTest.addCertificate(1, "John Doe", "johndoe@email.com", "www.example.com");
        certificateStoreToTest.addCertificate(2, "Jane Doe", "janedoe@email.com", "www.example2.com");
        certificateStoreToTest.addCertificate(3, "Jim Doe", "jim@email.com", "www.example3.com");
        (CertificateStore.Certificate[] memory certificates) = certificateStoreToTest.getCertificatesWithPagination(1, 2);
        Assert.equal(certificates.length, 2, "There should be 2 certificates returned");
        Assert.equal(certificates[0].id, 1, "The first certificate id should be 1");
        Assert.equal(certificates[0].name, "John Doe", "The first certificate name should be John Doe");
        Assert.equal(certificates[0].email, "johndoe@email.com", "The first certificate email should be johndoe@email.com");
        Assert.equal(certificates[0].url, "www.example.com", "The first certificate url should be www.example.com");
        Assert.equal(certificates[1].id, 2, "The second certificate id should be 2");
        Assert.equal(certificates[1].name, "Jane Doe", "The second certificate name should be Jane Doe");
        Assert.equal(certificates[1].email, "janedoe@email.com", "The second certificate email should be janedoe@email.com");
        Assert.equal(certificates[1].url, "www.example2.com", "The second certificate url should be www.example2.com");
    }


    function checkAddCertificateAlreadyExistsTest() public {
        certificateStoreToTest.addCertificate(1, "John Doe", "johndoe@email.com", "www.example.com");
        require(certificateStoreToTest.addCertificate(1, "Jane Doe", "janedoe@email.com", "www.newexample.com") == false, "Adding a certificate with an id that already exists (1) should not have been successful");
    }

    function checkUpdateCertificateDoesNotExistTest() public {
        require(certificateStoreToTest.updateCertificate(1, "Jane Doe", "janedoe@email.com", "www.newexample.com") == false, "Updating a certificate with an id that does not exist (1) should not have been successful");
    }

    function checkRemoveCertificateDoesNotExistTest() public {
        require(certificateStoreToTest.removeCertificate(1) == false, "Removing a certificate with an id that does not exist (1) should not have been successful");
    }

    function checkAddCertificateInvalidIdTest() public {
        console.log("Running checkAddCertificateInvalidIdTest");
        require(certificateStoreToTest.addCertificate(0, "John Doe", "johndoe@email.com", "www.example.com") == false, "Adding a certificate with an invalid id (0) should not have been successful");
    }

    function checkUpdateCertificateInvalidIdTest() public {
        console.log("Running checkUpdateCertificateInvalidIdTest");
        require(certificateStoreToTest.updateCertificate(0, "Jane Doe", "janedoe@email.com", "www.newexample.com") == false, "Updating a certificate with an invalid id (0) should not have been successful");
    }

    function checkRemoveCertificateInvalidIdTest() public {
        console.log("Running checkRemoveCertificateInvalidIdTest");
        require(certificateStoreToTest.removeCertificate(0) == false, "Removing a certificate with an invalid id (0) should not have been successful");
    }
}