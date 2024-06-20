To initialize local dev environment:

1. Start devnet: `starknet-devnet --seed 0 --request-body-size-limit 20000000`
1. Declare token contract: `sncast --profile local declare --contract-name MyToken`
1. Deploy token contract: `sncast --profile local deploy --class-hash 0x3de20f2aaa6f438536e6ea6eec1529f1488a592003db4973f77cb0a8091ebb5 -c 10000 10000 0x4b3f4ba8c00a02b66142a4b1dd41a4dfab4f92650922a3280977b0f03c75ee1` (the recipient is the last from devnet user list)
1. Declare contract: `sncast --profile local declare --contract-name Mimosa`
1. Deploy contract: `sncast --profile local deploy --class-hash 0x16201b63901f0ba8e52c13fd130ad48a87bc10074de0790534e677ab1ceb865 -c 0x3c4bb4727ac01d0d9e164fbe35e23b2978eb59c8d91f66addfe68059c971b55`

To simulate the flow from the command line:

```sh

export ETH="0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7"
export MIMOSA="0x00d8159039bf10f9747d69d5d99a4c47aa1ca8c6b2b1bb14b90bcda17f841be6"

# calculate the commitment hash value
sncast --profile user1 call -a $MIMOSA -f calculate_hash -c 0xf00

# approve mimosa to spend devnet user1 eth
sncast --profile user1 invoke -a $ETH -f approve -c $MIMOSA 1000000 0

# deposit into mimosa
sncast --profile user1 invoke -a $MIMOSA -f deposit -c COMMITMENT_HASH

# withdraw from mimosa
sncast --profile user2 invoke -a $MIMOSA -f withdraw -c 0xf00

# verify that user2 has a higher balance than default
sncast --profile user2 call -a $ETH -f balance_of -c 0x78662e7352d062084b0010068b99288486c2d8b914f6e2a55ce945f8792c8b1
```
