//! Stack implementation.
//!
//! # Example
//! ```
//! use alexandria::data_structures::stack::StackTrait;
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
use dict::Felt252DictTrait;
use option::OptionTrait;
use traits::Into;
use nullable::NullableTrait;

trait StackTrait<S, T> {
    /// Creates a new Stack instance.
    fn new() -> S;
    /// Pushes a new value onto the stack.
    fn push(ref self: S, value: T);
    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    fn pop(ref self: S) -> Option<T>;
    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    fn peek(ref self: S) -> Option<T>;
    /// Returns the number of items in the stack.
    fn len(self: @S) -> usize;
    /// Returns true if the stack is empty.
    fn is_empty(self: @S) -> bool;
}

struct Felt252Stack<T> {
    elements: Felt252Dict<T>,
    len: usize,
}

impl DestructFeltStack<
    T, impl TDrop: Drop<T>, impl TFelt252DictValue: Felt252DictValue<T>
> of Destruct<Felt252Stack<T>> {
    fn destruct(self: Felt252Stack<T>) nopanic {
        self.elements.squash();
    }
}

impl Felt252StackImpl<
    T, impl TCopy: Copy<T>, impl TDrop: Drop<T>, impl TFelt252DictValue: Felt252DictValue<T>, 
> of StackTrait<Felt252Stack<T>, T> {
    #[inline(always)]
    /// Creates a new Stack instance.
    /// Returns
    /// * Stack The new stack instance.
    fn new() -> Felt252Stack<T> {
        let elements: Felt252Dict<T> = Default::default();
        Felt252Stack { elements, len: 0 }
    }

    /// Pushes a new value onto the stack.
    /// * `self` - The stack to push the value onto.
    /// * `value` - The value to push onto the stack.
    fn push(ref self: Felt252Stack<T>, value: T) {
        self.elements.insert(self.len.into(), value);
        self.len += 1;
    }

    /// Removes the last item from the stack and returns it, or None if the stack is empty.
    /// * `self` - The stack to pop the item off of.
    /// Returns
    /// * Stack The stack with the item removed.
    /// * Option<u256> The item removed or None if the stack is empty.
    fn pop(ref self: Felt252Stack<T>) -> Option<T> {
        if self.is_empty() {
            return Option::None(());
        }

        self.len -= 1;

        Option::Some(self.elements.get(self.len.into()))
    }

    /// Returns the last item from the stack without removing it, or None if the stack is empty.
    /// * `self` - The stack to peek the item off of.
    /// Returns
    /// * Option<u256> The last item of the stack
    fn peek(ref self: Felt252Stack<T>) -> Option<T> {
        if self.is_empty() {
            return Option::None(());
        }
        Option::Some(self.elements.get((self.len - 1).into()))
    }

    /// Returns the number of items in the stack.
    /// * `self` - The stack to get the length of.
    /// Returns
    /// * usize The number of items in the stack.
    fn len(self: @Felt252Stack<T>) -> usize {
        *self.len
    }

    /// Returns true if the stack is empty.
    /// * `self` - The stack to check if it is empty.
    /// Returns
    /// * bool True if the stack is empty, false otherwise.
    fn is_empty(self: @Felt252Stack<T>) -> bool {
        *self.len == 0
    }
}


struct NullableStack<T> {
    elements: Felt252Dict<Nullable<T>>,
    len: usize,
}

impl DestructNullableStack<T, impl TDrop: Drop<T>> of Destruct<NullableStack<T>> {
    fn destruct(self: NullableStack<T>) nopanic {
        self.elements.squash();
    }
}

impl NullableStackImpl<
    T, impl TCopy: Copy<T>, impl TDrop: Drop<T>, 
> of StackTrait<NullableStack<T>, T> {
    #[inline(always)]
    fn new() -> NullableStack<T> {
        let elements: Felt252Dict<Nullable<T>> = Default::default();
        NullableStack { elements, len: 0 }
    }

    fn push(ref self: NullableStack<T>, value: T) {
        self.elements.insert(self.len.into(), nullable_from_box(BoxTrait::new(value)));
        self.len += 1;
    }

    fn pop(ref self: NullableStack<T>) -> Option<T> {
        if self.is_empty() {
            return Option::None(());
        }

        self.len -= 1;

        Option::Some(self.elements.get(self.len.into()).deref())
    }

    fn peek(ref self: NullableStack<T>) -> Option<T> {
        if self.is_empty() {
            return Option::None(());
        }
        Option::Some(self.elements.get((self.len - 1).into()).deref())
    }

    fn len(self: @NullableStack<T>) -> usize {
        *self.len
    }

    fn is_empty(self: @NullableStack<T>) -> bool {
        *self.len == 0
    }
}
