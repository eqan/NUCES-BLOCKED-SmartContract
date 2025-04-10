// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol";
import "hardhat/console.sol";
import "../contracts/CertificateStore.sol";

contract CertificateStoreTest {
    address owner;
    CertificateStore certificateStoreToTest;
    function beforeAll() public {
        owner = msg.sender;
        certificateStoreToTest = new CertificateStore();
    }

    function addCertificateTest() public {
        certificateStoreToTest.addCertificate("19F0256", "John Doe", "johndoe@email.com", "www.example.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        (string memory id, string memory name, string memory email, string memory url, string memory cgpa, uint batch, string memory honours) = certificateStoreToTest.getCertificate("19F0256");
        Assert.equal(id, "19F0256", "The id of the added certificate should be 19F0256");
        Assert.equal(url, "www.example.com", "The url of the added certificate should be www.example.com");
    }

    function updateCertificateTest() public {
        certificateStoreToTest.updateCertificate("19F0256", "John Doe", "johndoe@email.com", "www.newexample.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        (string memory id, string memory name, string memory email, string memory url, string memory cgpa, uint batch, string memory honours) = certificateStoreToTest.getCertificate("19F0256");
        Assert.equal(id, "19F0256", "Certificate id should be 19F0256");
        Assert.equal(url, "www.newexample.com", "Certificate url should be updated to www.newexample.com");
    }

    function removeCertificateTest() public {
        certificateStoreToTest.removeCertificate("19F0256");
        (string memory id, string memory name, string memory email, string memory url, string memory cgpa, uint batch, string memory honours) = certificateStoreToTest.getCertificate("19F0256");
        Assert.equal(id, "", "Certificate id should be 0 after removal");
        Assert.equal(url, "", "Certificate url should be empty after removal");
    }

    function getCertificateByIndexTest() public {
        certificateStoreToTest.addCertificate("19F0256", "John Doe", "johndoe@email.com", "www.example.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        certificateStoreToTest.addCertificate("19F0257", "Jane Doe", "janedoe@email.com", "www.example2.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        (string memory id, string memory name, string memory email, string memory url, string memory cgpa, uint batch, string memory honours) = certificateStoreToTest.getCertificate("19F0257");
        Assert.equal(id, "19F0257", "The id of the second certificate should be 2");
        Assert.equal(name, "Jane Doe", "The name of the second certificate should be Jane Doe");
        Assert.equal(email, "janedoe@email.com", "The email of the second certificate should be janedoe@email.com");
        Assert.equal(url, "www.example2.com", "The url of the second certificate should be www.newexample.com");
    }

    function testGetCertificatesWithPagination() public {
        certificateStoreToTest.addCertificate("19F0258", "Jim Doe", "jim@email.com", "www.example3.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        (CertificateStore.Certificate[] memory certificates) = certificateStoreToTest.getCertificatesWithPagination(0, 1);
        Assert.equal(certificates.length, 2, "There should be 2 certificates returned");
        Assert.equal(certificates[0].id, "19F0256", "The first certificate id should be 19F0256");
        Assert.equal(certificates[0].name, "John Doe", "The first certificate name should be John Doe");
        Assert.equal(certificates[0].email, "johndoe@email.com", "The first certificate email should be johndoe@email.com");
        Assert.equal(certificates[0].url, "www.example.com", "The first certificate url should be www.example.com");
        Assert.equal(certificates[1].id, "19F0257", "The second certificate id should be 2");
        Assert.equal(certificates[1].name, "Jane Doe", "The second certificate name should be Jane Doe");
        Assert.equal(certificates[1].email, "janedoe@email.com", "The second certificate email should be janedoe@email.com");
        Assert.equal(certificates[1].url, "www.example2.com", "The second certificate url should be www.example2.com");
    }


    function checkAddCertificateAlreadyExistsTest() public {
        certificateStoreToTest.addCertificate("19F0256", "John Doe", "johndoe@email.com", "www.example.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        require(certificateStoreToTest.addCertificate("19F0256", "Jane Doe", "janedoe@email.com", "www.newexample.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals") == false, "Adding a certificate with an id that already exists (19F0256) should not have been successful");
    }

    function checkUpdateCertificateDoesNotExistTest() public {
        require(certificateStoreToTest.updateCertificate("19F0256", "Jane Doe", "janedoe@email.com", "www.newexample.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals") == false, "Updating a certificate with an id that does not exist (19F0256) should not have been successful");
    }

    function checkRemoveCertificateDoesNotExistTest() public {
        require(certificateStoreToTest.removeCertificate("19F0256") == false, "Removing a certificate with an id that does not exist (19F0256) should not have been successful");
    }

    function checkAddCertificateInvalidIdTest() public {
        console.log("Running checkAddCertificateInvalidIdTest");
        require(certificateStoreToTest.addCertificate("19F0256", "John Doe", "johndoe@email.com", "www.example.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals") == false, "Adding a certificate with an invalid id (0) should not have been successful");
    }

    function checkUpdateCertificateInvalidIdTest() public {
        console.log("Running checkUpdateCertificateInvalidIdTest");
        require(certificateStoreToTest.updateCertificate("19F0256", "Jane Doe", "janedoe@email.com", "www.newexample.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals") == false, "Updating a certificate with an invalid id (0) should not have been successful");
    }

    function checkRemoveCertificateInvalidIdTest() public {
        console.log("Running checkRemoveCertificateInvalidIdTest");
        require(certificateStoreToTest.removeCertificate("19F0256") == false, "Removing a certificate with an invalid id (0) should not have been successful");
    }

    function checkRemoveCertificatess() public {
        console.log("Running checkRemoveCertificates");
        // Add Certificates to remove
        certificateStoreToTest.addCertificate("19F0260", "John Doe", "johndoe@email.com", "www.example.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        certificateStoreToTest.addCertificate("19F0261", "Jane Doe", "janedoe@email.com", "www.example2.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        // Remove Certificates
        string[] memory certificateIds = new string[](2);
        certificateIds[0] = "19F0260";
        certificateIds[1] = "19F0261";
        bool success = certificateStoreToTest.removeCertificates(certificateIds);
        Assert.equal(success, true, "Certificates should have been removed successfully");
        // Check that Certificates were removed
        for (uint i = 0; i < certificateIds.length; i++) {
            string memory certificateId = certificateIds[i];
            (string memory id, string memory name, string memory email, string memory url, string memory cgpa, uint batch, string memory honours) = certificateStoreToTest.getCertificate(certificateId);
            Assert.equal(id, "", "Certificate should have been removed correctly");
        }
    }

    function checkAddCertificates() public {
        console.log("Running checkAddCertificates");
        // Add certificates
        CertificateStore.Certificate[] memory certificatesToAdd = new CertificateStore.Certificate[](2);
        certificatesToAdd[0] = CertificateStore.Certificate("19F0260", "John Doe", "johndoe@email.com", "www.example.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        certificatesToAdd[1] = CertificateStore.Certificate("19F0261", "John Doe", "johndoe@email.com", "www.example.com", "3.5", 2019, "4x Gold Medals, 3x Silver Medals");
        bool success = certificateStoreToTest.addCertificates(certificatesToAdd);
        Assert.equal(success, true, "Certificates should have been added successfully");
        // Check that Certificates were added
        (string memory id, string memory name, string memory email, string memory url, string memory cgpa, uint batch, string memory honours) = certificateStoreToTest.getCertificate("19F0260");
        Assert.equal(url, "www.example.com", "Certificate of 19F0260 added Successfully");
        (string memory id2, string memory name2, string memory email2, string memory url2, string memory cgpa2, uint batch2, string memory honours2) = certificateStoreToTest.getCertificate("19F0261");
        Assert.equal(url2, "www.example.com", "Certificate of 19F0261 added Successfully");
    }
}

