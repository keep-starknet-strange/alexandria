use starknet::{ClassHash, ContractAddress, SyscallResult, SyscallResultTrait};

#[starknet::interface]
trait IByteArrayStorage<T> {
    fn get_b1(self: @T) -> ByteArray;
    fn set_b1(ref self: T, value: ByteArray);
    fn get_b2(self: @T) -> ByteArray;
    fn set_b2(ref self: T, value: ByteArray);
    fn get_map_value(self: @T, key: felt252) -> ByteArray;
    fn set_map_value(ref self: T, key: felt252, value: ByteArray);
    fn get_map_key(self: @T, key: ByteArray) -> felt252;
    fn set_map_key(ref self: T, key: ByteArray, value: felt252);
    fn health(self: @T) -> felt252;
}

#[starknet::contract]
mod byte_array_storage {
    use alexandria_storage::byte_array::{LegacyHashByteArray, StoreByteArray};

    #[storage]
    struct Storage {
        b1: ByteArray,
        b2: ByteArray,
        map_value: LegacyMap<felt252, ByteArray>,
        map_key: LegacyMap<ByteArray, felt252>,
    }

    #[external(v0)]
    impl ImplByteArrayStorage of super::IByteArrayStorage<ContractState> {
        fn get_b1(self: @ContractState) -> ByteArray {
            self.b1.read()
        }

        fn set_b1(ref self: ContractState, value: ByteArray) {
            self.b1.write(value);
        }

        fn get_b2(self: @ContractState) -> ByteArray {
            self.b2.read()
        }

        fn set_b2(ref self: ContractState, value: ByteArray) {
            self.b2.write(value);
        }

        fn get_map_value(self: @ContractState, key: felt252) -> ByteArray {
            self.map_value.read(key)
        }

        fn set_map_value(ref self: ContractState, key: felt252, value: ByteArray) {
            self.map_value.write(key, value);
        }

        fn get_map_key(self: @ContractState, key: ByteArray) -> felt252 {
            self.map_key.read(key)
        }

        fn set_map_key(ref self: ContractState, key: ByteArray, value: felt252) {
            self.map_key.write(key, value);
        }

        fn health(self: @ContractState) -> felt252 {
            0x42
        }
    }
}

fn deploy_mock() -> IByteArrayStorageDispatcher {
    let class_hash: ClassHash = byte_array_storage::TEST_CLASS_HASH.try_into().unwrap();
    let (addr, _) = starknet::deploy_syscall(class_hash, 0, array![].span(), false)
        .unwrap_syscall();

    IByteArrayStorageDispatcher { contract_address: addr }
}

// In the tests, b1 and b2 are always compared to ensure that the
// storage hashed key takes in account the base address.

#[test]
fn test_deploy() {
    let contract = deploy_mock();
    assert(contract.health() == 0x42, 'deploy');
}

#[test]
fn test_empty() {
    let contract = deploy_mock();

    let empty: ByteArray = "";
    assert_eq!(contract.get_b1(), empty, "b1 set/get failed");
    assert_eq!(contract.get_b2(), empty, "b1 set/get failed");
}

#[test]
fn test_pending_word_only() {
    let contract = deploy_mock();

    let b1 = "ABCD";

    contract.set_b1(b1.clone());

    let b1_storage = contract.get_b1();
    assert_eq!(b1, b1_storage, "b1 set/get failed");

    let b2_storage = contract.get_b2();
    assert!(b2_storage != b1_storage, "b1 b2 compare failed");

    contract.set_b2("B2");
    let b2_storage = contract.get_b2();
    assert_eq!(b2_storage, "B2", "b2 set/get failed");
}

#[test]
fn test_data_only() {
    let contract = deploy_mock();

    // 31 chars, exactly what's fit into the first data word.
    let b1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ12345";
    contract.set_b1(b1.clone());

    assert_eq!(contract.get_b1(), b1, "b1 set/get failed");
    assert!(contract.get_b2() != b1, "b1 b2 compare failed");
}

#[test]
fn test_data_only_multiple() {
    let contract = deploy_mock();

    let b1 =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345";
    contract.set_b1(b1.clone());

    assert_eq!(contract.get_b1(), b1, "b1 set/get failed");
    assert!(contract.get_b2() != b1, "b1 b2 compare failed");
}

#[test]
fn test_data_and_pending_word() {
    let contract = deploy_mock();

    let b1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCD";
    contract.set_b1(b1.clone());

    assert_eq!(contract.get_b1(), b1, "b1 set/get failed");
    assert!(contract.get_b2() != b1, "b1 b2 compare failed");
}

#[test]
fn test_data_and_pending_word_multiple() {
    let contract = deploy_mock();

    let b1 =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCD";
    contract.set_b1(b1.clone());

    assert_eq!(contract.get_b1(), b1, "b1 set/get failed");
    assert!(contract.get_b2() != b1, "b1 b2 compare failed");
}

#[test]
fn test_legacy_map_value() {
    let contract = deploy_mock();

    let b1 = "ABCD";
    let key1 = 'key_b1';
    contract.set_map_value(key1, b1.clone());
    assert_eq!(contract.get_map_value(key1), b1, "b1 set/get failed");

    let b2 =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345";
    let key2 = 'key_b2';
    contract.set_map_value(key2, b2.clone());
    assert_eq!(contract.get_map_value(key2), b2, "b2 set/get failed");

    let empty: ByteArray = "";
    contract.set_map_value(key1, empty.clone());
    contract.set_map_value(key2, empty.clone());

    assert_eq!(contract.get_map_value(key1), empty, "empty set b1 failed");
    assert_eq!(contract.get_map_value(key2), empty, "empty set b2 failed");
}

#[test]
fn test_legacy_map_key() {
    let contract = deploy_mock();

    let key1 = "ABCD";
    contract.set_map_key(key1.clone(), 0x42);
    assert_eq!(contract.get_map_key(key1), 0x42, "b1 set/get failed");

    let key2 =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345ABCDEFGHIJKLMNOPQRSTUVWXYZ12345";
    contract.set_map_key(key2.clone(), 0x1234);
    assert_eq!(contract.get_map_key(key2), 0x1234, "b2 set/get failed");

    let empty: ByteArray = "";
    contract.set_map_key(empty.clone(), 0x2222);
    assert_eq!(contract.get_map_key(empty.clone()), 0x2222, "empty set/get failed");

    contract.set_map_key(empty.clone(), 0x3333);
    assert_eq!(contract.get_map_key(empty.clone()), 0x3333, "empty set/get failed");
}
