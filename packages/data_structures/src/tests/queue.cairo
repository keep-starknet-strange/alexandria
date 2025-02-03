use alexandria_data_structures::queue::QueueTrait;

#[test]
#[available_gas(2000000)]
fn queue_new_test() {
    let queue = QueueTrait::<felt252>::new();
    let result_len = queue.len();

    assert_eq!(result_len, 0);
}

#[test]
#[available_gas(2000000)]
fn queue_is_empty_test() {
    let queue = QueueTrait::<felt252>::new();
    let result = queue.is_empty();

    assert!(result, "should be empty");
}

#[test]
#[available_gas(2000000)]
fn queue_enqueue_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);

    assert!(!queue.is_empty(), "must not be empty");
    assert_eq!(queue.len(), 2);
}

#[test]
#[available_gas(2000000)]
fn queue_peek_front_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.peek_front() {
        Option::Some(result) => { assert_eq!(*(result.unbox()), 1); },
        Option::None => { assert!(false, "should return value"); },
    }

    let result_len = queue.len();
    assert_eq!(result_len, 3);
}

#[test]
#[available_gas(2000000)]
fn queue_dequeue_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.dequeue() {
        Option::Some(result) => { assert_eq!(result, 1); },
        Option::None => { assert!(false, "should return a value"); },
    }

    let result_len = queue.len();
    assert_eq!(result_len, 2);
}
