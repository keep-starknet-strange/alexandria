// Core lib imports
use traits::Into;
use option::OptionTrait;

// Internal imports
use alexandria_data_structures::stack::StackTrait;

#[test]
#[available_gas(2000000)]
fn stack_new_test() {
    let mut stack = StackTrait::new();
    let result_len = stack.len();

    assert(result_len == 0, 'stack length should be 0');
}

#[test]
#[available_gas(2000000)]
fn stack_is_empty_test() {
    let mut stack = StackTrait::new();
    let result = stack.is_empty();

    assert(result == true, 'stack should be empty');
}

#[test]
#[available_gas(2000000)]
fn stack_push_test() {
    let mut stack = StackTrait::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 2.into();

    stack.push(val_1);
    stack.push(val_2);

    let result_len = stack.len();
    let result_is_empty = stack.is_empty();

    assert(result_is_empty == false, 'must not be empty');
    assert(result_len == 2, 'len should be 2');
}
#[test]
#[available_gas(2000000)]
fn stack_peek_test() {
    let mut stack = StackTrait::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 2.into();

    stack.push(val_1);
    stack.push(val_2);
    match stack.peek() {
        Option::Some(result) => {
            assert(result == val_2, 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return value');
        },
    };

    let result_len = stack.len();
    assert(result_len == 2, 'should not remove items');
}

#[test]
#[available_gas(2000000)]
fn stack_pop_test() {
    let mut stack = StackTrait::new();
    let val_1: u256 = 1.into();
    let val_2: u256 = 2.into();

    stack.push(val_1);
    stack.push(val_2);
// TODO Commented due to dangling issue
// let value = stack.pop();
// match value {
//     Option::Some(result) => {
//         assert(result == val_2, 'wrong result');
//     },
//     Option::None(_) => {
//         assert(0 == 1, 'should return a value');
//     },
// };

// let result_len = stack.len();
// assert(result_len == 1, 'should remove item');
}

