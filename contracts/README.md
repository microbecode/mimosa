To initialize local dev environment:

1. Start devnet: `starknet-devnet --seed 0 --request-body-size-limit 20000000`
1. Declare token contract: `sncast --profile local declare --contract-name MyToken`
1. Deploy token contract: `sncast --profile local deploy --class-hash 0x3de20f2aaa6f438536e6ea6eec1529f1488a592003db4973f77cb0a8091ebb5 -c 10000 10000 0x4b3f4ba8c00a02b66142a4b1dd41a4dfab4f92650922a3280977b0f03c75ee1` (the recipient is the last from devnet user list)
1. Declare contract: `sncast --profile local declare --contract-name Mimosa`
1. Deploy contract: `sncast --profile local deploy --class-hash 0x16201b63901f0ba8e52c13fd130ad48a87bc10074de0790534e677ab1ceb865 -c 0x3c4bb4727ac01d0d9e164fbe35e23b2978eb59c8d91f66addfe68059c971b55`
