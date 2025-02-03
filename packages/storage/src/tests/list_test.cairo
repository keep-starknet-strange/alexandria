use alexandria_storage::ListTrait;
use core::starknet::storage::StorageAsPointer;
use starknet::storage_access::{
    StorageBaseAddress, storage_address_from_base, storage_base_address_from_felt252,
};
use starknet::syscalls::deploy_syscall;
use starknet::{ClassHash, ContractAddress, SyscallResultTrait};

#[starknet::interface]
trait IAListHolder<TContractState> {
    fn do_get_len(self: @TContractState) -> (u32, u32);
    fn do_is_empty(self: @TContractState) -> (bool, bool);
    fn do_append(
        ref self: TContractState, addrs_value: ContractAddress, numbers_value: u256,
    ) -> (u32, u32);
    fn do_get(self: @TContractState, index: u32) -> (Option<ContractAddress>, Option<u256>);
    fn do_get_index(self: @TContractState, index: u32) -> (ContractAddress, u256);
    fn do_set(
        ref self: TContractState, index: u32, addrs_value: ContractAddress, numbers_value: u256,
    );
    fn do_clean(ref self: TContractState);
    fn do_pop_front(ref self: TContractState) -> (Option<ContractAddress>, Option<u256>);
    fn do_array(self: @TContractState) -> (Array<ContractAddress>, Array<u256>);
    fn do_append_span(
        ref self: TContractState, addrs_array: Array<ContractAddress>, numbers_array: Array<u256>,
    );
}

#[starknet::contract]
mod AListHolder {
    use alexandria_storage::{List, ListTrait};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        // to test a corelib type that has Store and
        // Into<ContractAddress, felt252>
        addresses: List<ContractAddress>,
        // to test a corelib compound struct
        numbers: List<u256>,
    }

    #[abi(embed_v0)]
    impl Holder of super::IAListHolder<ContractState> {
        fn do_get_len(self: @ContractState) -> (u32, u32) {
            (self.addresses.read().len(), self.numbers.read().len())
        }

        fn do_is_empty(self: @ContractState) -> (bool, bool) {
            (self.addresses.read().is_empty(), self.numbers.read().is_empty())
        }

        fn do_append(
            ref self: ContractState, addrs_value: ContractAddress, numbers_value: u256,
        ) -> (u32, u32) {
            let mut a = self.addresses.read();
            let mut n = self.numbers.read();
            (
                a.append(addrs_value).expect('syscallresult error'),
                n.append(numbers_value).expect('syscallresult error'),
            )
        }

        fn do_get(self: @ContractState, index: u32) -> (Option<ContractAddress>, Option<u256>) {
            (
                self.addresses.read().get(index).expect('syscallresult error'),
                self.numbers.read().get(index).expect('syscallresult error'),
            )
        }

        fn do_get_index(self: @ContractState, index: u32) -> (ContractAddress, u256) {
            (self.addresses.read()[index], self.numbers.read()[index])
        }

        fn do_set(
            ref self: ContractState, index: u32, addrs_value: ContractAddress, numbers_value: u256,
        ) {
            let mut a = self.addresses.read();
            let mut n = self.numbers.read();
            let _ = a.set(index, addrs_value);
            let _ = n.set(index, numbers_value);
        }

        fn do_clean(ref self: ContractState) {
            let mut a = self.addresses.read();
            let mut n = self.numbers.read();
            a.clean();
            n.clean();
        }

        fn do_pop_front(ref self: ContractState) -> (Option<ContractAddress>, Option<u256>) {
            let mut a = self.addresses.read();
            let mut n = self.numbers.read();
            (
                a.pop_front().expect('syscallresult error'),
                n.pop_front().expect('syscallresult error'),
            )
        }

        fn do_array(self: @ContractState) -> (Array<ContractAddress>, Array<u256>) {
            let mut a = self.addresses.read();
            let mut n = self.numbers.read();
            (a.array().expect('syscallresult error'), n.array().expect('syscallresult error'))
        }

        fn do_append_span(
            ref self: ContractState,
            addrs_array: Array<ContractAddress>,
            numbers_array: Array<u256>,
        ) {
            let mut a = self.addresses.read();
            let mut n = self.numbers.read();
            a.append_span(addrs_array.span()).expect('syscallresult error');
            n.append_span(numbers_array.span()).expect('syscallresult error');
        }
    }
}

