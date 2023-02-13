//! Stack implementation.
//!
//! # Example
//! ```
//! use quaireaux::data_structures::stack::StackTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StackTrait::new();
//! // Create an item and push it to the stack.
//! let mut item  = ArrayTrait::<u256>::new();
//! item.append(1_u256);
//! stack.push(item);
//! Remove the item from the stack;
//! stack.pop();
//! ```

// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use quaireaux::utils::array_slice;

const ZERO_USIZE: usize = 0_usize;

#[derive(Drop)]
struct Stack {
    elements: Array::<Array::<u256>>, 
}

trait StackTrait {
    /// Creates a new Stack instance.
    fn new() -> Stack;
    /// Pushes a new value onto the stack.
    fn push(ref self: Stack, value: Array::<u256>);
    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    fn pop(ref self: Stack) -> Option::<Array::<u256>>;
    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    fn peek(ref self: Stack) -> Option::<Array::<u256>>;
    /// Returns the number of items in the stack.
    fn len(ref self: Stack) -> usize;
    /// Returns true if the stack is empty.
    fn is_empty(ref self: Stack) -> bool;
}

impl StackImpl of StackTrait {
    #[inline(always)]
    /// Creates a new Stack instance.
    fn new() -> Stack {
        let mut elements = ArrayTrait::<Array::<u256>>::new();
        Stack { elements }
    }

    /// Pushes a new value onto the stack.
    /// * `self` - The stack to push the value onto.
    /// * `value` - The value to push onto the stack.
    fn push(ref self: Stack, value: Array::<u256>) {
        let Stack{mut elements } = self;
        elements.append(value);
        self = Stack { elements }
    }


    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    /// * `self` - The stack to pop the item off of.
    /// Returns
    /// The item removed or None if the stack is empty.
    fn pop(ref self: Stack) -> Option::<Array::<u256>> {
        let mut elements = self.elements;
        if elements.is_empty() {
            return Option::<Array::<u256>>::None(());
        }
        let first = elements.get(elements.len() - 1_usize);
        let elements = array_slice(ref elements, 0_usize, elements.len() - 1_usize);
        self = Stack { elements };
        first
    }

    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    /// * `self` - The stack to peek the item off of.
    /// Returns
    /// The last item or None if the stack is empty.
    fn peek(ref self: Stack) -> Option::<Array::<u256>> {
        let mut elements = self.elements;
        let last = elements.get(elements.len() - 1_usize);
        self = Stack { elements };
        last
    }

    /// Returns the number of items in the stack.
    /// * `self` - The stack to get the length of.
    /// Returns
    /// The number of items in the stack.
    fn len(ref self: Stack) -> usize {
        let mut elements = self.elements;
        let length = elements.len();
        self = Stack { elements };
        length
    }

    /// Returns true if the stack is empty.
    /// * `self` - The stack to check if it is empty.
    /// Returns
    /// True if the stack is empty, false otherwise.
    fn is_empty(ref self: Stack) -> bool {
        self.len() == ZERO_USIZE
    }
}


impl U256ArrayDrop of Drop::<Array::<u256>>;
impl U256ArrayCopy of Copy::<Array::<u256>>;
impl U256_2DArrayDrop of Drop::<Array::<Array::<u256>>>;
impl U256_2DArrayCopy of Copy::<Array::<Array::<u256>>>;
impl StackCopy of Copy::<Stack>;

