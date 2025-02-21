use alexandria_data_structures::vec::{Felt252Vec, VecTrait};

pub trait Sortable {
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(array: Span<T>) -> Array<T>;
}

pub trait SortableVec {
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +Felt252DictValue<T>>(
        array: Felt252Vec<T>
    ) -> Felt252Vec<T>;
}
