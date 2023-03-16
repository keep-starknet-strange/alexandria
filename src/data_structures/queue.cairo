// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use box::BoxTrait;


const ZERO_USIZE: usize = 0_usize;

struct Queue<T> {
    elements: Array::<T>,
}

trait QueueTrait<T> {
    fn new() -> Queue::<T>;
    fn enqueue(ref self: Queue::<T>, value: T);
    fn dequeue(ref self: Queue::<T>) -> Option::<T>;
    fn peek_front(self: @Queue::<T>) -> Option::<@T>;
    fn len(self: @Queue::<T>) -> usize;
    fn is_empty(self: @Queue::<T>) -> bool;
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

    fn peek_front(self: @Queue::<T>) -> Option::<@T> {
        match self.elements.get(ZERO_USIZE) {
            Option::Some(x) => Option::Some(x.unbox()),
            Option::None(_) => Option::None(()),
        }
    }

    fn len(self: @Queue::<T>) -> usize {
        self.elements.len()
    }

    fn is_empty(self: @Queue::<T>) -> bool {
        self.len() == ZERO_USIZE
    }
}

fn queue_new<T>() -> Queue::<T> {
    let mut arr = ArrayTrait::<T>::new();
    Queue::<T> { elements: arr }
}

impl Queuefelt252Drop of Drop::<Queue::<felt252>>;
