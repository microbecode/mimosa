use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait};

use contracts::IMimosaSafeDispatcher;
use contracts::IMimosaSafeDispatcherTrait;
use contracts::IMimosaDispatcher;
use contracts::IMimosaDispatcherTrait;
use core::poseidon::hades_permutation;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_flow() {
    let contract_address = deploy_contract("Mimosa");

    let dispatcher = IMimosaDispatcher { contract_address };

    let secret: felt252 = 5;

    let (hash, _, _) = hades_permutation(secret, 0, 1);

    dispatcher.deposit(hash);
    dispatcher.withdraw(secret);
}

