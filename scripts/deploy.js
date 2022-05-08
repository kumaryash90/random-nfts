const { ethers } = require("hardhat");

const main = async () => {
    const [signer] = await ethers.getSigners();
    console.log(signer.address);

    const RandomNFT = await ethers.getContractFactory("RandomNFT");
    const rnft = await RandomNFT.deploy(
        "Random NFTs",
        "RNFT",
        "https://bafybeifvmskjnh2tuufnd7sycxv6ttq2lyipiakktbigwghh6b53kzpfw4.ipfs.nftstorage.link/metadata/"
    );
    await rnft.deployed();

    const baseuri = await rnft.baseURI();
    console.log("base uri: ", baseuri);

    await rnft.mintTo(signer.address, { value: 1e15 });

    const tokenuri = await rnft.tokenURI(1);
    console.log("token uri: ", tokenuri.toString());
    
}

main()
.then(() => process.exit(0))
.catch((err) => {
    console.log(err);
    process.exit(1);
});