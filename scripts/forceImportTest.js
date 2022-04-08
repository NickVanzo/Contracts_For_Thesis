

// scripts/prepare_upgrade.js
async function main() {
    const proxyAddress = '0x44a1ba61618d9218e6afe75ad1a14729e9325e5a';
    const options = {
        kind: 'transparent'
    }
    const BoxV2 = await ethers.getContractFactory("MonstersOnTheWayCardsV2");

    console.log('Forcing the import...');
    const boxV2Address = await upgrades.forceImport(proxyAddress, BoxV2, options);
    console.log("ERC721 at:", boxV2Address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });