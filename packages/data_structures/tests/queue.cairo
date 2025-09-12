use alexandria_data_structures::queue::QueueTrait;

#[test]
fn queue_new_test() {
    let queue = QueueTrait::<felt252>::new();
    let result_len = queue.len();

    assert!(result_len == 0);
}

#[test]
fn queue_is_empty_test() {
    let queue = QueueTrait::<felt252>::new();
    let result = queue.is_empty();

    assert!(result, "should be empty");
}

#[test]
fn queue_enqueue_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);

    assert!(!queue.is_empty(), "must not be empty");
    assert!(queue.len() == 2);
}

#[test]
fn queue_peek_front_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.peek_front() {
        Option::Some(result) => { assert!(*(result.unbox()) == 1); },
        Option::None => { assert!(false, "should return value"); },
    }

    let result_len = queue.len();
    assert!(result_len == 3);
}

#[test]
fn queue_dequeue_test() {
    let mut queue = QueueTrait::new();
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);

    match queue.dequeue() {
        Option::Some(result) => { assert!(result == 1); },
        Option::None => { assert!(false, "should return a value"); },
    }

    let result_len = queue.len();
    assert!(result_len == 2);
}
