use array::ArrayTrait;
use quaireaux::utils;

trait ArraySearchExt<T> {
    fn contains(ref self:  Array::<T>, item: T) -> bool;
    // fn index_of(ref self: @Array::<T>, item: T) -> usize;
}


impl ArraySearchImpl<T, impl TCopy: Copy::<T>, impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>> of ArraySearchExt::<T> {
    fn contains(ref self: Array::<T>, item: T) -> bool {
        contains_loop(ref self, item, 0_usize)
    }
}

fn contains_loop<T, impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>, impl TCopy: Copy::<T>>
(ref arr: Array<T>, item: T, index: usize) -> bool{
    utils::check_gas();

    if index >= arr.len() {
        false
    } else if *arr.at(index) == item {
        true
    } else {
        contains_loop(ref arr, item, index + 1_usize)
    }
}