impl StorageBaseAddressPartialEq of PartialEq<StorageBaseAddress> {
    fn eq(lhs: @StorageBaseAddress, rhs: @StorageBaseAddress) -> bool {
        let left: felt252 = storage_address_from_base(*lhs).into();
        left == storage_address_from_base(*rhs).into()
    }

    fn ne(lhs: @StorageBaseAddress, rhs: @StorageBaseAddress) -> bool {
        !Self::eq(lhs, rhs)
    }
}

fn deploy_mock() -> IAListHolderDispatcher {
    let class_hash: ClassHash = AListHolder::TEST_CLASS_HASH.try_into().unwrap();
    let ctor_data: Array<felt252> = Default::default();
    let (addr, _) = deploy_syscall(class_hash, 0, ctor_data.span(), false).unwrap_syscall();
    IAListHolderDispatcher { contract_address: addr }
}

fn mock_addr() -> ContractAddress {
    starknet::contract_address_const::<'hello'>()
}

#[test]
#[available_gas(100000000)]
fn test_deploy() {
    let contract = deploy_mock();
    assert_eq!(contract.do_get_len(), (0, 0));
}

#[test]
#[available_gas(100000000)]
fn test_new_initializes_empty_list() {
    let mut contract_state = AListHolder::contract_state_for_testing();

    let addresses_address = contract_state.addresses.as_ptr().__storage_pointer_address__;
    let addresses_list = ListTrait::<ContractAddress>::new(0, addresses_address);
    assert_eq!(addresses_list.address_domain, 0);
    assert_eq!(addresses_list.len(), 0);
    assert_eq!(addresses_list.base.into(), addresses_address);
    assert_eq!(addresses_list.storage_size(), 1);

    let numbers_address = contract_state.numbers.as_ptr().__storage_pointer_address__;
    let numbers_list = ListTrait::<u256>::new(0, numbers_address);
    assert_eq!(numbers_list.address_domain, 0);
    assert_eq!(numbers_list.len(), 0);
    assert_eq!(numbers_list.base.into(), numbers_address);
    assert_eq!(numbers_list.storage_size(), 2);

    // Check if both addresses and numbers lists are initialized to be empty
    assert_eq!(contract_state.do_get_len(), (0, 0));
    assert_eq!(contract_state.do_is_empty(), (true, true));
}

#[test]
#[available_gas(100000000)]
fn test_new_then_fill_list() {
    let mut contract_state = AListHolder::contract_state_for_testing();

    let addresses_address = contract_state.addresses.as_ptr().__storage_pointer_address__;
    let mut addresses_list = ListTrait::<ContractAddress>::new(0, addresses_address);

    let numbers_address = contract_state.numbers.as_ptr().__storage_pointer_address__;
    let mut numbers_list = ListTrait::<u256>::new(0, numbers_address);

    let _ = addresses_list.append(mock_addr());
    let _ = numbers_list.append(1);
    let _ = numbers_list.append(2);

    assert_eq!(addresses_list.len(), 1);
    assert_eq!(numbers_list.len(), 2);

    assert_eq!(contract_state.do_get_len(), (1, 2));
    assert_eq!(contract_state.do_is_empty(), (false, false));
}

#[test]
#[available_gas(100000000)]
fn test_fetch_empty_list() {
    let storage_address = storage_base_address_from_felt252('empty_address');

    let empty_list = ListTrait::<u128>::fetch(0, storage_address).expect('List fetch failed');

    assert_eq!(empty_list.address_domain, 0);
    assert_eq!(empty_list.len(), 0);
    assert_eq!(empty_list.base.into(), storage_address);
    assert_eq!(empty_list.storage_size(), 1);
}

