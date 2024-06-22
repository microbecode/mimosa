# Mimosa

A project for the Starkhack hackathon in 2024.

## Description

The project implements a Tornado Cash like asset mixer on Starknet. It has a website for user to deposit assets (STRK tokens) and for withdrawing the assets with another address.

The problem with Starknet is that it's a ZK rollup with the ZK part. It does not provide privacy for its users. Everything you do on the network is public.

The project is meant for any user of Starknet who cares about their privacy. The reasons for wanting to hide your asset transfers can vary wildly, but we believe every user should have the possibility for it, if they so want. Currently, there is no project on Starknet that implements anything similar.

## Tech

The UI is implemented with the help of Starknet Scaffold project. Burner wallets are utilized to demonstrate the functionality and the utilized Cairo contract is connected to the website.

The smart contracts are implemented with Cairo 1. They implement the very basic functionality of Tornado Cash: merkle trees and part of the commitment management.

Zero Knowledge proofs should be used to hide the link between the deposit and the withdrawal, but unfortunately that part is not implemented. Therefore, the withdrawal requires a plaintext secret to be submitted - the same secret that was hashed and given as input upon deposit.

## Disclaimer

This is a hackathon project. Some needed pieces are missing. Do not consider for production usage.

## Contact

Project team:

- Milan: https://x.com/milancermak
- Lauri: https://x.com/LauriPelto
