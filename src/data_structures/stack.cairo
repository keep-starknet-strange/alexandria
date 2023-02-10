//! Stack implementation.
//!
//! # Example
//! ```
//! use quaireaux::data_structures::stack::StacTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StacTrait::new();
//! # TODO: Add example code for the different methods.

// Core lib imports
use array::ArrayTrait;

/// MerkleTree representation.
#[derive(Drop)]
struct Stack {}

/// MerkleTree trait.
trait StackTrait {
    /// Create a new stack instance.
    fn new() -> Stack;
}

/// Stack implementation.
impl StackImpl of StackTrait {
    /// Create a new stack instance.
    #[inline(always)]
    fn new() -> Stack {
        Stack {}
    }
}
