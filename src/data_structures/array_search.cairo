use array::ArrayTrait;
use quaireaux::utils;

trait ArraySearchExt<T> {
    fn contains(ref self: Array::<T>, item: T) -> bool;
    fn index_of(ref self: Array::<T>, item: T) -> usize;
    // fn min(ref self: Array::<T>) -> T;
    // fn index_of_min(ref self: Array::<T>) -> usize;
    // fn max(ref self: Array::<T>, item: T) -> T;
    // fn index_of_max(ref self: Array::<T>) -> usize;
    // fn min(ref self: Array::<T>) -> T;
    // fn occurrences_of(ref self: Array::<T>, item: T) -> felt;
}


impl ArraySearchImpl<T,
impl TCopy: Copy::<T>,
impl TDrop: Drop::<T>,
impl TPartialEq: PartialEq::<T>> of ArraySearchExt::<T> {
    fn contains(ref self: Array::<T>, item: T) -> bool {
        contains_loop(ref self, item, 0_usize)
    }
    // Panic if doesn't contains
    fn index_of(ref self: Array::<T>, item: T) -> usize {
        index_of_loop(ref self, item, 0_usize)
    }
}

fn contains_loop<T, impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>, impl TCopy: Copy::<T>>(
    ref arr: Array<T>, item: T, index: usize
) -> bool {
    utils::check_gas();

    if index >= arr.len() {
        false
    } else if *arr.at(index) == item {
        true
    } else {
        contains_loop(ref arr, item, index + 1_usize)
    }
}

fn index_of_loop<T, impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>, impl TCopy: Copy::<T>>(
    ref arr: Array<T>, item: T, index: usize
) -> usize {
    utils::check_gas();

    if index >= arr.len() {
        let mut data = ArrayTrait::new();
        data.append('Item not in array');
        panic(data)
    } else if *arr.at(index) == item {
        index
    } else {
        index_of_loop(ref arr, item, index + 1_usize)
    }
}