#[test]
#[available_gas(100000000)]
fn test_fetch_existing_list() {
    let mut contract_state = AListHolder::contract_state_for_testing();
    let mock_addr = mock_addr();

    assert_eq!(contract_state.do_append(mock_addr, 10), (0, 0));
    assert_eq!(contract_state.do_append(mock_addr, 20), (1, 1));

    let addresses_address = contract_state.addresses.as_ptr().__storage_pointer_address__;
    let addresses_list = ListTrait::<ContractAddress>::fetch(0, addresses_address)
        .expect('List fetch failed');
    assert_eq!(addresses_list.address_domain, 0);
    assert_eq!(addresses_list.len(), 2);
    assert_eq!(addresses_list.base.into(), addresses_address);
    assert_eq!(addresses_list.storage_size(), 1);

    let numbers_address = contract_state.numbers.as_ptr().__storage_pointer_address__;
    let numbers_list = ListTrait::<u256>::fetch(0, numbers_address).expect('List fetch failed');
    assert_eq!(numbers_list.address_domain, 0);
    assert_eq!(numbers_list.len(), 2);
    assert_eq!(numbers_list.base.into(), numbers_address);
}

#[test]
#[available_gas(100000000)]
fn test_is_empty() {
    let contract = deploy_mock();

    assert_eq!(contract.do_is_empty(), (true, true));
    contract.do_append(mock_addr(), 1337);
    assert_eq!(contract.do_is_empty(), (false, false));
}

#[test]
#[available_gas(100000000)]
fn test_append_few() {
    let contract = deploy_mock();

    assert_eq!(contract.do_append(mock_addr(), 10), (0, 0));
    assert_eq!(contract.do_append(mock_addr(), 20), (1, 1));
    assert_eq!(contract.do_get_len(), (2, 2));
}

#[test]
#[available_gas(100000000000)]
fn test_append_get_many() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    let mut index: u32 = 0;
    let max: u32 = 513;

    // test appending many
    while (index != max) {
        let append_indexes = contract.do_append(mock_addr, index.into());
        assert_eq!(append_indexes, (index, index));
        index += 1;
    }

    assert_eq!(contract.do_get_len(), (max, max));

    // test getting many
    index = 0;
    while (index != max) {
        let (some_addr, some_number) = contract.do_get(index);
        assert!(some_addr.is_some(), "addr is some");
        assert_eq!(some_addr.unwrap(), mock_addr);
        assert!(some_number.is_some(), "number is some");
        assert_eq!(some_number.unwrap(), index.into());

        index += 1;
    }
}

#[test]
#[available_gas(100000000)]
fn test_get_pass() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    contract.do_append(mock_addr, 100); // idx 0
    contract.do_append(mock_addr, 200); // idx 1
    contract.do_append(mock_addr, 300); // idx 2

    let (some_addr0, some_number0) = contract.do_get(0);
    assert!(some_addr0.is_some(), "addr0 is some");
    assert_eq!(some_addr0.unwrap(), mock_addr);
    assert!(some_number0.is_some(), "number0 is some");
    assert_eq!(some_number0.unwrap(), 100);

    let (some_addr1, some_number1) = contract.do_get(1);
    assert!(some_addr1.is_some(), "addr1 is some");
    assert_eq!(some_addr1.unwrap(), mock_addr);
    assert!(some_number1.is_some(), "number1 is some");
    assert_eq!(some_number1.unwrap(), 200);

    let (some_addr2, some_number2) = contract.do_get(2);
    assert!(some_addr2.is_some(), "addr2 is some");
    assert_eq!(some_addr2.unwrap(), mock_addr);
    assert!(some_number2.is_some(), "number2 is some");
    assert_eq!(some_number2.unwrap(), 300);
}

#[test]
#[available_gas(100000000)]
fn test_get_empty() {
    let contract = deploy_mock();
    let (addr, number) = contract.do_get(0);
    assert!(addr.is_none(), "addr is none");
    assert!(number.is_none(), "number is none");
}

