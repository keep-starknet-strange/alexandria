// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use hash::LegacyHash;

fn main() {
    let mut queue = QueueTrait::<felt>::new();
}

struct Queue<T> {
    elements: Array::<T>,
}

trait QueueTrait<T> {
    fn new() -> Queue::<T>;
    fn enqueue(ref self: Queue::<T>, value: T);
}

impl QueueImpl<T> of QueueTrait::<T> {
    #[inline(always)]
    fn new() -> Queue::<T> {
        queue_new()
    }

    #[inline(always)]
    fn enqueue(ref self: Queue::<T>, value: T) {
        queue_enqueue(ref self, value)
    }
    
}

fn queue_new<T>() -> Queue::<T> {
    let mut elements = ArrayTrait::new();
    Queue::<T> { elements }
}

fn queue_enqueue<T>(ref self: Queue::<T>, value: T) {
    self.elements.append(value)
}

impl QueueFeltDrop of Drop::<Queue::<felt>>;