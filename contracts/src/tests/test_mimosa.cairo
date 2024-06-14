use contracts::interfaces::{IMimosaDispatcher, IMimosaDispatcherTrait};
use core::poseidon::hades_permutation;
use snforge_std::{declare, ContractClassTrait, start_cheat_caller_address};
use starknet::ContractAddress;
//use contracts::my_token::MyToken;

const USER1_WITH_BALANCE: felt252 = 0x11;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

fn deploy_token(recipient: felt252) -> ContractAddress {
    let mut calldata = ArrayTrait::new();
    calldata.append(1000000000000000000);
    calldata.append(0);
    calldata.append(recipient);

    let contract = declare("MyToken").unwrap();
    // let address = contract
    //     .deploy_at(@calldata, STRK_ADDRESS.try_into().unwrap())
    //     .expect('unable to deploy mockstrk');

    let (contract_address, _) = contract.deploy(@calldata).unwrap();

    //IERC20Dispatcher { contract_address: address }
    contract_address
}

#[test]
fn test_flow() {
    let contract_address = deploy_contract("Mimosa");
    let token_address = deploy_token(USER1_WITH_BALANCE);

    let dispatcher = IMimosaDispatcher { contract_address };

    let secret: felt252 = 5;

    let (hash, _, _) = hades_permutation(secret, 0, 1);

    start_cheat_caller_address(contract_address, USER1_WITH_BALANCE.try_into().unwrap());
// dispatcher.deposit(hash);
// dispatcher.withdraw(secret);
}

#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;

    fn symbol(self: @TContractState) -> felt252;

    fn decimals(self: @TContractState) -> u8;

    fn total_supply(self: @TContractState) -> u256;

    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;

    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;

    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}
