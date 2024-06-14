#[starknet::contract]
mod Mimosa {
    use alexandria_merkle_tree::merkle_tree::HasherTrait;
    use alexandria_merkle_tree::merkle_tree::{Hasher, MerkleTree, poseidon::PoseidonHasherImpl, MerkleTreeTrait};
    use core::poseidon::hades_permutation;
    use starknet::{ContractAddress, contract_address_const, get_caller_address, get_contract_address};
    use contracts::interfaces::{IMimosa, IERC20Dispatcher, IERC20DispatcherTrait};

    const levels: felt252 = 4;
    const denomination: u256 = 100;
    const first_leaf_index: usize = 7;
    const last_leaf_index: usize = 14;
    const STRK_ADDRESS: felt252 = 0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d;

    #[storage]
    struct Storage {
        next_index: usize,
        // In a merkle tree of level 4, the nodes are stored in map with keys:
        //         0              <- level 0
        //    1          2        <- level 1
        //  3   4     5     6     <- level 2
        // 7 8 9 10 11 12 13 14   <- level 3
        nodes: LegacyMap<usize, felt252>, // index -> hash
        token_address: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        //let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
        init_zeros(ref self);
        self.next_index.write(first_leaf_index);

        // Local devnet STRK token address
        self.token_address.write(contract_address_const::<STRK_ADDRESS>());
    }

    #[abi(embed_v0)]
    impl MimosaImpl of IMimosa<ContractState> {
        fn deposit(ref self: ContractState, commitment: felt252) {
            let addr = self.token_address.read();
            IERC20Dispatcher { contract_address: addr }
                .transfer_from(get_caller_address(), get_contract_address(), denomination);
            // TODO: take token balance according to 'denomination'
            self.nodes.write(self.next_index.read(), commitment);
            self.next_index.write(self.next_index.read() + 1);
        }

        fn withdraw(ref self: ContractState, preimage: felt252) {
            let mut i: usize = first_leaf_index;
            let mut ok: bool = false;
            loop {
                if i == last_leaf_index + 1 {
                    break;
                }
                let (hash, _, _) = hades_permutation(preimage, 0, 1);
                if (self.nodes.read(i) == hash) {
                    // TODO: transfer balance according to 'denomination'
                    ok = true;
                }

                i += 1;
            };
            if (!ok) {
                panic!("Not found");
            }
        }
    }

    fn init_zeros(ref self: ContractState) {
        let (zero_hash_level_3, _, _) = hades_permutation(0, 0, 1);
        let (zero_hash_level_2, _, _) = hades_permutation(zero_hash_level_3, zero_hash_level_3, 2);
        let (zero_hash_level_1, _, _) = hades_permutation(zero_hash_level_2, zero_hash_level_2, 2);
        let (zero_hash_level_0, _, _) = hades_permutation(zero_hash_level_1, zero_hash_level_1, 2);

        self.nodes.write(0, zero_hash_level_0);

        self.nodes.write(1, zero_hash_level_1);
        self.nodes.write(2, zero_hash_level_1);

        self.nodes.write(3, zero_hash_level_2);
        self.nodes.write(4, zero_hash_level_2);
        self.nodes.write(5, zero_hash_level_2);
        self.nodes.write(6, zero_hash_level_2);

        self.nodes.write(7, zero_hash_level_3);
        self.nodes.write(8, zero_hash_level_3);
        self.nodes.write(9, zero_hash_level_3);
        self.nodes.write(10, zero_hash_level_3);
        self.nodes.write(11, zero_hash_level_3);
        self.nodes.write(12, zero_hash_level_3);
        self.nodes.write(13, zero_hash_level_3);
        self.nodes.write(14, zero_hash_level_3);
    }
}
