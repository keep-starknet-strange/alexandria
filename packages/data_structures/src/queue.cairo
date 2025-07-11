const ZERO_USIZE: usize = 0;

pub struct Queue<T> {
    elements: Array<T>,
}

pub trait QueueTrait<T> {
    /// Creates a new empty queue
    ///
    /// #### Returns
    /// * `Queue<T>` - A new empty queue instance
    fn new() -> Queue<T>;

    /// Adds an element to the back of the queue
    ///
    /// #### Arguments
    /// * `self` - The queue to add the element to
    /// * `value` - The element to add
    fn enqueue(ref self: Queue<T>, value: T);

    /// Removes and returns the front element from the queue
    ///
    /// #### Arguments
    /// * `self` - The queue to remove the element from
    ///
    /// #### Returns
    /// * `Option<T>` - Some(element) if queue is not empty, None otherwise
    fn dequeue(ref self: Queue<T>) -> Option<T>;

    /// Returns a reference to the front element without removing it
    ///
    /// #### Arguments
    /// * `self` - The queue to peek into
    ///
    /// #### Returns
    /// * `Option<Box<@T>>` - Some(reference) to front element if queue is not empty, None otherwise
    fn peek_front(self: @Queue<T>) -> Option<Box<@T>>;

    /// Returns the number of elements in the queue
    ///
    /// #### Arguments
    /// * `self` - The queue to get the length of
    ///
    /// #### Returns
    /// * `usize` - The number of elements in the queue
    fn len(self: @Queue<T>) -> usize;

    /// Checks if the queue is empty
    ///
    /// #### Arguments
    /// * `self` - The queue to check
    ///
    /// #### Returns
    /// * `bool` - True if the queue contains no elements, false otherwise
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
    let mut arr = array![];
    Queue { elements: arr }
}

impl Queuefelt252Drop of Drop<Queue<felt252>>;
