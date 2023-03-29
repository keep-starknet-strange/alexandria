use array::ArrayTrait;
use utils::utils::check_gas;

// Min and max can't be done atm as we don't have a new for T type yet
trait ArraySearchExt<T> {
    fn contains(ref self: Array::<T>, item: T) -> bool;
    fn index_of(ref self: Array::<T>, item: T) -> usize;
    fn occurrences_of(ref self: Array::<T>, item: T) -> usize;
}

// As felt252 doesn't support PartialOrd I decided to make a new Trait to not add another constraint on ArraySearchExt
trait ArrayMinMaxExt<T> {
    fn min(ref self: Array::<T>) -> T;
    fn index_of_min(ref self: Array::<T>) -> usize;
    fn max(ref self: Array::<T>) -> T;
    fn index_of_max(ref self: Array::<T>) -> usize;
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

    fn occurrences_of(ref self: Array::<T>, item: T) -> usize {
        occurrences_of_loop(ref self, item, 0_usize, 0_usize)
    }
}


fn contains_loop<T, impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>, impl TCopy: Copy::<T>>(
    ref arr: Array<T>, item: T, index: usize
) -> bool {
    check_gas();

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
    check_gas();

    if index >= arr.len() {
        let mut data = ArrayTrait::new();
        data.append('Item not in array');
        panic(data)
    } else if *arr.at(
        index
    ) == item {
        index
    } else {
        index_of_loop(ref arr, item, index + 1_usize)
    }
}

fn occurrences_of_loop<T,
impl TDrop: Drop::<T>,
impl TPartialEq: PartialEq::<T>,
impl TCopy: Copy::<T>>(
    ref arr: Array<T>, item: T, index: usize, count: usize
) -> usize {
    check_gas();

    if index >= arr.len() {
        count
    } else if *arr.at(
        index
    ) == item {
        occurrences_of_loop(ref arr, item, index + 1_usize, count + 1_usize)
    } else {
        occurrences_of_loop(ref arr, item, index + 1_usize, count)
    }
}

impl ArrayMinMaxImpl<T,
impl TCopy: Copy::<T>,
impl TDrop: Drop::<T>,
impl TPartialEq: PartialEq::<T>,
impl TPartialOrd: PartialOrd::<T>> of ArrayMinMaxExt::<T> {
    // Panic if empty array
    fn min(ref self: Array::<T>) -> T {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        min_loop(ref self, *self.at(0_usize), 1_usize)
    }

    fn index_of_min(ref self: Array::<T>) -> usize {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        index_of_min_loop(ref self, *self.at(0_usize), 0_usize, 1_usize)
    }

    fn max(ref self: Array::<T>) -> T {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        max_loop(ref self, *self.at(0_usize), 1_usize)
    }

    fn index_of_max(ref self: Array::<T>) -> usize {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        index_of_max_loop(ref self, *self.at(0_usize), 0_usize, 1_usize)
    }
}


fn min_loop<T,
impl TDrop: Drop::<T>,
impl TPartialEq: PartialEq::<T>,
impl TPartialOrd: PartialOrd::<T>,
impl TCopy: Copy::<T>>(
    ref arr: Array::<T>, current_min: T, index: usize
) -> T {
    check_gas();

    if index >= arr.len() {
        return current_min;
    }

    let item = *arr.at(index);
    if item < current_min {
        min_loop(ref arr, item, index + 1_usize)
    } else {
        min_loop(ref arr, current_min, index + 1_usize)
    }
}

fn index_of_min_loop<T,
impl TDrop: Drop::<T>,
impl TPartialEq: PartialEq::<T>,
impl TPartialOrd: PartialOrd::<T>,
impl TCopy: Copy::<T>>(
    ref arr: Array::<T>, current_min: T, index_of_min: usize, index: usize
) -> usize {
    check_gas();

    if index >= arr.len() {
        return index_of_min;
    }

    let item = *arr.at(index);
    if item < current_min {
        index_of_min_loop(ref arr, item, index, index + 1_usize)
    } else {
        index_of_min_loop(ref arr, current_min, index_of_min, index + 1_usize)
    }
}

fn max_loop<T,
impl TDrop: Drop::<T>,
impl TPartialEq: PartialEq::<T>,
impl TPartialOrd: PartialOrd::<T>,
impl TCopy: Copy::<T>>(
    ref arr: Array::<T>, current_min: T, index: usize
) -> T {
    check_gas();

    if index >= arr.len() {
        return current_min;
    }

    let item = *arr.at(index);
    if item > current_min {
        max_loop(ref arr, item, index + 1_usize)
    } else {
        max_loop(ref arr, current_min, index + 1_usize)
    }
}

fn index_of_max_loop<T,
impl TDrop: Drop::<T>,
impl TPartialEq: PartialEq::<T>,
impl TPartialOrd: PartialOrd::<T>,
impl TCopy: Copy::<T>>(
    ref arr: Array::<T>, current_min: T, index_of_min: usize, index: usize
) -> usize {
    check_gas();

    if index >= arr.len() {
        return index_of_min;
    }

    let item = *arr.at(index);
    if item > current_min {
        index_of_max_loop(ref arr, item, index, index + 1_usize)
    } else {
        index_of_max_loop(ref arr, current_min, index_of_min, index + 1_usize)
    }
}
