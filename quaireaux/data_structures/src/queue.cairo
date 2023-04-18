// Core lib imports
use array::ArrayTrait;

const ZERO_USIZE: usize = 0;

struct Queue<T> {
    elements: Array<T>, 
}

trait QueueTrait<T> {
    fn new() -> Queue<T>;
    fn enqueue(ref self: Queue<T>, value: T);
    fn dequeue(ref self: Queue<T>) -> Option<T>;
    fn peek_front(self: @Queue<T>) -> Option<Box<@T>>;
    fn len(self: @Queue<T>) -> usize;
    fn is_empty(self: @Queue<T>) -> bool;
}

impl QueueImpl<T> of QueueTrait<T> {
    #[inline(always)]
    fn new() -> Queue<T> {
        queue_new()
    }

    fn enqueue(ref self: Queue<T>, value: T) {
        let mut elements = self.elements;
        elements.append(value);
        self = Queue { elements }
    }

    fn dequeue(ref self: Queue<T>) -> Option<T> {
        let mut elements = self.elements;
        let first = elements.pop_front();
        self = Queue { elements };
        first
    }

    fn peek_front(self: @Queue<T>) -> Option<Box<@T>> {
        self.elements.get(ZERO_USIZE)
    }

    fn len(self: @Queue<T>) -> usize {
        self.elements.len()
    }

    fn is_empty(self: @Queue<T>) -> bool {
        self.len() == ZERO_USIZE
    }
}

fn queue_new<T>() -> Queue<T> {
    let mut arr = ArrayTrait::new();
    Queue { elements: arr }
}

impl Queuefelt252Drop of Drop<Queue<felt252>>;
