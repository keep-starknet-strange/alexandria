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
    use snforge_std::{
        ContractClassTrait, DeclareResultTrait, EventSpyAssertionsTrait, declare, spy_events,
    };
    use super::{ISimpleStorageDispatcher, ISimpleStorageDispatcherTrait, SimpleStorage};

    fn deploy() -> ISimpleStorageDispatcher {
        let contract = declare("SimpleStorage").unwrap().contract_class();
        let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
        ISimpleStorageDispatcher { contract_address }
    }

    #[test]
    fn test_deploy() {
        let contract = deploy();
        assert!(contract.get() == 0);
    }

    #[test]
    fn test_set_and_get() {
        let contract = deploy();
        let mut spy = spy_events();

        contract.set(42);

        spy
            .assert_emitted(
                @array![
                    (
                        contract.contract_address,
                        SimpleStorage::Event::MyEventMacro(
                            SimpleStorage::MyEventMacro { data: array![42_u128.into()].span() },
                        ),
                    ),
                    (
                        contract.contract_address,
                        SimpleStorage::Event::MyEventMacro2(
                            SimpleStorage::MyEventMacro2 {
                                data: array![42_u128.into(), 10].span(),
                            },
                        ),
                    ),
                ],
            );

        assert!(contract.get() == 42);
    }
}
