pragma solidity ^0.8.0;

contract CertificateStore {
    struct Certificate {
        uint id;
        bytes32 url;
    }

    mapping (uint => Certificate) private certificates;
    uint public certificateCount;

    function addCertificate(uint id, string memory url) public {
        require(certificates[id].id == 0, "Certificate already exists");
        certificates[id] = Certificate(id, bytes32(keccak256(abi.encodePacked(url))));
        certificateCount++;
    }

    function getCertificate(uint id) public view returns (uint, string memory) {
        require(certificates[id].id != 0, "Certificate does not exist");
        return (certificates[id].id, string(abi.decodePacked(certificates[id].url)));
    }
}
