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

    function addCertificate() public {
        certificateStoreToTest.addCertificate(1, "www.example.com");
        (uint id, string memory url) = certificateStoreToTest.getCertificate(1);
        Assert.equal(id, 1, "The id of the added certificate should be 1");
        Assert.equal(url, "www.example.com", "The url of the added certificate should be www.example.com");
    }


    function updateCertificateTest() public {
        certificateStoreToTest.addCertificate(1, "www.example.com");
        certificateStoreToTest.updateCertificate(1, "www.newexample.com");
        (uint id, string memory url) = certificateStoreToTest.getCertificate(1);
        Assert.equal(id, 1, "Certificate id should be 1");
        Assert.equal(url, "www.newexample.com", "Certificate url should be updated to www.newexample.com");
    }

    function removeCertificateTest() public {
        certificateStoreToTest.addCertificate(1, "www.example.com");
        certificateStoreToTest.removeCertificate(1);
        (uint id, string memory url) = certificateStoreToTest.getCertificate(1);
        Assert.equal(id, 0, "Certificate id should be 0 after removal");
        Assert.equal(url, "", "Certificate url should be empty after removal");
    }
}
