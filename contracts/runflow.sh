#!/bin/sh

STRK="0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d"
MIMOSA="0x04af3c9dfe23d110888a23425deb0e0e4548addd9ea2ff5bd853b08252281da8"
USER1="0x64b48806902a367c8598f4f95c305e8c1a1acba5f082d294a43793113115691"
USER2="0x78662e7352d062084b0010068b99288486c2d8b914f6e2a55ce945f8792c8b1"
SIZE=100

# show User 1 and User 2 start balances
printf "=== Checking user start balances\n"
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER1
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER2

# approve mimosa to spend devnet user1 strk
printf "=== User 1 approves Mimosa to spend its STRK\n"
sncast --profile user1 invoke -a $STRK -f approve -c $MIMOSA $SIZE 0

# calculate the commitment hash value
printf "=== Simulating calculation of the commitment hash\n"
sncast --profile user1 call -a $MIMOSA -f calculate_hash -c 0xf00

# deposit into mimosa
printf "=== User 1 deposits STRK into Mimosa, using the commitment hash\n"
sncast --profile user1 invoke -a $MIMOSA -f deposit -c 0x2fb4b56113252d12708bc6a9b4976c19b5d3badc99f4db151896bb0c7895774

# get proof for the deposit
printf "Checking the proof of deposit\n"
sncast --profile user1 call -a $MIMOSA -f get_proof -c 7

# withdraw from mimosa
printf "=== User 2 withdraws STRK from Mimosa, using a proof\n"
sncast --profile user2 invoke -a $MIMOSA -f withdraw -c 0x3 0x60009f680a43e6f760790f76214b26243464cdd4f31fdc460baf66d32897c1b 0x34f14e386b960f87e49e5001ce3feb5bed6adb5d1fea6bad049104e26af5452 0x673c52a0560bc744052b5efed2d5957e22e59aa71577c7ef72a3f5e38d2e2eb 0xf00

# check User 1 and User 2 balances
printf "=== Checking user balances, they differ by 100 STRK\n"
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER1
sncast --int-format --profile user2 call -a $STRK -f balance_of -c $USER2
