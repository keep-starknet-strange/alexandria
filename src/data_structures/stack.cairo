//! Stack implementation.
//!
//! # Example
//! ```
//! use quaireaux::data_structures::stack::StacTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StackTrait::new();
//! # TODO: Add example code for the different methods.

// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;

const ZERO_USIZE: usize = 0_usize;

#[derive(Drop)]
struct Stack {
    elements: Array::<Array::<u256>>, 
}

trait StackTrait {
    fn new() -> Stack;
    fn push(ref self: Stack, value: Array::<u256>);
    fn pop(ref self: Stack) -> Option::<Array::<u256>>;
    fn peek(ref self: Stack) -> Option::<Array::<u256>>;
    fn len(ref self: Stack) -> usize;
    fn is_empty(ref self: Stack) -> bool;
}

impl StackImpl of StackTrait {
    #[inline(always)]
    fn new() -> Stack {
        let mut elements = ArrayTrait::<Array::<u256>>::new();
        Stack { elements }
    }

    fn push(ref self: Stack, value: Array::<u256>) {
        let Stack{mut elements } = self;
        elements.append(value);
        self = Stack { elements }
    }
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

    fn peek(ref self: Stack) -> Option::<Array::<u256>> {
        let mut elements = self.elements;
        let last = elements.get(elements.len() - 1_usize);
        self = Stack { elements };
        last
    }

    fn len(ref self: Stack) -> usize {
        let mut elements = self.elements;
        let length = elements.len();
        self = Stack { elements };
        length
    }

    fn is_empty(ref self: Stack) -> bool {
        self.len() == ZERO_USIZE
    }
}
fn array_slice(
    ref arr: Array::<Array::<u256>>, begin: usize, end: usize
) -> Array::<Array::<u256>> {
    let mut slice = ArrayTrait::<Array::<u256>>::new();
    array_slice_loop(ref arr, ref slice, begin, end);
    slice
}

fn array_slice_loop(
    ref arr: Array::<Array::<u256>>, ref slice: Array::<Array::<u256>>, index: usize, end: usize
) {
    if index >= end {
        return ();
    }
    if index >= arr.len() {
        return ();
    }
    slice.append(arr.at(index));
    array_slice_loop(ref arr, ref slice, index + 1_usize, end);
}

impl U256ArrayDrop of Drop::<Array::<u256>>;
impl U256ArrayCopy of Copy::<Array::<u256>>;
impl U256_2DArrayDrop of Drop::<Array::<Array::<u256>>>;
impl U256_2DArrayCopy of Copy::<Array::<Array::<u256>>>;
impl StackCopy of Copy::<Stack>;

