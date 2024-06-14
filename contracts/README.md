To initialize local dev environment:

1. Start devnet: `starknet-devnet --seed 1`
1. Store a devnet account: `sncast --url http://127.0.0.1:5050 account add --name local --address 0x6a41708a2379d0328ff6797007a1e4d85ca934d69fa64c4e465d3a99a167fb5 --type oz --private-key 0xdc76d257c6cfd7833e92380910a81f93 --add-profile local`
1. Change the stored path in snfoundry.toml to use `~`
1. Declare contract: `sncast --account local --url http://127.0.0.1:5050 declare --contract-name Mimosa`
1. Deploy contract: `sncast --account local --url http://127.0.0.1:5050 deploy --class-hash X` (check classhash from previous)
1. Test interaction: `sncast --account local --url http://127.0.0.1:5050 invoke --contract-address X --function "deposit"` (check address from previous)
