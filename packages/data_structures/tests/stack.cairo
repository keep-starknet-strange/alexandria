// Internal imports
use alexandria_data_structures::stack::{Felt252Stack, NullableStack, StackTrait};

fn stack_new_test<S, T, +StackTrait<S, T>>(stack: @S) {
    assert(stack.len() == 0, 'values should match');
}

fn stack_is_empty_test<S, T, +StackTrait<S, T>>(stack: @S) {
    assert(stack.is_empty(), 'should be empty');
}

fn stack_push_test<S, T, +StackTrait<S, T>, +Drop<T>, +Destruct<S>>(
    ref stack: S, val_1: T, val_2: T,
) {
    stack.push(val_1);
    stack.push(val_2);

    assert(!stack.is_empty(), 'should not be empty');
    assert(stack.len() == 2, 'values should match');
}

fn stack_peek_test<S, T, +StackTrait<S, T>, +Drop<T>, +Copy<T>, +PartialEq<T>, +Destruct<S>>(
    ref stack: S, val_1: T, val_2: T,
) {
    stack.push(val_1);
    stack.push(val_2);
    match stack.peek() {
        Option::Some(result) => { assert(result == val_2, 'values should match'); },
        Option::None => { assert(false, 'should not be none'); },
    }

    assert(stack.len() == 2, 'values should match');
}

fn stack_pop_test<S, T, +StackTrait<S, T>, +Drop<T>, +Copy<T>, +PartialEq<T>, +Destruct<S>>(
    ref stack: S, val_1: T, val_2: T,
) {
    stack.push(val_1);
    stack.push(val_2);

    let value = stack.pop();
    match value {
        Option::Some(result) => { assert(result == val_2, 'values should match'); },
        Option::None => { assert(false, 'should not be none'); },
    }

    assert(stack.len() == 1, 'values should match');
}

fn stack_push_pop_push_test<
    S, T, +StackTrait<S, T>, +Drop<T>, +Copy<T>, +PartialEq<T>, +Destruct<S>,
>(
    ref stack: S, val_1: T, val_2: T, val_3: T,
) {
    stack.push(val_1);
    stack.push(val_2);
    let _ = stack.pop();
    stack.push(val_3);

    assert(stack.peek().unwrap() == val_3, 'values should match');
    assert(stack.len() == 2, 'values should match');
}

#[test]
fn felt252_stack_new_test() {
    stack_new_test(@StackTrait::<Felt252Stack, u128>::new());
}

#[test]
fn felt252_stack_is_empty_test() {
    stack_is_empty_test(@StackTrait::<Felt252Stack, u128>::new());
}

#[test]
fn felt252_stack_push_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();
    stack_push_test(ref stack, 1, 2);
}


#[test]
fn felt252_stack_peek_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();
    stack_peek_test(ref stack, 1, 2);
}

#[test]
fn felt252_stack_pop_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();
    stack_pop_test(ref stack, 1, 2);
}

#[test]
fn felt252_stack_push_pop_push_test() {
    let mut stack = StackTrait::<Felt252Stack, u128>::new();

    stack_push_pop_push_test(ref stack, 1, 2, 3);
}


#[test]
fn nullable_stack_new_test() {
    stack_new_test(@StackTrait::<NullableStack, u256>::new());
}

#[test]
fn nullable_stack_is_empty_test() {
    stack_is_empty_test(@StackTrait::<NullableStack, u256>::new());
}

#[test]
fn nullable_stack_push_test() {
    let mut stack = StackTrait::<NullableStack, u256>::new();
    stack_push_test(ref stack, 1, 2);
}


#[test]
fn nullable_stack_peek_test() {
    let mut stack = StackTrait::<NullableStack, u256>::new();
    stack_peek_test(ref stack, 1, 2);
}

#[test]
fn nullable_stack_pop_test() {
    let mut stack = StackTrait::<NullableStack, u256>::new();
    stack_pop_test(ref stack, 1, 2);
}

#[test]
fn nullable_stack_push_pop_push_test() {
    let mut stack = StackTrait::<NullableStack<u256>, u256>::new();

    stack_push_pop_push_test(ref stack, 1, 2, 3);
}
