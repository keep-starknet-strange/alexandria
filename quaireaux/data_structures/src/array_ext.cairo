use array::ArrayTrait;

use quaireaux_utils::check_gas;

trait ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>);
    fn reverse(ref self: Array<T>) -> Array<T>;
    fn contains<impl TPartialEq: PartialEq<T>>(ref self: @Array<T>, item: T) -> bool;
    fn index_of<impl TPartialEq: PartialEq<T>>(ref self: @Array<T>, item: T) -> usize;
    fn occurrences_of<impl TPartialEq: PartialEq<T>>(ref self: Array<T>, item: T) -> usize;
    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> T;
    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize;
    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> T;
    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize;
}

impl ArrayImpl<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>> of ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>) {
        check_gas();

        match arr.pop_front() {
            Option::Some(v) => {
                self.append(v);
                self.append_all(ref arr);
            },
            Option::None(()) => (),
        }
    }

    fn reverse(ref self: Array<T>) -> Array<T> {
        if self.len() == 0 {
            return ArrayTrait::new();
        }
        let mut response = ArrayTrait::new();
        reverse_loop(ref self, ref response, self.len() - 1);
        response
    }

    fn contains<impl TPartialEq: PartialEq<T>>(ref self: @Array<T>, item: T) -> bool {
        let mut index = 0_usize;
        loop {
            check_gas();

            if index >= self.len() {
                break false;
            } else if *self[index] == item {
                break true;
            } else {
                index = index + 1;
            };
        }
    }

    // Panic if doesn't contains
    // Panic if doesn't contains
    fn index_of<impl TPartialEq: PartialEq<T>>(ref self: @Array<T>, item: T) -> usize {
        let mut index = 0_usize;
        loop {
            check_gas();

            if index >= self.len() {
                panic_with_felt252('Item not in array');
            } else if *self[index] == item {
                break index;
            } else {
                index = index + 1;
            };
        }
    }

    fn occurrences_of<impl TPartialEq: PartialEq<T>>(ref self: Array<T>, item: T) -> usize {
        occurrences_of_loop(ref self, item, 0, 0)
    }

    // Panic if empty array
    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> T {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        min_loop(ref self, *self[0], 1)
    }

    // Panic if empty array
    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        index_of_min_loop(ref self, *self[0], 0, 1)
    }

    // Panic if empty array
    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> T {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        max_loop(ref self, *self[0], 1)
    }

    // Panic if empty array
    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        index_of_max_loop(ref self, *self[0], 0, 1)
    }
}

fn reverse_loop<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>>(
    ref arr: Array<T>, ref response: Array<T>, index: usize
) {
    check_gas();

    response.append(*arr[index]);
    if index == 0 {
        return ();
    }
    reverse_loop(ref arr, ref response, index - 1);
}

fn occurrences_of_loop<T, impl TDrop: Drop<T>, impl TPartialEq: PartialEq<T>, impl TCopy: Copy<T>>(
    ref arr: Array<T>, item: T, index: usize, count: usize
) -> usize {
    check_gas();

    if index >= arr.len() {
        count
    } else if *arr[index] == item {
        occurrences_of_loop(ref arr, item, index + 1, count + 1)
    } else {
        occurrences_of_loop(ref arr, item, index + 1, count)
    }
}

fn min_loop<T,
impl TDrop: Drop<T>,
impl TPartialEq: PartialEq<T>,
impl TPartialOrd: PartialOrd<T>,
impl TCopy: Copy<T>>(
    ref arr: Array<T>, current_min: T, index: usize
) -> T {
    check_gas();

    if index >= arr.len() {
        return current_min;
    }

    let item = *arr[index];
    if item < current_min {
        min_loop(ref arr, item, index + 1)
    } else {
        min_loop(ref arr, current_min, index + 1)
    }
}

fn index_of_min_loop<T,
impl TDrop: Drop<T>,
impl TPartialEq: PartialEq<T>,
impl TPartialOrd: PartialOrd<T>,
impl TCopy: Copy<T>>(
    ref arr: Array<T>, current_min: T, index_of_min: usize, index: usize
) -> usize {
    check_gas();

    if index >= arr.len() {
        return index_of_min;
    }

    let item = *arr[index];
    if item < current_min {
        index_of_min_loop(ref arr, item, index, index + 1)
    } else {
        index_of_min_loop(ref arr, current_min, index_of_min, index + 1)
    }
}

fn max_loop<T,
impl TDrop: Drop<T>,
impl TPartialEq: PartialEq<T>,
impl TPartialOrd: PartialOrd<T>,
impl TCopy: Copy<T>>(
    ref arr: Array<T>, current_min: T, index: usize
) -> T {
    check_gas();

    if index >= arr.len() {
        return current_min;
    }

    let item = *arr[index];
    if item > current_min {
        max_loop(ref arr, item, index + 1)
    } else {
        max_loop(ref arr, current_min, index + 1)
    }
}

fn index_of_max_loop<T,
impl TDrop: Drop<T>,
impl TPartialEq: PartialEq<T>,
impl TPartialOrd: PartialOrd<T>,
impl TCopy: Copy<T>>(
    ref arr: Array<T>, current_min: T, index_of_min: usize, index: usize
) -> usize {
    check_gas();

    if index >= arr.len() {
        return index_of_min;
    }

    let item = *arr[index];
    if item > current_min {
        index_of_max_loop(ref arr, item, index, index + 1)
    } else {
        index_of_max_loop(ref arr, current_min, index_of_min, index + 1)
    }
}
