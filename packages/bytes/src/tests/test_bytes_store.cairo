use alexandria_bytes::Bytes;

#[starknet::interface]
trait IABytesStore<TContractState> {
    fn get_bytes(self: @TContractState) -> Bytes;
    fn set_bytes(ref self: TContractState, bytes: Bytes);
}

#[starknet::contract]
mod ABytesStore {
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

#[cfg(test)]
mod tests {
    use alexandria_bytes::utils::{BytesDebug, BytesDisplay};
    use alexandria_bytes::{Bytes, BytesTrait, BytesStore};
    use starknet::syscalls::deploy_syscall;
    use starknet::{ClassHash, ContractAddress, SyscallResultTrait,};
    use super::{ABytesStore, IABytesStoreDispatcher, IABytesStoreDispatcherTrait};

    fn deploy() -> IABytesStoreDispatcher {
        let class_hash: ClassHash = ABytesStore::TEST_CLASS_HASH.try_into().unwrap();
        let ctor_data: Array<felt252> = Default::default();
        let (addr, _) = deploy_syscall(class_hash, 0, ctor_data.span(), false).unwrap_syscall();
        IABytesStoreDispatcher { contract_address: addr }
    }

    #[test]
    fn test_deploy() {
        let contract = deploy();
        assert_eq!(contract.get_bytes(), BytesTrait::new_empty());
    }

    #[test]
    fn test_bytes_storage_32_bytes() {
        let contract = deploy();
        let bytes = BytesTrait::new(32, array![0x01020304050607080910, 0x11121314151617181920]);
        contract.set_bytes(bytes.clone());
        assert_eq!(contract.get_bytes(), bytes);
    }

    #[test]
    fn test_bytes_storage_40_bytes() {
        let contract = deploy();
        let bytes = BytesTrait::new(
            40,
            array![
                0x01020304050607080910, 0x11121314151617181920, 0x21222324252627280000000000000000
            ]
        );
        contract.set_bytes(bytes.clone());
        assert_eq!(contract.get_bytes(), bytes);
    }
}
