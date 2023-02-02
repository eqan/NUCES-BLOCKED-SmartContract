// SPDX-License-Identifier: FAST NUCES
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract CertificateStore is Ownable {
    event CertificateOperation(string operation);
    struct Certificate {
        uint id;
        string url;
    }

    mapping(uint => Certificate) certificates;

    function addCertificate(uint id, string memory url) public onlyOwner {
        certificates[id] = Certificate(id, url);
        emit CertificateOperation("Certificate Added!");
    }

    function updateCertificate(uint id, string memory url) public onlyOwner {
        require(certificates[id].id == id, "Certificate does not exist");
        certificates[id] = Certificate(id, url);
        emit CertificateOperation("Certificate Updated!");

    }

    function getCertificate(uint id) public view returns (uint, string memory) {
        return (certificates[id].id, certificates[id].url);
    }
    
    function removeCertificate(uint id) public onlyOwner {
        require(certificates[id].id == id, "Certificate does not exist");
        delete certificates[id];
        emit CertificateOperation("Certificate Removed!");
    }
}
