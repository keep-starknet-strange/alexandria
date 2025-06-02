#[starknet::interface]
trait ISimpleStorage<TContractState> {
    fn set(ref self: TContractState, x: u128);
    fn get(self: @TContractState) -> u128;
}

#[starknet::contract]
mod SimpleStorage {
    use starknet::event::EventEmitter;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[generate_events]
    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        MyEventMacro: MyEventMacro,
        MyEventMacro2: MyEventMacro2,
    }

    #[storage]
    struct Storage {
        stored_data: u128,
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn set(ref self: ContractState, x: u128) {
            self.stored_data.write(x);

            self.emit(MyEventMacro { data: array![x.into()].span() });
            self.emit(MyEventMacro2 { data: array![x.into(), 10].span() });
        }

        fn get(self: @ContractState) -> u128 {
            self.stored_data.read()
        }
    }
}

#[cfg(test)]
mod tests {
    use starknet::syscalls::deploy_syscall;
    use starknet::testing::pop_log_raw;
    use starknet::{ClassHash, SyscallResultTrait};
    use super::{ISimpleStorageDispatcher, ISimpleStorageDispatcherTrait, SimpleStorage};

    fn deploy() -> ISimpleStorageDispatcher {
        let class_hash: ClassHash = SimpleStorage::TEST_CLASS_HASH.try_into().unwrap();
        let ctor_data: Array<felt252> = Default::default();
        let (addr, _) = deploy_syscall(class_hash, 0, ctor_data.span(), false).unwrap_syscall();
        ISimpleStorageDispatcher { contract_address: addr }
    }

    #[test]
    fn test_deploy() {
        let contract = deploy();
        assert_eq!(contract.get(), 0);
    }

    #[test]
    fn test_set_and_get() {
        let contract = deploy();
        contract.set(42);
        // Get the emitted events
        let (keys1, data1) = pop_log_raw(contract.contract_address).unwrap();
        assert_eq!(*keys1[0], selector!("MyEventMacro"), "Wrong event");
        assert_eq!(data1.len(), 2, "First event should have 1 data item");
        assert_eq!(*data1[1], 42_u128.into(), "First event data should be 42");

        let (keys2, data2) = pop_log_raw(contract.contract_address).unwrap();
        assert_eq!(*keys2[0], selector!("MyEventMacro2"), "Wrong event");
        assert_eq!(data2.len(), 3, "Second event should have 3 data items");
        assert_eq!(*data2[1], 42, "First event data should be 42");
        assert_eq!(*data2[2], 10, "Second event data should be 10");

        assert_eq!(contract.get(), 42);
    }
}
