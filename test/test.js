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

    it("Should not add a certificate with the same ID", async function () {
        let error;
        try {
            await certificateStore.addCertificate(1, "https://example.com/certificate2");
        } catch (e) {
            error = e;
        }
        expect(error.message).to.include("Certificate already exists");
    });

    it("Should get a certificate", async function () {
        const certificate = await certificateStore.getCertificate(1);
        expect(certificate.id).to.equal(1);
        expect(certificate.url).to.equal("https://example.com/certificate1");
    });

    it("Should not get a non-existent certificate", async function () {
        let error;
        try {
            await certificateStore.getCertificate(2);
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
        await semesterResultStore.addResult(1, 0, 2022, "https://example.com/result1");
        const result = await semesterResultStore.getResult(1);
        expect(result.id).to.equal(1);
        expect(result.type).to.equal(0);
        expect(result.year).to.equal(2022);
        expect(result.url).to.equal("https://example.com/result1");
    });

    it("Should not add a result with the same ID", async function () {
        let error;
        try {
            await semesterResultStore.addResult(1, 1, 2022, "https://example.com/result2");
        } catch (e) {
            error = e;
        }
        expect(error.message).to.include("Result already exists");
    });

    it("Should get a result", async function () {
        const result = await semesterResultStore.getResult(1);
        expect(result.id).to.equal(1);
        expect(result.type).to.equal(0);
        expect(result.year).to.equal(2022);
        expect(result.url).to.equal("https://example.com/result1");
    });
  });