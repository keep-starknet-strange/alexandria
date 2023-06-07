//! FenwickTree implementation.
//!
//! # Example
//! ```
//! use alexandria_data_structures::fenwick_tree::FenwickTreeTrait;
//!

// Core lib imports
use dict::Felt252DictTrait;
use traits::{Index, Into};
use zeroable::{Zeroable, NonZero};

use debug::PrintTrait;

/// FenwickTree representation.
struct FenwickTree<T, // TODO: why can't add T bounds here?
> {
    items: Felt252Dict<T>,
    len: u128,
}

impl DestructVec<
    T, impl TDrop: Drop<T>, impl TFelt252DictValue: Felt252DictValue<T>
> of Destruct<FenwickTree<T>> {
    fn destruct(self: FenwickTree<T>) nopanic {
        self.items.squash();
    }
}

/// FenwickTree trait.
trait FenwickTreeTrait<T> {
    /// Create a new fenwick tree instance.
    fn new(len: u128) -> FenwickTree<T>;
    fn add(ref self: FenwickTree<T>, i: u128, item: T) -> ();
    fn sum(ref self: FenwickTree<T>, i: u128) -> T;
    fn sum_between(ref self: FenwickTree<T>, i: u128, j: u128) -> T;
}

// least significant bit
fn lsb(i: u128) -> u128 {
    i & (~i + 1)
}

/// FenwickTree implementation.
impl FenwickTreeImpl<
    T,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
    impl TAdd: Add<T>,
    impl TSub: Sub<T>,
    impl TZeroable: Zeroable<T>,
    impl TFelt252DictValue: Felt252DictValue<T>,
    impl TPrint: PrintTrait<T>,
> of FenwickTreeTrait<T> {
    fn new(len: u128) -> FenwickTree<T> {
        FenwickTree { items: Felt252DictTrait::<T>::new(), len }
    }

    fn add(ref self: FenwickTree<T>, i: u128, item: T) {
        let mut j: u128 = i;
        loop {
            if j > self.len {
                break ();
            }
            self.items.insert(j.into(), self.items.get(j.into()) + item);
            j += lsb(j);
        }
    }

    fn sum(ref self: FenwickTree<T>, i: u128) -> T {
        let mut sum = Zeroable::zero();
        let mut j: u128 = i;
        loop {
            if j == 0 {
                break sum;
            }
            sum = sum + self.items.get(j.into());
            j -= lsb(j);
        }
    }

    fn sum_between(ref self: FenwickTree<T>, i: u128, j: u128) -> T {
        return self.sum(j) - self.sum(i - 1);
    }
}
