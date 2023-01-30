const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Certificate Store Contract", function () {
    let certificateStore;

    before(async function () {
        const CertificateStore = await ethers.getContractFactory("CertificateStore");
        certificateStore = await CertificateStore.deploy();
    });

    it("Should add a certificate", async function () {
        await certificateStore.addCertificate(1, "https://example.com/certificate1");
        const certificate = await certificateStore.getCertificate(1);
        expect(certificate.id).to.equal(1);
        expect(certificate.url).to.equal("https://example.com/certificate1");
    });

    it("Should update a certificate", async function () {
        await certificateStore.updateCertificate(1, "https://example.com/updatedCertificate1");
        const certificate = await certificateStore.getCertificate(1);
        expect(certificate.id).to.equal(1);
        expect(certificate.url).to.equal("https://example.com/updatedCertificate1");
    });

    it("Should throw an error when updating a non-existing certificate", async function () {
        let error;
        try {
            await certificateStore.updateCertificate(2, "https://example.com/updatedCertificate2");
        } catch (e) {
            error = e;
        }
        expect(error.message).to.include("Certificate does not exist");
    });
});

describe("Semester Result Store Contract", function () {
    let semesterResultStore;

    before(async function () {
        const SemesterResultStore = await ethers.getContractFactory("SemesterResultStore");
        semesterResultStore = await SemesterResultStore.deploy();
    });

    it("Should add a result", async function () {
        await semesterResultStore.addResult(1, 0, 2020, "https://example.com/result1");
        const result = await semesterResultStore.getResult(1);
        expect(result.id).to.equal(1);
        expect(result.type).to.equal(0);
        expect(result.year).to.equal(2020);
        expect(result.url).to.equal("https://example.com/result1");
    });

    it("Should update a result", async function () {
        await semesterResultStore.updateResult(1, 1, 2021, "https://example.com/updatedResult1");
        const result = await semesterResultStore.getResult(1);
        expect(result.id).to.equal(1);
        expect(result.type).to.equal(1);
        expect(result.year).to.equal(2021);
        expect(result.url).to.equal("https://example.com/updatedResult1");
    });

    it("Should throw an error when updating a non-existing result", async function () {
        let error;
        try {
            await semesterResultStore.updateResult(2, 2, 2022, "https://example.com/updatedResult2");
        } catch (e) {
            error = e;
        }
        expect(error.message).to.include("Result does not exist");
    });
});
