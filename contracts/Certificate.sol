// SPDX-License-Identifier: FAST NUCES
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract CertificateStore is Ownable {
    event CertificateOperation(string operation);
    struct Certificate {
        uint id;
        string name;
        string email;
        string url;
    }
    uint256 certificatesCount = 0;
    mapping(uint => Certificate) certificates;

    function addCertificate(uint id, string memory name, string memory email, string memory url) public onlyOwner  returns (bool) {
        certificates[id] = Certificate(id, name, email, url);
        certificatesCount+=1;
        emit CertificateOperation("Certificate Added!");
        return (validateIfCertificateAddedOrUpdated(id));
    }

    function updateCertificate(uint id, string memory name, string memory email, string memory url) public onlyOwner returns (bool) {
        require(certificates[id].id == id, "Certificate does not exist");
        certificates[id] = Certificate(id, name, email, url);
        emit CertificateOperation("Certificate Updated!");
        return (validateIfCertificateAddedOrUpdated(id));

    }

    function getCertificate(uint id) public view returns (uint, string memory, string memory, string memory) {
        return (certificates[id].id, certificates[id].name, certificates[id].email, certificates[id].url);
    }
    
    function removeCertificate(uint id) public onlyOwner returns (bool) {
        require(certificates[id].id == id, "Certificate does not exist");
        delete certificates[id];
        certificatesCount-=1;
        emit CertificateOperation("Certificate Removed!");
        return (!validateIfCertificateAddedOrUpdated(id));
    }

    function getCertificatesWithPagination(uint from, uint to) public view returns (Certificate[] memory)  {
        require(validatePagination(from, to), "Pagination coordinates exceeds limit!");
        Certificate[] memory _certificates = new Certificate[](to - from + 1);
        uint index = 0;
        for (uint i = from; i <= to; i++) {
            if (certificates[i].id > 0) {
                _certificates[index].id = certificates[i].id;
                _certificates[index].name = certificates[i].name;
                _certificates[index].email = certificates[i].email;
                _certificates[index].url = certificates[i].url;
                index++;
            }
        }
        return _certificates;
    }

    function validateIfCertificateAddedOrUpdated(uint id) private view returns(bool){
        if (bytes(certificates[id].url).length > 0) {
            return true;
        }
        return false;
    }

    function validatePagination(uint from, uint to) private view returns(bool){
        if(from >=0  && to <= certificatesCount)
            return true;
        return false;
    }
}