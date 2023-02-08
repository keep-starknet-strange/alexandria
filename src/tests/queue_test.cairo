use array::ArrayTrait;
use option::OptionTrait;

use quaireaux::data_structures::queue::Queue;
use quaireaux::data_structures::queue::QueueTrait;

#[test]
#[available_gas(2000000)]
fn queue_new_test() {
    let mut queue = QueueTrait::<felt>::new();
    let result_len = queue.len();

    assert(result_len == 0_usize, 'The length of a new Queue should be 0');
}

#[test]
#[available_gas(2000000)]
fn queue_is_empty_test() {
    let mut queue = QueueTrait::<felt>::new();
    let result = queue.is_empty();

    assert(result == true, 'A newly created Queue should be empty');
}

#[test]
#[available_gas(2000000)]
fn queue_enqueue_test() {
    let mut queue = QueueTrait::<felt>::new();
    queue.enqueue(1);
    queue.enqueue(2);

    let result_len = queue.len();
    let result_is_empty = queue.is_empty();

    assert(result_is_empty == false, 'A Queue with more than one element is not considered empty');
    assert(result_len == 2_usize, 'The len after enqueuing 2 elements should be 2');
}

#[test]
#[available_gas(2000000)]
fn queue_peek_front_test() {
    let mut queue = QueueTrait::<felt>::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.peek_front() {
        Option::Some(result) => {
            assert(result == 1, 'Result should be equal to expected result');
        },
        Option::None(_) => {
            assert(0 == 1, 'A Queue with more than one element should return a value when peek is called');
        },
    };

    let result_len = queue.len();
    assert(result_len == 3_usize, 'Peek should not remove items from the Queue');
}

#[test]
#[available_gas(2000000)]
fn queue_dequeue_test() {
    let mut queue = QueueTrait::<felt>::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.dequeue() {
        Option::Some(result) => {
            assert(result == 1, 'Result should be equal to expected result');
        },
        Option::None(_) => {
            assert(0 == 1, 'A Queue with more than one element should return a value when dequeue is called');
        },
    };

    let result_len = queue.len();
    assert(result_len == 2_usize, 'Dequeue should remove one item from the Queue');
}