// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;

const ZERO_USIZE: usize = 0_usize;

struct Queue<T> { 
    elements: Array::<T>,
}

trait QueueTrait<T> {
    fn new() -> Queue::<T>;
    fn enqueue(ref self: Queue::<T>, value: T);
    fn dequeue(ref self: Queue::<T>) -> Option::<T>;
    fn peek_front(ref self: Queue::<T>) -> Option::<T>;
    fn len(ref self: Queue::<T>) -> usize;
    fn is_empty(ref self: Queue::<T>) -> bool;
}

impl QueueImpl<T> of QueueTrait::<T> {
    #[inline(always)]
    fn new() -> Queue::<T> {
        queue_new()
    }
    
    fn enqueue(ref self: Queue::<T>, value: T) {
        let mut elements = self.elements;
        elements.append(value);
        self = Queue { elements }
    }

    fn dequeue(ref self: Queue::<T>) -> Option::<T> {
        let mut elements = self.elements;
        let first = elements.pop_front();
        self = Queue { elements };
        first
    }

    fn peek_front(ref self: Queue::<T>) -> Option::<T> {
        let mut elements = self.elements;
        let first = elements.get(ZERO_USIZE);
        self = Queue { elements };
        first
    }

    fn len(ref self: Queue::<T>) -> usize {
        let mut elements = self.elements;
        let queue_len = elements.len();
        self = Queue { elements };
        queue_len
    }

    fn is_empty(ref self: Queue::<T>) -> bool {
        self.len() == ZERO_USIZE
    }
}

fn queue_new<T>() -> Queue::<T> {
    let mut arr = ArrayTrait::<T>::new();
    Queue::<T> { elements: arr }
}

impl QueueFeltDrop of Drop::<Queue::<felt>>;