//! Vec implementation.
//!
//! # Example
//! ```
//! use alexandria_data_structures::vec::VecTrait;
//!
//! // Create a new vec instance.
//! let mut vec = VecTrait::<u128>::new();
//! // Push some items to the vec.
//! vec.push(1);
//! vec.push(2);
//! ...
//! ```

// Core lib imports
use dict::Felt252DictTrait;
use option::OptionTrait;
use traits::{Index, Into};

struct Vec<T> {
    items: Felt252Dict<T>,
    len: usize,
}

impl DestructVec<T,
impl TDrop: Drop<T>,
impl TFelt252DictValue: Felt252DictValue<T>> of Destruct<Vec<T>> {
    fn destruct(self: Vec<T>) nopanic {
        self.items.squash();
    }
}


trait VecTrait<T> {
    fn new() -> Vec<T>;
    fn get(ref self: Vec<T>, index: usize) -> Option<T>;
    fn at(ref self: Vec<T>, index: usize) -> T;
    fn push(ref self: Vec<T>, value: T) -> ();
    fn set(ref self: Vec<T>, index: usize, value: T);
    fn len(self: @Vec<T>) -> usize;
}

impl VecImpl<T,
impl TDrop: Drop<T>,
impl TCopy: Copy<T>,
impl TFelt252DictValue: Felt252DictValue<T>> of VecTrait<T> {
    /// Creates a new Vec instance.
    /// Returns
    /// * Vec The new vec instance.
    fn new() -> Vec<T> {
        let items = Felt252DictTrait::<T>::new();
        Vec { items, len: 0 }
    }

    /// Returns the item at the given index, or None if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to get.
    /// Returns
    /// * Option<T> The item at the given index, or None if the index is out of bounds.
    fn get(ref self: Vec<T>, index: usize) -> Option<T> {
        if index < self.len() {
            let item = self.items.get(index.into());
            Option::Some(item)
        } else {
            Option::None(())
        }
    }

    /// Returns the item at the given index, or panics if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to get.
    /// Returns
    /// * T The item at the given index.
    fn at(ref self: Vec<T>, index: usize) -> T {
        if index < self.len() {
            let item = self.items.get(index.into());
            item
        } else {
            panic_with_felt252('Index out of bounds')
        }
    }

    /// Pushes a new item to the vec.
    /// Parameters
    /// * self The vec instance.
    /// * value The value to push onto the vec.
    fn push(ref self: Vec<T>, value: T) -> () {
        self.items.insert(self.len.into(), value);
        self.len = integer::u32_wrapping_add(self.len, 1_usize);
    }

    /// Sets the item at the given index to the given value.
    /// Panics if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to set.
    /// * value The value to set the item to.
    fn set(ref self: Vec<T>, index: usize, value: T) {
        if index < self.len() {
            self.items.insert(index.into(), value);
        } else {
            panic_with_felt252('Index out of bounds')
        }
    }

    /// Returns the length of the vec.
    /// Parameters
    /// * self The vec instance.
    /// Returns
    /// * usize The length of the vec.
    fn len(self: @Vec<T>) -> usize {
        *(self.len)
    }
}

impl VecIndex<T, impl VecTraitImpl: VecTrait<T>> of Index<Vec<T>, usize, T> {
    #[inline(always)]
    fn index(ref self: Vec<T>, index: usize) -> T {
        self.at(index)
    }
}
