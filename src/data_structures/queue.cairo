// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;

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
    fn new() -> Queue::<T> {
        queue_new()
    }

    fn enqueue(ref self: Queue::<T>, value: T) {
        // self.elements.append(value)
    }
}

fn queue_new<T>() -> Queue::<T> {
    let mut arr = ArrayTrait::<T>::new();
    Queue::<T> { elements: arr }
}

// fn queue_enqueue<T>(ref self: Queue::<T>, value: T) {
// }

impl QueueFeltDrop of Drop::<Queue::<felt>>;