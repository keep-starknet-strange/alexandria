use alexandria_data_structures::byte_appender::ByteAppender;
use alexandria_data_structures::byte_reader::ByteReader;
use alexandria_data_structures::list_ext::{ListU8ByteAppenderImpl, ListU8ReaderImpl};
use alexandria_storage::list::ListTrait;
use alexandria_storage::tests::list_test::tests::{deploy_mock};
use alexandria_storage::tests::list_test::{
    AListHolder, AListHolder::numbersContractMemberStateTrait
};
use integer::BoundedInt;
use starknet::testing::set_contract_address;

#[test]
#[available_gas(20000000)]
fn list_append_read() {
    let contract = deploy_mock();
    set_contract_address(contract.contract_address);
    let mut contract_state = AListHolder::unsafe_new_contract_state();
    let numbers_address = contract_state.numbers.address();
    let mut list = ListTrait::<u8>::new(0, numbers_address);
    list.append_i8(BoundedInt::min() + 1);
    list.append_i16(BoundedInt::min() + 2);
    list.append_i32(BoundedInt::min() + 3);
    list.append_i64(BoundedInt::min() + 4);
    list.append_i128(BoundedInt::min() + 5);
    list.append_u16(BoundedInt::max() - 1);
    list.append_u32(BoundedInt::max() - 2);
    list.append_u64(BoundedInt::max() - 3);
    list.append_u128(BoundedInt::max() - 4);
    list.append_u256(BoundedInt::max() - 5);

    let mut reader = list.reader();
    assert(reader.read_i8().unwrap() == BoundedInt::min() + 1, 'test fail');
    assert(reader.read_i16().unwrap() == BoundedInt::min() + 2, 'test fail');
    assert(reader.read_i32().unwrap() == BoundedInt::min() + 3, 'test fail');
    assert(reader.read_i64().unwrap() == BoundedInt::min() + 4, 'test fail');
    assert(reader.read_i128().unwrap() == BoundedInt::min() + 5, 'test fail');
    assert(reader.read_u16().unwrap() == BoundedInt::max() - 1, 'test fail');
    assert(reader.read_u32().unwrap() == BoundedInt::max() - 2, 'test fail');
    assert(reader.read_u64().unwrap() == BoundedInt::max() - 3, 'test fail');
    assert(reader.read_u128().unwrap() == BoundedInt::max() - 4, 'test fail');
    assert(reader.read_u256().unwrap() == BoundedInt::max() - 5, 'test fail');
}
