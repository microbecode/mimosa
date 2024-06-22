This folder includes the Cairo smart contracts for the project and instructions on how to use those.

## Contracts

The smart contracts are written in Cairo version 2.6.3.

There is one main contract (mimosa.cairo) and a few auxiliary, and test contracts. The unit tests are available in the `tests` folder.

## Local dev instructions

### Requirements

You will need to have the following things installed:

1. Cairo, at least version 2.6.3
1. Starknet-Foundry
1. Starknet-devnet-rs

### Local dev

To initialize local dev environment:

1. Go to folder `/frontend` and run `yarn run devnet`
1. Run `yarn run deploy`
1. Note the Mimosa's contract address and replace it below for the variable

To simulate the flow from the command line, run the following in the `/contracts` dir:

```sh

export STRK="0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d"
# replace the following with the correct address
export MIMOSA="0x01ee3f98694c0bc21622856d724775af42949f162d318cda8a975ad9283ccb49"
export USER1="0x64b48806902a367c8598f4f95c305e8c1a1acba5f082d294a43793113115691"
export USER2="0x78662e7352d062084b0010068b99288486c2d8b914f6e2a55ce945f8792c8b1"
export SIZE=100

# Check user balances before
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER1
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER2

# approve mimosa to spend devnet user1 strk
sncast --profile user1 invoke -a $STRK -f approve -c $MIMOSA $SIZE 0

# calculate the commitment hash value
sncast --profile user1 call -a $MIMOSA -f calculate_hash -c 0xf00

# deposit into mimosa
sncast --profile user1 invoke -a $MIMOSA -f deposit -c 0x2fb4b56113252d12708bc6a9b4976c19b5d3badc99f4db151896bb0c7895774

# get proof for the deposit
sncast --profile user1 call -a $MIMOSA -f get_proof -c 7

# withdraw from mimosa
sncast --profile user2 invoke -a $MIMOSA -f withdraw -c 0x3 0x60009f680a43e6f760790f76214b26243464cdd4f31fdc460baf66d32897c1b 0x34f14e386b960f87e49e5001ce3feb5bed6adb5d1fea6bad049104e26af5452 0x673c52a0560bc744052b5efed2d5957e22e59aa71577c7ef72a3f5e38d2e2eb 0xf00

# Check user balances after
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER1
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER2
```

You can also use the `runflow.sh` file to run the full flow. Remember to change the Mimosa contract address. Also note you'll be able to run it only once as you cannot withdraw multiple times with the same proof to prevent multiple withdrawals.
