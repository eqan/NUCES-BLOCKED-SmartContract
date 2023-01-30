pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract CertificateStore is Ownable {
    struct Certificate {
        uint id;
        string url;
    }

    mapping(uint => Certificate) certificates;

    function addCertificate(uint id, string memory url) public onlyOwner {
        certificates[id] = Certificate(id, url);
    }

    function updateCertificate(uint id, string memory url) public onlyOwner {
        require(certificates[id].id == id, "Certificate does not exist");
        certificates[id] = Certificate(id, url);
    }

    function getCertificate(uint id) public view returns (uint, string memory) {
        return (certificates[id].id, certificates[id].url);
    }
    
    function removeCertificate(uint id) public onlyOwner {
        require(certificates[id].id == id, "Certificate does not exist");
        delete certificates[id];
    }
}
