To initialize local dev environment:

1. Start devnet: `starknet-devnet --seed 1 --request-body-size-limit 20000000`
1. Store a devnet account: `sncast --url http://127.0.0.1:5050 account add --name local --address 0x6a41708a2379d0328ff6797007a1e4d85ca934d69fa64c4e465d3a99a167fb5 --type oz --private-key 0xdc76d257c6cfd7833e92380910a81f93 --add-profile local`
1. Change the stored path in snfoundry.toml to use `~`
1. Declare token contract: `sncast --account local --url http://127.0.0.1:5050 declare --contract-name MyToken`
1. Deploy token contract: `sncast --account local --url http://127.0.0.1:5050 deploy --class-hash 0x67309efdce4b0b8f5e480f66b89e8ede38291a04ffcd11f5e5598fcdb55806a -c 10000 10000 0x6a41708a2379d0328ff6797007a1e4d85ca934d69fa64c4e465d3a99a167fb5` (the recipient is the last from devnet user list)
1. Declare contract: `sncast --account local --url http://127.0.0.1:5050 declare --contract-name Mimosa`
1. Deploy contract: `sncast --account local --url http://127.0.0.1:5050 deploy --class-hash 0x55a4208dde39c2318142559e871a39dd99e8e0945fd4f0f56347f9678a7e63d -c 0x3c4bb4727ac01d0d9e164fbe35e23b2978eb59c8d91f66addfe68059c971b55`
