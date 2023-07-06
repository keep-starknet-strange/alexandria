use option::OptionTrait;
use starknet::ContractAddress;

#[starknet::interface]
trait IAListHolder<TContractState> {
    fn do_get_len(self: @TContractState) -> (u32, u32);
    fn do_is_empty(self: @TContractState) -> (bool, bool);
    fn do_append(
        ref self: TContractState, addrs_value: ContractAddress, numbers_value: u256
    ) -> (u32, u32);
    fn do_get(self: @TContractState, index: u32) -> (Option<ContractAddress>, Option<u256>);
    fn do_get_index(self: @TContractState, index: u32) -> (ContractAddress, u256);
    fn do_set(
        ref self: TContractState, index: u32, addrs_value: ContractAddress, numbers_value: u256
    );
    fn do_pop_front(ref self: TContractState) -> (Option<ContractAddress>, Option<u256>);
    fn do_array(self: @TContractState) -> (Array<ContractAddress>, Array<u256>);
}

#[starknet::contract]
mod AListHolder {
    use alexandria::storage::list::{List, ListTrait};
    use option::OptionTrait;
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

        fn do_get(self: @ContractState, index: u32) -> (Option<ContractAddress>, Option<u256>) {
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

        fn do_pop_front(ref self: ContractState) -> (Option<ContractAddress>, Option<u256>) {
            let mut a = self.addrs.read();
            let mut n = self.numbers.read();
            (a.pop_front(), n.pop_front())
        }

        fn do_array(self: @ContractState) -> (Array<ContractAddress>, Array<u256>) {
            let mut a = self.addrs.read();
            let mut n = self.numbers.read();
            (a.array(), n.array())
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

            let (some_addr, some_number) = contract.do_get(index);
            assert(some_addr.is_some(), 'addr is some');
            assert(some_addr.unwrap() == mock_addr, 'addr');
            assert(some_number.is_some(), 'number is some');
            assert(some_number.unwrap() == index.into(), 'number');

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
        assert(some_addr0.is_some(), 'addr0 is some');
        assert(some_addr0.unwrap() == mock_addr, 'addr0');
        assert(some_number0.is_some(), 'number0 is some');
        assert(some_number0.unwrap() == 100, 'number0');

        let (some_addr1, some_number1) = contract.do_get(1);
        assert(some_addr1.is_some(), 'addr1 is some');
        assert(some_addr1.unwrap() == mock_addr, 'addr1');
        assert(some_number1.is_some(), 'number1 is some');
        assert(some_number1.unwrap() == 200, 'number1');

        let (some_addr2, some_number2) = contract.do_get(2);
        assert(some_addr2.is_some(), 'addr2 is some');
        assert(some_addr2.unwrap() == mock_addr, 'addr2');
        assert(some_number2.is_some(), 'number2 is some');
        assert(some_number2.unwrap() == 300, 'number2');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_get_empty() {
        let contract = deploy_mock();
        let (addr, number) = contract.do_get(0);
        assert(addr.is_none(), 'addr is none');
        assert(number.is_none(), 'number is none');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_get_out_of_bounds() {
        let contract = deploy_mock();
        contract.do_append(mock_addr(), 10);
        let (addr, number) = contract.do_get(42);
        assert(addr.is_none(), 'addr is none');
        assert(number.is_none(), 'number is none');
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

        assert(contract.do_get_index(0) == (diff_addr, 100), 'new at 0');
        assert(contract.do_get_index(1) == (mock_addr, 20), 'old at 1');
        assert(contract.do_get_index(2) == (diff_addr, 300), 'new at 2');
        assert(contract.do_get_len() == (3, 3), 'len');
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

        assert(contract.do_get_len() == (3, 3), 'len');

        let (pop_addr, pop_number) = contract.do_pop_front();
        assert(pop_addr.is_some(), 'pop addr 2 is some');
        assert(pop_addr.unwrap() == mock_addr, 'addr 2');
        assert(pop_number.is_some(), 'pop number 2 is some');
        assert(pop_number.unwrap() == 300, 'number 2');
        assert(contract.do_get_len() == (2, 2), 'len');

        let (pop_addr, pop_number) = contract.do_pop_front();
        assert(pop_addr.is_some(), 'pop addr 1 is some');
        assert(pop_addr.unwrap() == mock_addr, 'addr 1');
        assert(pop_number.is_some(), 'pop number 1 is some');
        assert(pop_number.unwrap() == 200, 'number 1');
        assert(contract.do_get_len() == (1, 1), 'len');

        let (pop_addr, pop_number) = contract.do_pop_front();
        assert(pop_addr.is_some(), 'pop addr 0 is some');
        assert(pop_addr.unwrap() == mock_addr, 'addr 0');
        assert(pop_number.is_some(), 'pop number 0 is some');
        assert(pop_number.unwrap() == 100, 'number 0');
        assert(contract.do_get_len() == (0, 0), 'len');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_pop_front_empty() {
        let contract = deploy_mock();

        let (pop_addr, pop_number) = contract.do_pop_front();
        assert(pop_addr.is_none(), 'pop addr none');
        assert(pop_number.is_none(), 'pop number none');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_pop_append() {
        let contract = deploy_mock();
        // write something
        contract.do_append(mock_addr(), 10);
        assert(contract.do_get_len() == (1, 1), 'len 1');

        // pop it
        contract.do_pop_front();
        assert(contract.do_get_len() == (0, 0), 'len 2');

        let diff_addr = starknet::contract_address_const::<'bye'>();
        // append again and check if it overwrites
        contract.do_append(diff_addr, 9000);
        assert(contract.do_get_len() == (1, 1), 'len 3');
        let (addr, number) = contract.do_get_index(0);
        assert(addr == diff_addr, 'addr');
        assert(number == 9000, 'number');
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

        assert((array_addr.len(), array_number.len()) == contract.do_get_len(), 'lens mismatch');
        assert((*array_addr.at(0), *array_number.at(0)) == contract.do_get_index(0), 'idx 0');
        assert((*array_addr.at(1), *array_number.at(1)) == contract.do_get_index(1), 'idx 1');
        assert((*array_addr.at(2), *array_number.at(2)) == contract.do_get_index(2), 'idx 2');
    }

    #[test]
    #[available_gas(100000000)]
    fn test_array_empty() {
        let contract = deploy_mock();

        let (array_addr, array_number) = contract.do_array();
        assert((array_addr.len(), array_number.len()) == (0, 0), 'lens must be null');
    }
}