#[test]
#[available_gas(100000000)]
fn test_get_out_of_bounds() {
    let contract = deploy_mock();
    contract.do_append(mock_addr(), 10);
    let (addr, number) = contract.do_get(42);
    assert!(addr.is_none(), "addr is none");
    assert!(number.is_none(), "number is none");
}

#[test]
#[available_gas(100000000)]
fn test_get_index_pass() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    contract.do_append(mock_addr, 100); // idx 0
    contract.do_append(mock_addr, 200); // idx 1
    contract.do_append(mock_addr, 300); // idx 2

    assert_eq!(contract.do_get_index(0), (mock_addr, 100));
    assert_eq!(contract.do_get_index(1), (mock_addr, 200));
    assert_eq!(contract.do_get_index(2), (mock_addr, 300));
}

#[test]
#[available_gas(100000000)]
#[should_panic(expected: ('List index out of bounds', 'ENTRYPOINT_FAILED'))]
fn test_get_index_out_of_bounds() {
    let contract = deploy_mock();
    contract.do_append(mock_addr(), 10);
    contract.do_get_index(10);
}

#[test]
#[available_gas(100000000)]
fn test_set_pass() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();
    let diff_addr = starknet::contract_address_const::<'bye'>();

    contract.do_append(mock_addr, 10);
    contract.do_append(mock_addr, 20);
    contract.do_append(mock_addr, 30);

    contract.do_set(0, diff_addr, 100);
    contract.do_set(2, diff_addr, 300);

    assert_eq!(contract.do_get_index(0), (diff_addr, 100));
    assert_eq!(contract.do_get_index(1), (mock_addr, 20));
    assert_eq!(contract.do_get_index(2), (diff_addr, 300));
    assert_eq!(contract.do_get_len(), (3, 3));
}

#[test]
#[available_gas(100000000)]
#[should_panic(expected: ('List index out of bounds', 'ENTRYPOINT_FAILED'))]
fn test_set_out_of_bounds() {
    let contract = deploy_mock();
    contract.do_set(2, mock_addr(), 20);
}

#[test]
#[available_gas(100000000)]
fn test_pop_front_pass() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    contract.do_append(mock_addr, 100); // idx 0
    contract.do_append(mock_addr, 200); // idx 1
    contract.do_append(mock_addr, 300); // idx 2

    assert_eq!(contract.do_get_len(), (3, 3));

    let (pop_addr, pop_number) = contract.do_pop_front();
    assert!(pop_addr.is_some(), "pop addr 2 is some");
    assert_eq!(pop_addr.unwrap(), mock_addr);
    assert!(pop_number.is_some(), "pop number 2 is some");
    assert_eq!(pop_number.unwrap(), 300);
    assert_eq!(contract.do_get_len(), (2, 2));

    let (pop_addr, pop_number) = contract.do_pop_front();
    assert!(pop_addr.is_some(), "pop addr 1 is some");
    assert_eq!(pop_addr.unwrap(), mock_addr);
    assert!(pop_number.is_some(), "pop number 1 is some");
    assert_eq!(pop_number.unwrap(), 200);
    assert_eq!(contract.do_get_len(), (1, 1));

    let (pop_addr, pop_number) = contract.do_pop_front();
    assert!(pop_addr.is_some(), "pop addr 0 is some");
    assert_eq!(pop_addr.unwrap(), mock_addr);
    assert!(pop_number.is_some(), "pop number 0 is some");
    assert_eq!(pop_number.unwrap(), 100);
    assert_eq!(contract.do_get_len(), (0, 0));
}

#[test]
#[available_gas(100000000)]
fn test_pop_front_empty() {
    let contract = deploy_mock();

    let (pop_addr, pop_number) = contract.do_pop_front();
    assert!(pop_addr.is_none(), "pop addr none");
    assert!(pop_number.is_none(), "pop number none");
}

