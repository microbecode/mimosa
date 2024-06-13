#[starknet::interface]
pub trait IMimosa<TContractState> {
    fn deposit(ref self: TContractState);
//fn get_balance(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod Mimosa {
    use alexandria_merkle_tree::merkle_tree::{
        Hasher, MerkleTree, pedersen::PedersenHasherImpl, MerkleTreeTrait
    };

    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[abi(embed_v0)]
    impl MimosaImpl of super::IMimosa<ContractState> {
        fn deposit(ref self: ContractState) {
            let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
        }
    // fn increase_balance(ref self: ContractState, amount: felt252) {
    //     assert(amount != 0, 'Amount cannot be 0');
    //     self.balance.write(self.balance.read() + amount);
    // }

    // fn get_balance(self: @ContractState) -> felt252 {
    //     self.balance.read()
    // }
    }
}
