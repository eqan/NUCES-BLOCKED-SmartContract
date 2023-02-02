const { expect } = require('chai');
const { Contract, getDefaultProvider } = require('ethers');
const hardhat = require('hardhat');

async function main() {
  const provider = getDefaultProvider('goreli');
  const contract = await Contract.fromArtifactName('SemesterResults', provider);

  const owner = await contract.owner();

  describe('SemesterResults Contract', () => {
    it('should store a semester result', async () => {
      const concatenatedKey = 'FALL2022';
      const url = 'https://example.com/result/FALL2022';
      await contract.storeResult(concatenatedKey, url, { from: owner });

      const storedUrl = await contract.semesterResults(concatenatedKey);
      expect(storedUrl).to.equal(url);
    });

    // it('should not allow non-owner to store a semester result', async () => {
    //   const concatenatedKey = 'WINTER2022';
    //   const url = 'https://example.com/result/WINTER2022';
    //   try {
    //     await contract.storeResult(concatenatedKey, url, { from: hardhat.accounts[1] });
    //     expect.fail('Non-owner was able to store a result');
    //   } catch (error) {
    //     expect(error.message).to.include('revert');
    //   }
    // });

    // it('should update a semester result', async () => {
    //   const concatenatedKey = 'SUMMER2022';
    //   const url = 'https://example.com/result/SUMMER2022';
    //   const newUrl = 'https://example.com/result/SUMMER2022/new';
    //   await contract.storeResult(concatenatedKey, url, { from: owner });

    //   await contract.updateResult(concatenatedKey, newUrl, { from: owner });
    //   const storedUrl = await contract.semesterResults(concatenatedKey);
    //   expect(storedUrl).to.equal(newUrl);
    // });

    // it('should not allow non-owner to update a semester result', async () => {
    //   const concatenatedKey = 'SUMMER2021';
    //   const url = 'https://example.com/result/SUMMER2021';
    //   const newUrl = 'https://example.com/result/SUMMER2021/new';
    //   await contract.storeResult(concatenatedKey, url, { from: owner });

    //   try {
    //     await contract.updateResult(concatenatedKey, newUrl, { from: hardhat.accounts[1] });
    //     expect.fail('Non-owner was able to update a result');
    //   } catch (error) {
    //     expect(error.message).to.include('revert');
    //   }
    // });

    // it('should remove a semester result', async () => {
    //   const concatenatedKey = 'WINTER2021';
    //   const url = 'https://example.com/result/WINTER2021';
    //   await contract.storeResult(concatenatedKey, url, { from: owner });

    //   await contract.removeResult(concatenatedkey, { from: owner });
    //   const storedUrl = await contract.semesterResults(concatenatedKey);
    //   expect(storedUrl).to.equal('');
    //   });
      
    //   it('should not allow non-owner to remove a semester result', async () => {
    //     const concatenatedKey = 'FALL2021';
    //     const url = 'https://example.com/result/FALL2021';
    //     await contract.storeResult(concatenatedKey, url, { from: owner });
      
    //     try {
    //       await contract.removeResult(concatenatedKey, { from: hardhat.accounts[1] });
    //       expect.fail('Non-owner was able to remove a result');
    //     } catch (error) {
    //       expect(error.message).to.include('revert');
    //     }
    //   });
      });
      }
      
      hardhat.run(main);
