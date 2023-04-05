use array::ArrayTrait;

use quaireaux_utils::check_gas;

trait ArrayTraitExt<T> {
    fn append_all(ref self: Array::<T>, ref arr: Array::<T>);
    fn reverse(ref self: Array::<T>) -> Array::<T>;
    fn contains<impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>>(
        ref self: Array::<T>, item: T
    ) -> bool;
    fn index_of<impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>>(
        ref self: Array::<T>, item: T
    ) -> usize;
    fn occurrences_of<impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>>(
        ref self: Array::<T>, item: T
    ) -> usize;
    fn min<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> T;
    fn index_of_min<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> usize;
    fn max<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> T;
    fn index_of_max<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> usize;
}

impl ArrayImpl<T, impl TCopy: Copy::<T>> of ArrayTraitExt::<T> {
    fn append_all(ref self: Array::<T>, ref arr: Array::<T>) {
        check_gas();

        match arr.pop_front() {
            Option::Some(v) => {
                self.append(v);
                self.append_all(ref arr);
            },
            Option::None(()) => (),
        }
    }

    fn reverse(ref self: Array::<T>) -> Array::<T> {
        if self.len() == 0_usize {
            return ArrayTrait::<T>::new();
        }
        let mut response = ArrayTrait::new();
        reverse_loop(ref self, ref response, self.len() - 1_usize);
        response
    }

    fn contains<impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>>(
        ref self: Array::<T>, item: T
    ) -> bool {
        contains_loop(ref self, item, 0_usize)
    }

    // Panic if doesn't contains
    fn index_of<impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>>(
        ref self: Array::<T>, item: T
    ) -> usize {
        index_of_loop(ref self, item, 0_usize)
    }

    fn occurrences_of<impl TDrop: Drop::<T>, impl TPartialEq: PartialEq::<T>>(
        ref self: Array::<T>, item: T
    ) -> usize {
        occurrences_of_loop(ref self, item, 0_usize, 0_usize)
    }

    // Panic if empty array
    fn min<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> T {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        min_loop(ref self, *self.at(0_usize), 1_usize)
    }

    // Panic if empty array
    fn index_of_min<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> usize {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        index_of_min_loop(ref self, *self.at(0_usize), 0_usize, 1_usize)
    }

    // Panic if empty array
    fn max<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> T {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        max_loop(ref self, *self.at(0_usize), 1_usize)
    }

    // Panic if empty array
    fn index_of_max<impl TDrop: Drop::<T>,
    impl TPartialEq: PartialEq::<T>,
    impl TPartialOrd: PartialOrd::<T>>(
        ref self: Array::<T>
    ) -> usize {
        if self.len() == 0_usize {
            let mut data = ArrayTrait::new();
            data.append('Empty array');
            panic(data)
        }
        index_of_max_loop(ref self, *self.at(0_usize), 0_usize, 1_usize)
    }
}

fn reverse_loop<T, impl TCopy: Copy::<T>>(ref arr: Array<T>, ref response: Array<T>, index: usize) {
    check_gas();

    response.append(*arr.at(index));
    if index == 0_usize {
        return ();
    }
    reverse_loop(ref arr, ref response, index - 1_usize);
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
