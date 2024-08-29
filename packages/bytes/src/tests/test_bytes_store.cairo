use alexandria_bytes::utils::{BytesDebug, BytesDisplay};
use alexandria_bytes::{Bytes, BytesTrait, BytesStore};
use snforge_std::{declare, DeclareResultTrait, ContractClassTrait};
use starknet::syscalls::deploy_syscall;
use starknet::{ClassHash, ContractAddress, SyscallResultTrait,};

#[starknet::interface]
pub(crate) trait IABytesStore<TContractState> {
    fn get_bytes(self: @TContractState) -> Bytes;
    fn set_bytes(ref self: TContractState, bytes: Bytes);
}


#[starknet::contract]
pub(crate) mod ABytesStore {
    use alexandria_bytes::{Bytes, BytesStore};

    #[storage]
    struct Storage {
        bytes: Bytes,
    }

    #[abi(embed_v0)]
    impl ABytesStoreImpl of super::IABytesStore<ContractState> {
        fn get_bytes(self: @ContractState) -> Bytes {
            self.bytes.read()
        }

        fn set_bytes(ref self: ContractState, bytes: Bytes) {
            self.bytes.write(bytes);
        }
    }
}

#[test]
fn test_deploy() {
    let contract = ABytesStore::contract_state_for_testing();
    assert_eq!(contract.get_bytes(), BytesTrait::new_empty());
}

#[test]
fn test_bytes_storage_32_bytes() {
    let mut contract = ABytesStore::contract_state_for_testing();
    let bytes = BytesTrait::new(32, array![0x01020304050607080910, 0x11121314151617181920]);
    contract.set_bytes(bytes.clone());
    assert_eq!(contract.get_bytes(), bytes);
}

#[test]
fn test_bytes_storage_40_bytes() {
    let mut contract = ABytesStore::contract_state_for_testing();
    let bytes = BytesTrait::new(
        40,
        array![0x01020304050607080910, 0x11121314151617181920, 0x21222324252627280000000000000000]
    );
    contract.set_bytes(bytes.clone());
    assert_eq!(contract.get_bytes(), bytes);
}
