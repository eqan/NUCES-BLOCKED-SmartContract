const { expect } = require('chai');
const { Contract, getDefaultProvider } = require('ethers');
const hardhat = require('hardhat');

async function main() {
const provider = getDefaultProvider('rinkeby');
const contract = await Contract.fromArtifactName('Certificate', provider);

const owner = await contract.owner();

describe('Certificate Contract', () => {
it('should store a certificate', async () => {
const studentId = '12345';
const certificateId = 'CERT_001';
const url = 'https://example.com/certificate/CERT_001';
await contract.storeCertificate(studentId, certificateId, url, { from: owner });
const storedUrl = await contract.certificate(studentId, certificateId);
expect(storedUrl).to.equal(url);
});

it('should not allow non-owner to store a certificate', async () => {
const studentId = '56789';
const certificateId = 'CERT_002';
const url = 'https://example.com/certificate/CERT_002';
try {
  await contract.storeCertificate(studentId, certificateId, url, { from: hardhat.accounts[1] });
  expect.fail('Non-owner was able to store a certificate');
} catch (error) {
  expect(error.message).to.include('revert');
}
});

it('should update a certificate', async () => {
const studentId = '11111';
const certificateId = 'CERT_003';
const url = 'https://example.com/certificate/CERT_003';
const newUrl = 'https://example.com/certificate/CERT_003/new';
await contract.storeCertificate(studentId, certificateId, url, { from: owner });

await contract.updateCertificate(studentId, certificateId, newUrl, { from: owner });
const storedUrl = await contract.certificate(studentId, certificateId);
expect(storedUrl).to.equal(newUrl);
});

it('should not allow non-owner to update a certificate', async () => {
const studentId = '22222';
const certificateId = 'CERT_004';
const url = 'https://example.com/certificate/CERT_004';
const newUrl = 'https://example.com/certificate/CERT_004/new';
await contract.storeCertificate(studentId, certificateId, url, { from: owner });

try {
  await contract.updateCertificate(studentId, certificateId, newUrl, { from: hardhat.accounts[1] });
  expect.fail('Non-owner was able to update a certificate');
} catch (error) {
  expect(error.message).to.include('revert');
}
});

it('should remove a certificate', async () => {
const studentId = '33333';
const certificateId = 'CERT_005';
const url = 'https://example.com/certificate/CERT_005';
await contract.storeCertificate(studentId, certificateId, url, { from: owner
});
await contract.removeCertificate(studentId, certificateId, { from: owner });
const storedUrl = await contract.certificate(studentId, certificateId);
expect(storedUrl).to.equal('');
});

it('should not allow non-owner to remove a certificate', async () => {
const studentId = '44444';
const certificateId = 'CERT_006';
const url = 'https://example.com/certificate/CERT_006';
await contract.storeCertificate(studentId, certificateId, url, { from: owner });

try {
await contract.removeCertificate(studentId, certificateId, { from: hardhat.accounts[1] });
expect.fail('Non-owner was able to remove a certificate');
} catch (error) {
expect(error.message).to.include('revert');
}
});
});
}

main();
