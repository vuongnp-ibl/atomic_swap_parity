var EthereumTx = require('ethereumjs-tx');
var privateKey = Buffer.from('50c184f305f0d41dd322a600e93ff899bf924603cfb25c2fca9a10e9731c40b3', 'hex');

var txParams = {
    nonce: '0x0',
    gasPrice: '0x1',
    gasLimit: '0x186A0',
    to: '0x00bd138abd70e2f00903268f3db08f2d25677c9e',
    value: '0x64'
}

var tx = new EthereumTx(txParams);
tx.sign(privateKey);
var serializedTx = tx.serialize();
console.log(serializedTx.toString('hex'));
//f889808609184e72a00082271094000000000000000000000000000000000000000080a47f74657374320000000000000000000000000000000000000000000000000000006000571ca08a8bbf888cfa37bbf0bb965423625641fc956967b81d12e23709cead01446075a01ce999b56a8a88504be365442ea61239198e23d1fce7d00fcfc5cd3b44b7215f
// web3.eth.sendTransaction('0x' + serializedTx.toString('hex'), function (err, hash) {
//     if (!err)
//         console.log(hash); // "0x7f9fade1c0d57a7af66ab4ead79fade1c0d57a7af66ab4ead7c2c2eb7b11a91385"
// });

