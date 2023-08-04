// Core lib imports
use traits::{Into, TryInto};
use option::OptionTrait;
use integer::Felt252IntoU256;

// Internal imports
use alexandria::data_structures::stack::{StackTrait, Felt252Stack, NullableStack};


fn stack_new_test<S, T, impl Stack: StackTrait<S, T>>(stack: @S) {
    assert(stack.len() == 0, 'stack length should be 0');
}

fn stack_is_empty_test<S, T, impl Stack: StackTrait<S, T>>(stack: @S) {
    assert(stack.is_empty(), 'stack should be empty');
}

fn stack_push_test<
    S, T, impl Stack: StackTrait<S, T>, impl TDrop: Drop<T>, impl SDestruct: Destruct<S>
>(
    ref stack: S, val_1: T, val_2: T
) {
    stack.push(val_1);
    stack.push(val_2);

    assert(!stack.is_empty(), 'must not be empty');
    assert(stack.len() == 2, 'len should be 2');
}

fn stack_peek_test<
    S,
    T,
    impl Stack: StackTrait<S, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<S>
>(
    ref stack: S, val_1: T, val_2: T
) {
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

    assert(stack.len() == 2, 'should not remove items');
}

fn stack_pop_test<
    S,
    T,
    impl Stack: StackTrait<S, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<S>
>(
    ref stack: S, val_1: T, val_2: T
) {
    stack.push(val_1);
    stack.push(val_2);

    let value = stack.pop();
    match value {
        Option::Some(result) => {
            assert(result == val_2, 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return a value');
        },
    };

    assert(stack.len() == 1, 'should remove item');
}

fn stack_push_pop_push_test<
    S,
    T,
    impl Stack: StackTrait<S, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TPartialEq: PartialEq<T>,
    impl SDestruct: Destruct<S>
>(
    ref stack: S, val_1: T, val_2: T, val_3: T
) {
    stack.push(val_1);
    stack.push(val_2);
    stack.pop();
    stack.push(val_3);

    assert(stack.peek().unwrap() == val_3, 'wrong result');
    assert(stack.len() == 2, 'should update length');
}

#[test]
#[available_gas(2000000)]
fn felt252_stack_new_test() {
    stack_new_test(@StackTrait::<Felt252Stack, u128>::new());
}

#[test]
#[available_gas(2000000)]
fn felt252_stack_is_empty_test() {
    stack_is_empty_test(@StackTrait::<Felt252Stack, u128>::new());
}

#[test]
#[available_gas(2000000)]
fn felt252_stack_push_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();
    stack_push_test(ref stack, 1, 2);
}


#[test]
#[available_gas(2000000)]
fn felt252_stack_peek_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();
    stack_peek_test(ref stack, 1, 2);
}

#[test]
#[available_gas(2000000)]
fn felt252_stack_pop_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();
    stack_pop_test(ref stack, 1, 2);
}

#[test]
#[available_gas(2000000)]
fn felt252_stack_push_pop_push_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();

    stack_push_pop_push_test(ref stack, 1, 2, 3);
}


#[test]
#[available_gas(2000000)]
fn nullable_stack_new_test() {
    stack_new_test(@StackTrait::<NullableStack, u256>::new());
}

#[test]
#[available_gas(2000000)]
fn nullable_stack_is_empty_test() {
    stack_is_empty_test(@StackTrait::<NullableStack, u256>::new());
}

#[test]
#[available_gas(2000000)]
fn nullable_stack_push_test() {
    let mut stack = StackTrait::<NullableStack, u256>::new();
    stack_push_test(ref stack, 1, 2);
}


#[test]
#[available_gas(2000000)]
fn nullable_stack_peek_test() {
    let mut stack = StackTrait::<NullableStack, u256>::new();
    stack_peek_test(ref stack, 1, 2);
}

#[test]
#[available_gas(2000000)]
fn nullable_stack_pop_test() {
    let mut stack = StackTrait::<NullableStack, u256>::new();
    stack_pop_test(ref stack, 1, 2);
}

#[test]
#[available_gas(2000000)]
fn nullable_stack_push_pop_push_test() {
    let mut stack = StackTrait::<NullableStack<u256>, u256>::new();

    stack_push_pop_push_test(ref stack, 1, 2, 3);
}
