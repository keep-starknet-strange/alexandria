use alexandria_data_structures::vec::{Felt252Vec, VecTrait};

/// Trait for sorting algorithms that work with Array spans
pub trait Sortable {
    /// Sorts a span of elements and returns a new sorted array
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(array: Span<T>) -> Array<T>;
}

/// Trait for sorting algorithms that work with Felt252Vec
pub trait SortableVec {
    /// Sorts a Felt252Vec and returns a new sorted Felt252Vec
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +Felt252DictValue<T>>(
        array: Felt252Vec<T>,
    ) -> Felt252Vec<T>;
}
