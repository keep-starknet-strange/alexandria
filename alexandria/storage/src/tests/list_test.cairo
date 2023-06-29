use starknet::ContractAddress;

#[starknet::interface]
trait IAListHolder<TContractState> {
    fn do_get_len(self: @TContractState) -> (u32, u32);
    fn do_is_empty(self: @TContractState) -> (bool, bool);
    fn do_append(
        ref self: TContractState, addrs_value: ContractAddress, numbers_value: u256
    ) -> (u32, u32);
    fn do_get(self: @TContractState, index: u32) -> (ContractAddress, u256);
    fn do_get_index(self: @TContractState, index: u32) -> (ContractAddress, u256);
    fn do_set(
        ref self: TContractState, index: u32, addrs_value: ContractAddress, numbers_value: u256
    );
}

#[starknet::contract]
mod AListHolder {
    use alexandria_storage::list::{List, ListTrait};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        // to test a corelib type that has StorageAccess and
        // Into<ContractAddress, felt252>
        addrs: List<ContractAddress>,
        // to test a corelib compound struct
        numbers: List<u256>
    }

    #[external(v0)]
    impl Holder of super::IAListHolder<ContractState> {
        fn do_get_len(self: @ContractState) -> (u32, u32) {
            (self.addrs.read().len(), self.numbers.read().len())
        }

        fn do_is_empty(self: @ContractState) -> (bool, bool) {
            (self.addrs.read().is_empty(), self.numbers.read().is_empty())
        }

        fn do_append(
            ref self: ContractState, addrs_value: ContractAddress, numbers_value: u256
        ) -> (u32, u32) {
            let mut a = self.addrs.read();
            let mut n = self.numbers.read();
            (a.append(addrs_value), n.append(numbers_value))
        }

        fn do_get(self: @ContractState, index: u32) -> (ContractAddress, u256) {
            (self.addrs.read().get(index), self.numbers.read().get(index))
        }

        fn do_get_index(self: @ContractState, index: u32) -> (ContractAddress, u256) {
            (self.addrs.read()[index], self.numbers.read()[index])
        }

        fn do_set(
            ref self: ContractState, index: u32, addrs_value: ContractAddress, numbers_value: u256
        ) {
            let mut a = self.addrs.read();
            let mut n = self.numbers.read();
            a.set(index, addrs_value);
            n.set(index, numbers_value);
        }
    }
}

#[cft(test)]
mod tests {
    use array::{ArrayTrait, SpanTrait};
    use debug::PrintTrait;
    use option::OptionTrait;
    use starknet::{ClassHash, ContractAddress, deploy_syscall, SyscallResultTrait};
    use traits::{Default, Into, TryInto};

    use super::{AListHolder, IAListHolderDispatcher, IAListHolderDispatcherTrait};

    // so that we're able to compare 2-tuples in the test code
    impl TupleSize2PartialEq<
        E0, E1, impl E0PartialEq: PartialEq<E0>, impl E1PartialEq: PartialEq<E1>
    > of PartialEq<(E0, E1)> {
        #[inline(always)]
        fn eq(lhs: @(E0, E1), rhs: @(E0, E1)) -> bool {
            let (lhs0, lhs1) = lhs;
            let (rhs0, rhs1) = rhs;
            (lhs0 == rhs0) & (lhs1 == rhs1)
        }
        #[inline(always)]
        fn ne(lhs: @(E0, E1), rhs: @(E0, E1)) -> bool {
            !(rhs == lhs)
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
        assert(contract.do_get_len() == (0, 0), 'do_get_len');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_is_empty() {
        let contract = deploy_mock();

        assert(contract.do_is_empty() == (true, true), 'is empty');
        contract.do_append(mock_addr(), 1337);
        assert(contract.do_is_empty() == (false, false), 'is not empty');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_append_few() {
        let contract = deploy_mock();

        assert(contract.do_append(mock_addr(), 10) == (0, 0), '1st append idx');
        assert(contract.do_append(mock_addr(), 20) == (1, 1), '2nd append idx');
        assert(contract.do_get_len() == (2, 2), 'len');
    }

    #[test]
    #[available_gas(100000000000)]
    fn test_append_get_many() {
        let contract = deploy_mock();
        let mock_addr = mock_addr();

        let mut index: u32 = 0;
        let max: u32 = 1025;

        // test appending many
        loop {
            if index == max {
                break;
            }

            let append_indexes = contract.do_append(mock_addr, index.into());
            assert(append_indexes == (index, index), index.into());
            index += 1;
        };

        assert(contract.do_get_len() == (max, max), 'len');

        // test getting many
        index = 0;
        loop {
            if index == max {
                break;
            }
            assert(contract.do_get(index) == (mock_addr, index.into()), index.into());
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

        assert(contract.do_get(0) == (mock_addr, 100), 'idx 0');
        assert(contract.do_get(1) == (mock_addr, 200), 'idx 1');
        assert(contract.do_get(2) == (mock_addr, 300), 'idx 2');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_get_index_pass() {
        let contract = deploy_mock();
        let mock_addr = mock_addr();

        contract.do_append(mock_addr, 100); // idx 0
        contract.do_append(mock_addr, 200); // idx 1
        contract.do_append(mock_addr, 300); // idx 2

        assert(contract.do_get_index(0) == (mock_addr, 100), 'idx 0');
        assert(contract.do_get_index(1) == (mock_addr, 200), 'idx 1');
        assert(contract.do_get_index(2) == (mock_addr, 300), 'idx 2');
    }

    #[test]
    #[available_gas(100000000)]
    #[should_panic(expected: ('index out of bounds', 'ENTRYPOINT_FAILED'))]
    fn test_get_out_of_bounds() {
        let contract = deploy_mock();
        contract.do_append(mock_addr(), 10);
        contract.do_get(10);
    }

    #[test]
    #[available_gas(100000000)]
    #[should_panic(expected: ('index out of bounds', 'ENTRYPOINT_FAILED'))]
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

        assert(contract.do_get(0) == (diff_addr, 100), 'new at 0');
        assert(contract.do_get(1) == (mock_addr, 20), 'old at 1');
        assert(contract.do_get(2) == (diff_addr, 300), 'new at 2');
        assert(contract.do_get_len() == (3, 3), 'len');
    }

    #[test]
    #[available_gas(100000000)]
    #[should_panic(expected: ('index out of bounds', 'ENTRYPOINT_FAILED'))]
    fn test_set_out_of_bounds() {
        let contract = deploy_mock();
        contract.do_set(2, mock_addr(), 20);
    }
}
