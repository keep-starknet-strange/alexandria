//! Vec implementation.
//!
//! # Example
//! ```
//! use alexandria::data_structures::vec::VecTrait;
//!
//! // Create a new vec instance.
//! let mut vec = Felt252Vec::<u128>::new();
//! // Push some items to the vec.
//! vec.push(1);
//! vec.push(2);
//! ...
//! ```

// Core lib imports
use core::nullable::NullableTrait;
use dict::Felt252DictTrait;
use option::OptionTrait;
use traits::{Index, Into};

trait VecTrait<V, T> {
    /// Creates a new V instance.
    /// Returns
    /// * V The new vec instance.
    fn new() -> V;

    /// Returns the item at the given index, or None if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to get.
    /// Returns
    /// * Option<T> The item at the given index, or None if the index is out of bounds.
    fn get(ref self: V, index: usize) -> Option<T>;

    /// Returns the item at the given index, or panics if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to get.
    /// Returns
    /// * T The item at the given index.
    fn at(ref self: V, index: usize) -> T;

    /// Pushes a new item to the vec.
    /// Parameters
    /// * self The vec instance.
    /// * value The value to push onto the vec.
    fn push(ref self: V, value: T) -> ();

    /// Sets the item at the given index to the given value.
    /// Panics if the index is out of bounds.
    /// Parameters
    /// * self The vec instance.
    /// * index The index of the item to set.
    /// * value The value to set the item to.
    fn set(ref self: V, index: usize, value: T);

    /// Returns the length of the vec.
    /// Parameters
    /// * self The vec instance.
    /// Returns
    /// * usize The length of the vec.
    fn len(self: @V) -> usize;
}

impl VecIndex<V, T, impl VecTraitImpl: VecTrait<V, T>> of Index<V, usize, T> {
    #[inline(always)]
    fn index(ref self: V, index: usize) -> T {
        self.at(index)
    }
}

struct Felt252Vec<T> {
    items: Felt252Dict<T>,
    len: usize,
}

impl DestructFeltVec<
    T, impl TDrop: Drop<T>, impl TFelt252DictValue: Felt252DictValue<T>
> of Destruct<Felt252Vec<T>> {
    fn destruct(self: Felt252Vec<T>) nopanic {
        self.items.squash();
    }
}


impl Felt252VecImpl<
    T, impl TDrop: Drop<T>, impl TCopy: Copy<T>, impl TFelt252DictValue: Felt252DictValue<T>
> of VecTrait<Felt252Vec<T>, T> {
    fn new() -> Felt252Vec<T> {
        Felt252Vec { items: Default::default(), len: 0 }
    }

    fn get(ref self: Felt252Vec<T>, index: usize) -> Option<T> {
        if index < self.len() {
            let item = self.items.get(index.into());
            Option::Some(item)
        } else {
            Option::None(())
        }
    }

    fn at(ref self: Felt252Vec<T>, index: usize) -> T {
        assert(index < self.len(), 'Index out of bounds');
        let item = self.items.get(index.into());
        item
    }

    fn push(ref self: Felt252Vec<T>, value: T) -> () {
        self.items.insert(self.len.into(), value);
        self.len = integer::u32_wrapping_add(self.len, 1_usize);
    }

    fn set(ref self: Felt252Vec<T>, index: usize, value: T) {
        assert(index < self.len(), 'Index out of bounds');
        self.items.insert(index.into(), value);
    }

    fn len(self: @Felt252Vec<T>) -> usize {
        *self.len
    }
}

struct NullableVec<T> {
    items: Felt252Dict<Nullable<T>>,
    len: usize,
}

impl DestructNullableVec<T, impl TDrop: Drop<T>> of Destruct<NullableVec<T>> {
    fn destruct(self: NullableVec<T>) nopanic {
        self.items.squash();
    }
}

impl NullableVecImpl<T, impl TDrop: Drop<T>, impl TCopy: Copy<T>> of VecTrait<NullableVec<T>, T> {
    fn new() -> NullableVec<T> {
        NullableVec { items: Default::default(), len: 0 }
    }

    fn get(ref self: NullableVec<T>, index: usize) -> Option<T> {
        if index < self.len() {
            Option::Some(self.items.get(index.into()).deref())
        } else {
            Option::None(())
        }
    }

    fn at(ref self: NullableVec<T>, index: usize) -> T {
        assert(index < self.len(), 'Index out of bounds');
        self.items.get(index.into()).deref()
    }

    fn push(ref self: NullableVec<T>, value: T) -> () {
        self.items.insert(self.len.into(), nullable_from_box(BoxTrait::new(value)));
        self.len = integer::u32_wrapping_add(self.len, 1_usize);
    }

    fn set(ref self: NullableVec<T>, index: usize, value: T) {
        assert(index < self.len(), 'Index out of bounds');
        self.items.insert(index.into(), nullable_from_box(BoxTrait::new(value)));
    }

    fn len(self: @NullableVec<T>) -> usize {
        *self.len
    }
}
