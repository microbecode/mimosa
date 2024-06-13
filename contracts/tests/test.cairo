use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait};

use contracts::IMimosaSafeDispatcher;
use contracts::IMimosaSafeDispatcherTrait;
use contracts::IMimosaDispatcher;
use contracts::IMimosaDispatcherTrait;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_increase_balance() {
    let contract_address = deploy_contract("Mimosa");
// let dispatcher = IHelloStarknetDispatcher { contract_address };

// let balance_before = dispatcher.get_balance();
// assert(balance_before == 0, 'Invalid balance');

// dispatcher.increase_balance(42);

// let balance_after = dispatcher.get_balance();
// assert(balance_after == 42, 'Invalid balance');
}