#[test]
#[available_gas(100000000)]
fn test_pop_append() {
    let contract = deploy_mock();
    // write something
    contract.do_append(mock_addr(), 10);
    assert_eq!(contract.do_get_len(), (1, 1));

    // pop it
    contract.do_pop_front();
    assert_eq!(contract.do_get_len(), (0, 0));

    let diff_addr = starknet::contract_address_const::<'bye'>();
    // append again and check if it overwrites
    contract.do_append(diff_addr, 9000);
    assert_eq!(contract.do_get_len(), (1, 1));
    let (addr, number) = contract.do_get_index(0);
    assert_eq!(addr, diff_addr);
    assert_eq!(number, 9000);
}

#[test]
#[available_gas(100000000)]
fn test_array_pass() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    contract.do_append(mock_addr, 100); // idx 0
    contract.do_append(mock_addr, 200); // idx 1
    contract.do_append(mock_addr, 300); // idx 2

    let (array_addr, array_number) = contract.do_array();

    assert_eq!((array_addr.len(), array_number.len()), contract.do_get_len());
    assert_eq!((*array_addr[0], *array_number[0]), contract.do_get_index(0));
    assert_eq!((*array_addr[1], *array_number[1]), contract.do_get_index(1));
    assert_eq!((*array_addr[2], *array_number[2]), contract.do_get_index(2));
}

#[test]
#[available_gas(100000000)]
fn test_array_empty() {
    let contract = deploy_mock();

    let (array_addr, array_number) = contract.do_array();
    assert_eq!((array_addr.len(), array_number.len()), (0, 0));
}

#[test]
#[available_gas(100000000)]
fn test_array_clean() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    contract.do_append(mock_addr, 100); // idx 0
    contract.do_append(mock_addr, 200); // idx 1
    contract.do_append(mock_addr, 300); // idx 2
    contract.do_clean();
    assert_eq!(contract.do_get_len(), (0, 0));
}

#[test]
#[available_gas(100000000)]
fn test_array_clean_with_empty_array() {
    let contract = deploy_mock();

    assert_eq!(contract.do_get_len(), (0, 0));

    contract.do_clean();

    assert_eq!(contract.do_get_len(), (0, 0));
}

#[test]
#[available_gas(100000000)]
fn test_array_get_value_after_clean() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    contract.do_append(mock_addr, 100); // idx 0
    let (addr, number) = contract.do_get(0);
    assert!(addr.is_some(), "addr is some");
    assert_eq!(addr.unwrap(), mock_addr);
    assert!(number.is_some(), "number is some");
    assert_eq!(number.unwrap(), 100);

    contract.do_clean();

    assert_eq!(contract.do_get_len(), (0, 0));

    let (addr, number) = contract.do_get(0);
    assert!(addr.is_none(), "addr is none");
    assert!(number.is_none(), "number is none");
}

#[test]
#[available_gas(100000000)]
fn test_append_array_empty() {
    let contract = deploy_mock();

    contract.do_append_span(array![], array![]);
    assert_eq!(contract.do_is_empty(), (true, true));
}

#[test]
#[available_gas(100000000)]
fn test_append_span_existing_list() {
    let contract = deploy_mock();
    let mock_addr = mock_addr();

    assert_eq!(contract.do_append(mock_addr, 10), (0, 0));
    assert_eq!(contract.do_append(mock_addr, 20), (1, 1));
    assert_eq!(contract.do_get_len(), (2, 2));
    assert_eq!(contract.do_get_index(0), (mock_addr, 10));
    assert_eq!(contract.do_get_index(1), (mock_addr, 20));

    contract.do_append_span(array![mock_addr], array![30]);
    let (a, b) = contract.do_get_len();
    assert_eq!((a, b), (3, 3));

    assert_eq!(contract.do_get_index(0), (mock_addr, 10));
    assert_eq!(contract.do_get_index(1), (mock_addr, 20));
    assert_eq!(contract.do_get_index(2), (mock_addr, 30));
}
