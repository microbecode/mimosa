use contracts::interfaces::{
    IMimosaDispatcher, IMimosaDispatcherTrait, IERC20Dispatcher, IERC20DispatcherTrait
};
use core::poseidon::hades_permutation;
use snforge_std::{
    declare, ContractClassTrait, start_cheat_caller_address, cheat_caller_address,
    stop_cheat_caller_address, CheatSpan
};
use starknet::ContractAddress;

fn user1() -> ContractAddress {
    'user 1'.try_into().unwrap()
}
const denomination: u256 = 100;

fn deploy_mimosa(token_address: ContractAddress) -> ContractAddress {
    let contract = declare("Mimosa").unwrap();
    let calldata: Array<felt252> = array![token_address.into()];
    let (address, _) = contract.deploy(@calldata).unwrap();
    address
}

fn deploy_token(recipient: ContractAddress) -> ContractAddress {
    let contract = declare("MyToken").unwrap();
    let calldata: Array<felt252> = array![1000000000000000000, 0, recipient.into()];
    let (address, _) = contract.deploy(@calldata).unwrap();
    address
}

#[test]
fn test_flow() {
    let token_address = deploy_token(user1());
    let mimosa_address = deploy_mimosa(token_address);
    let mimosa = IMimosaDispatcher { contract_address: mimosa_address };

    let secret: felt252 = 5;
    let (hash, _, _) = hades_permutation(secret, 0, 1);

    start_cheat_caller_address(token_address, user1());
    IERC20Dispatcher { contract_address: token_address }.approve(mimosa_address, denomination);
    stop_cheat_caller_address(token_address);

    start_cheat_caller_address(mimosa_address, user1());
    mimosa.deposit(hash);
    mimosa.withdraw(secret);
}

#[test]
fn test_multiple_deposits() {
    let token_address = deploy_token(user1());
    let mimosa_address = deploy_mimosa(token_address);
    let mimosa = IMimosaDispatcher { contract_address: mimosa_address };

    let secret: felt252 = 5;
    let (hash, _, _) = hades_permutation(secret, 0, 1);

    start_cheat_caller_address(token_address, user1());
    IERC20Dispatcher { contract_address: token_address }
        .approve(mimosa_address, denomination * 100);
    stop_cheat_caller_address(token_address);

    start_cheat_caller_address(mimosa_address, user1());

    // Deposit multiple. just use the same secret, doesn't matter much
    mimosa.deposit(hash);
    mimosa.deposit(hash);
    mimosa.deposit(hash);
//mimosa.withdraw(secret);
}
