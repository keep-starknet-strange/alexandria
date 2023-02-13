// Core lib imports
use array::ArrayTrait;
use quaireaux::data_structures::stack::StackTrait;
use quaireaux::data_structures::stack::U256ArrayDrop;
use quaireaux::data_structures::stack::U256ArrayCopy;
// Internal imports

#[test]
#[available_gas(2000000)]
fn queue_new_test() {
    let mut stack = StackTrait::new();
    let result_len = stack.len();

    assert(result_len == 0_usize, 'stack length should be 0');
}

#[test]
#[available_gas(2000000)]
fn queue_is_empty_test() {
    let mut stack = StackTrait::new();
    let result = stack.is_empty();

    assert(result == true, 'stack should be empty');
}

#[test]
#[available_gas(2000000)]
fn stack_push_test() {
    let mut stack = StackTrait::new();
    let mut first_array = ArrayTrait::<u256>::new();
    let mut second_array = ArrayTrait::<u256>::new();

    stack.push(first_array);
    stack.push(second_array);

    let result_len = stack.len();
    let result_is_empty = stack.is_empty();

    assert(result_is_empty == false, 'must not be empty');
    assert(result_len == 2_usize, 'len should be 2');
}
#[test]
#[available_gas(2000000)]
fn stack_peek_test() {
    let mut stack = StackTrait::new();
    let mut first_array = ArrayTrait::<u256>::new();
    first_array.append(u256_from_felt(1));
    first_array.append(u256_from_felt(2));

    let mut second_array = ArrayTrait::<u256>::new();
    second_array.append(u256_from_felt(3));
    second_array.append(u256_from_felt(4));

    stack.push(first_array);
    stack.push(second_array);
    match stack.peek() {
        Option::Some(mut result) => {
            assert(result.at(0_usize) == second_array.at(0_usize), 'wrong result');
            assert(result.at(1_usize) == second_array.at(1_usize), 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return value');
        },
    };

    let result_len = stack.len();
    assert(result_len == 2_usize, 'should not remove items');
}

#[test]
#[available_gas(2000000)]
fn stack_pop_test() {
    let mut stack = StackTrait::new();
    let mut first_array = ArrayTrait::<u256>::new();
    first_array.append(u256_from_felt(1));
    first_array.append(u256_from_felt(2));

    let mut second_array = ArrayTrait::<u256>::new();
    second_array.append(u256_from_felt(3));
    second_array.append(u256_from_felt(4));

    stack.push(first_array);
    stack.push(second_array);
    match stack.pop() {
        Option::Some(mut result) => {
            assert(result.at(0_usize) == second_array.at(0_usize), 'wrong result');
            assert(result.at(1_usize) == second_array.at(1_usize), 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return a value');
        },
    };

    let result_len = stack.len();
    assert(result_len == 1_usize, 'should remove item');
}

