use starknet::ContractAddress;

#[starknet::interface]
pub trait IMimosa<TContractState> {
    fn calculate_hash(self: @TContractState, preimage: felt252) -> felt252;
    fn denomination(self: @TContractState) -> u256;
    fn get_proof(self: @TContractState, index: u32) -> Span<felt252>;

    fn deposit(ref self: TContractState, commitment: felt252);
    fn withdraw(ref self: TContractState, index: u32, proof: Span<felt252>, preimage: felt252);
}

#[starknet::interface]
pub trait IERC20<TContractState> {
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
