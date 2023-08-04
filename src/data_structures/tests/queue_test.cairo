use array::ArrayTrait;
use box::BoxTrait;
use option::OptionTrait;

use alexandria::data_structures::queue::{Queue, QueueTrait};

#[test]
#[available_gas(2000000)]
fn queue_new_test() {
    let mut queue = QueueTrait::<felt252>::new();
    let result_len = queue.len();

    assert(result_len == 0, 'wrong length');
}

#[test]
#[available_gas(2000000)]
fn queue_is_empty_test() {
    let mut queue = QueueTrait::<felt252>::new();
    let result = queue.is_empty();

    assert(result, 'should be empty');
}

#[test]
#[available_gas(2000000)]
fn queue_enqueue_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);

    assert(!queue.is_empty(), 'must not be empty');
    assert(queue.len() == 2, 'len should be 2');
}

#[test]
#[available_gas(2000000)]
fn queue_peek_front_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.peek_front() {
        Option::Some(result) => {
            assert(*(result.unbox()) == 1, 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return value');
        },
    };

    let result_len = queue.len();
    assert(result_len == 3, 'should not remove items');
}

#[test]
#[available_gas(2000000)]
fn queue_dequeue_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.dequeue() {
        Option::Some(result) => {
            assert(result == 1, 'wrong result');
        },
        Option::None(_) => {
            assert(0 == 1, 'should return a value');
        },
    };

    let result_len = queue.len();
    assert(result_len == 2, 'should remove item');
}
