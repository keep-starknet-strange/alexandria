//! Stack implementation.
//!
//! # Example
//! ```
//! use quaireaux::data_structures::stack::StackTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StackTrait::new();
//! // Create an item and push it to the stack.
//! let mut item:u256 = 1.into();
//! stack.push(item);
//! Remove the item from the stack;
//! let item = stack.pop();
//! ```

// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use quaireaux::utils::array_slice;

const ZERO_USIZE: usize = 0_usize;

#[derive(Drop)]
struct Stack {
    elements: Array::<u256>, 
}

trait StackTrait {
    /// Creates a new Stack instance.
    fn new() -> Stack;
    /// Pushes a new value onto the stack.
    fn push(ref self: Stack, value: u256);
    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    fn pop(ref self: Stack) -> Option::<u256>;
    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    fn peek(self: @Stack) -> Option::<u256>;
    /// Returns the number of items in the stack.
    fn len(self: @Stack) -> usize;
    /// Returns true if the stack is empty.
    fn is_empty(self: @Stack) -> bool;
}

impl StackImpl of StackTrait {
    #[inline(always)]
    /// Creates a new Stack instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Stack {
        let mut elements = ArrayTrait::<u256>::new();
        Stack { elements }
    }

    /// Pushes a new value onto the stack.
    /// * `self` - The stack to push the value onto.
    /// * `value` - The value to push onto the stack.
    fn push(ref self: Stack, value: u256) {
        let Stack{mut elements } = self;
        elements.append(value);
        self = Stack { elements }
    }


    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    /// * `self` - The stack to pop the item off of.
    /// Returns
    /// * Stack The stack with the item removed.
    /// * Option::<u256> The item removed or None if the stack is empty.
    fn pop(ref self: Stack) -> Option::<u256> {
        if self.is_empty() {
            return Option::None(());
        }
        // Deconstruct the stack struct because we consume it
        let Stack{elements: mut elements } = self;
        let stack_len = elements.len();
        let last_idx = stack_len - 1_usize;

        let sliced_elements = array_slice(@elements, begin: 0_usize, end: last_idx);

        let value = elements.at(last_idx);
        // Update the returned stack with the sliced array
        self = Stack { elements: sliced_elements };
        Option::Some(*value)
    }

    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    /// * `self` - The stack to peek the item off of.
    /// Returns
    /// * Option::<u256> The last item of the stack
    fn peek(self: @Stack) -> Option::<u256> {
        if self.is_empty() {
            return Option::None(());
        }
        Option::Some(*self.elements.at(self.elements.len() - 1_usize))
    }

    /// Returns the number of items in the stack.
    /// * `self` - The stack to get the length of.
    /// Returns
    /// * usize The number of items in the stack.
    fn len(self: @Stack) -> usize {
        self.elements.len()
    }

    /// Returns true if the stack is empty.
    /// * `self` - The stack to check if it is empty.
    /// Returns
    /// * bool True if the stack is empty, false otherwise.
    fn is_empty(self: @Stack) -> bool {
        self.len() == ZERO_USIZE
    }
}
