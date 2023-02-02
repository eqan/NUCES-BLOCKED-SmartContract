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

    function addCertificate(uint id, string memory url) public onlyOwner  returns (bool) {
        certificates[id] = Certificate(id, url);
        emit CertificateOperation("Certificate Added!");
        return (validateIfCertificateAddedOrUpdated(id));
    }

    function updateCertificate(uint id, string memory url) public onlyOwner returns (bool) {
        require(certificates[id].id == id, "Certificate does not exist");
        certificates[id] = Certificate(id, url);
        emit CertificateOperation("Certificate Updated!");
        return (validateIfCertificateAddedOrUpdated(id));

    }

    function getCertificate(uint id) public view returns (uint, string memory) {
        return (certificates[id].id, certificates[id].url);
    }
    
    function removeCertificate(uint id) public onlyOwner returns (bool) {
        require(certificates[id].id == id, "Certificate does not exist");
        delete certificates[id];
        emit CertificateOperation("Certificate Removed!");
        return (!validateIfCertificateAddedOrUpdated(id));
    }

    function validateIfCertificateAddedOrUpdated(uint id) private view returns(bool){
        if (bytes(certificates[id].url).length > 0) {
            return true;
        }
        return false;
    }
}