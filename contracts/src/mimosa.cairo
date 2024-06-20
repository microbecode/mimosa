#[starknet::contract]
mod Mimosa {
    use alexandria_merkle_tree::merkle_tree::{
        Hasher, HasherTrait, MerkleTree, poseidon::PoseidonHasherImpl, MerkleTreeTrait
    };
    use contracts::interfaces::{IMimosa, IERC20Dispatcher, IERC20DispatcherTrait};
    use core::poseidon::hades_permutation;
    use starknet::{
        ContractAddress, contract_address_const, get_caller_address, get_contract_address
    };

    const denomination: u256 = 100;

    const levels: usize = 4;
    const first_leaf_index: usize = 7;
    const last_leaf_index: usize = 14;

    #[storage]
    struct Storage {
        next_index: usize,
        // In a merkle tree of level 4, the nodes are stored in map with keys:
        //         0              <- level 0
        //    1          2        <- level 1
        //  3   4     5     6     <- level 2
        // 7 8 9 10 11 12 13 14   <- level 3
        nodes: LegacyMap<usize, felt252>, // index -> hash
        token_address: IERC20Dispatcher
    }

    #[constructor]
    fn constructor(ref self: ContractState, token_address: ContractAddress) {
        init_zeros(ref self);
        self.next_index.write(first_leaf_index);
        self.token_address.write(IERC20Dispatcher { contract_address: token_address });
    }

    #[abi(embed_v0)]
    impl MimosaImpl of IMimosa<ContractState> {
        fn calculate_hash(self: @ContractState, preimage: felt252) -> felt252 {
            let (hash, _, _) = hades_permutation(preimage, 0, 1);
            hash
        }

        fn denomination(self: @ContractState) -> u256 {
            denomination
        }

        fn get_proof(self: @ContractState, mut index: u32) -> Span<felt252> {
            let mut nodes: Array<felt252> = array![];
            let mut i = 0;
            while (i <= last_leaf_index) {
                nodes.append(self.nodes.read(i));
                i = i + 1;
            };

            let mut proof: Array<felt252> = array![];

            while (index > 0) {
                if index % 2 == 1 {
                    proof.append(*nodes.at(index + 1));
                } else {
                    proof.append(*nodes.at(index - 1));
                }

                index = index / 2;
            };
            return proof.span();
        }

        fn deposit(ref self: ContractState, commitment: felt252) {
            insert(ref self, commitment);
            self
                .token_address
                .read()
                .transfer_from(get_caller_address(), get_contract_address(), denomination);
        }

        fn withdraw(ref self: ContractState, index: u32, proof: Span<felt252>, preimage: felt252) {
            let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeTrait::new();

            let (hash, _, _) = hades_permutation(preimage, 0, 1);
            let res = merkle_tree.verify(self.nodes.read(0), hash, proof);
            if (res) {
                self.token_address.read().transfer(get_caller_address(), denomination);
            }
        }
    }


    fn insert(ref self: ContractState, hash: felt252) {
        let mut current_index: usize = self.next_index.read();
        // println!("Inserting to index {}", current_index);
        let mut current_level_hash = hash;
        let mut left: felt252 = 0;
        let mut right: felt252 = 0;

        let mut level: usize = levels - 1;
        loop {
            if level == 0 {
                self.nodes.write(0, current_level_hash);
                break;
            }

            self.nodes.write(current_index, current_level_hash);
            // In a merkle tree of level 4, the nodes are stored in map with keys:
            //         0              <- level 0
            //    1          2        <- level 1
            //  3   4     5     6     <- level 2
            // 7 8 9 10 11 12 13 14   <- level 3

            if (current_index % 2 == 1) {
                //print!("left, ");
                left = current_level_hash;
                right = zero_hash(level);
                current_index /= 2;
            } else {
                //print!("right, ");
                left = self.nodes.read(current_index - 1); // get the left sibling
                right = current_level_hash;
                current_index = (current_index - 1) / 2;
            }
            // println!("next index {} {} {}", current_index, left, right);
            if Into::<felt252, u256>::into(left) < (right).into() {
                let (new_hash, _, _) = hades_permutation(left, right, 2);
                current_level_hash = new_hash;
            } else {
                let (new_hash, _, _) = hades_permutation(right, left, 2);
                current_level_hash = new_hash;
            }

            level -= 1;
        };
        //println!("root {}", self.nodes.read(0));
        self.next_index.write(self.next_index.read() + 1);
    }

    fn zero_hash(level: usize) -> felt252 {
        let (zero_hash_level_3, _, _) = hades_permutation(0, 0, 1);

        if (level == 3) {
            //println!("Zero hash level {} {}", level, zero_hash_level_3);
            return zero_hash_level_3;
        }
        let (zero_hash_level_2, _, _) = hades_permutation(zero_hash_level_3, zero_hash_level_3, 2);
        if (level == 2) {
            //println!("Zero hash level {} {}", level, zero_hash_level_2);
            return zero_hash_level_2;
        }
        let (zero_hash_level_1, _, _) = hades_permutation(zero_hash_level_2, zero_hash_level_2, 2);
        if (level == 1) {
            //println!("Zero hash level {} {}", level, zero_hash_level_1);
            return zero_hash_level_1;
        }
        let (zero_hash_level_0, _, _) = hades_permutation(zero_hash_level_1, zero_hash_level_1, 2);
        if (level == 0) {
            //println!("Zero hash level {} {}", level, zero_hash_level_0);
            return zero_hash_level_0;
        }

        panic!("Invalid level");
        0
    }

    fn init_zeros(ref self: ContractState) {
        let zero_hash_level_3 = zero_hash(3);
        let zero_hash_level_2 = zero_hash(2);
        let zero_hash_level_1 = zero_hash(1);
        let zero_hash_level_0 = zero_hash(0);

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
