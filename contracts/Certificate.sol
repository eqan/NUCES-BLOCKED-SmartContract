// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract CertificateStore is Ownable {
    event CertificateOperation(string operation);
    struct Certificate {
        string id;
        string name;
        string email;
        string url;
    }
    uint256 certificateIndex = 0;
    mapping(string => Certificate) certificates;
    mapping(uint => string) certificateIds;

    function addCertificates(Certificate[] memory _certificates) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < _certificates.length; i++) {
            addCertificate(_certificates[i].id, _certificates[i].name, _certificates[i].email, _certificates[i].url);
        }
        return true;
    }

    function addCertificate(string memory id, string memory name, string memory email, string memory url) public onlyOwner  returns (bool) {
        require(compare(certificates[id].id, ""), "Id already exists");
        certificateIds[certificateIndex] = id;
        certificates[id] = Certificate(id, name, email, url);
        certificateIndex+=1;
        emit CertificateOperation("Certificate Added!");
        return true;
    }

    function updateCertificate(string memory id, string memory name, string memory email, string memory url) public onlyOwner returns (bool) {
        require(compare(certificates[id].id, id), "Certificate does not exist");
        certificates[id] = Certificate(id, name, email, url);
        emit CertificateOperation("Certificate Updated!");
        return true;

    }

    function getCertificate(string memory id) public view returns (string memory, string memory, string memory, string memory) {
        return (certificates[id].id, certificates[id].name, certificates[id].email, certificates[id].url);
    }
    
    function getCertificateCount() public view returns (uint256) {
        return certificateIndex;
    }

    function removeCertificates(string[] memory ids) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < ids.length; i++) {
            removeCertificate(ids[i]);
        }
        return true;
    }
    
    function removeCertificate(string memory id) public onlyOwner returns (bool) {
        require(compare(certificates[id].id, id), "Certificate does not exist");
        delete certificates[id];
        uint256 indexToDelete = findCertificateIndex(id);
        certificateIds[indexToDelete] = certificateIds[certificateIndex-1];
        certificateIndex-=1;
        emit CertificateOperation("Certificate Removed!");
        return true;
    }

    function getCertificatesWithPagination(uint from, uint to) public view returns (Certificate[] memory)  {
        require(validatePagination(from, to), "Pagination coordinates exceeds limit!");
        Certificate[] memory _certificates = new Certificate[](to - from + 1);
        uint index = 0;
        for (uint i = from; i <= to; i++) {
            string memory id  = certificateIds[i];
            if(!compare(certificates[id].id, "")){
                _certificates[index].id = certificates[id].id;
                _certificates[index].name = certificates[id].name;
                _certificates[index].email = certificates[id].email;
                _certificates[index].url = certificates[id].url;
                index++;
            }
        }
        return _certificates;
    }

    function validatePagination(uint from, uint to) private view returns(bool){
        if(from >=0  && to <= certificateIndex)
            return true;
        return false;
    }

    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    
    function findCertificateIndex(string memory id) private view returns (uint256) {
        for (uint256 i = 0; i < certificateIndex; i++) {
            if (compare(certificateIds[i], id)) {
                return i;
            }
        }
        revert("Certificate not found in certificateIds");
    }
}
