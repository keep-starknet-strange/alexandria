use array::{ArrayTrait, SpanTrait, OptionTrait};

trait ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>);
    fn reverse(self: @Array<T>) -> Array<T>;
    fn contains<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> bool;
    fn index_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> usize;
    fn occurrences_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> usize;
    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(self: @Array<T>) -> T;
    // TODO Ref should be gone, but there is a bug ATM
    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize;
    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(self: @Array<T>) -> T;
    // TODO Ref should be gone, but there is a bug ATM
    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize;
}

impl ArrayImpl<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>> of ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>) {
        match arr.pop_front() {
            Option::Some(v) => {
                self.append(v);
                self.append_all(ref arr);
            },
            Option::None(()) => (),
        }
    }

    // TODO Due to a loop bug with moved var, this can't use loop yet
    fn reverse(self: @Array<T>) -> Array<T> {
        if self.len() == 0 {
            return ArrayTrait::new();
        }
        let mut response = ArrayTrait::new();
        let mut index = self.len() - 1;
        loop {
            response.append(*self[index]);
            if index == 0 {
                break ();
            }
            index -= 1;
        };
        response
    }

    fn contains<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> bool {
        let mut arr = self.span();
        loop {
            match arr.pop_front() {
                Option::Some(v) => {
                    if *v == item {
                        break true;
                    }
                },
                Option::None(_) => {
                    break false;
                },
            };
        }
    }

    // Panic if doesn't contains
    fn index_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> usize {
        let mut arr = self.span();
        let mut index = 0_usize;
        loop {
            match arr.pop_front() {
                Option::Some(v) => {
                    if *v == item {
                        break index;
                    }
                    index = index + 1;
                },
                Option::None(_) => {
                    panic_with_felt252('Item not in array');
                },
            };
        }
    }

    fn occurrences_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> usize {
        let mut arr = self.span();
        let mut count = 0_usize;
        loop {
            match arr.pop_front() {
                Option::Some(v) => {
                    if *v == item {
                        count = count + 1;
                    }
                },
                Option::None(_) => {
                    break count;
                },
            };
        }
    }

    // Panic if empty array
    // TODO atm there is a bug (failing setting up the runner: #31139: [24] is undefined.)
    // but this should be updated to use span and match
    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(self: @Array<T>) -> T {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        let mut index = 0_usize;
        let mut min = *self[0];

        loop {
            if index >= self.len() {
                break min;
            }

            let item = *self[index];
            if item < min {
                min = item
            }
            index = index + 1;
        }
    }

    // Panic if empty array
    // TODO atm there is a bug (failing setting up the runner: #33424: Inconsistent references annotations.
    // but this should be updated to use span and match
    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        index_of_min_loop(ref self, *self[0], 0, 1)
    }

    // Panic if empty array
    // TODO atm there is a bug (failing setting up the runner: #31139: [24] is undefined.)
    // but this should be updated to use span and match
    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(self: @Array<T>) -> T {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        let mut index = 0_usize;
        let mut max = *self[0];

        loop {
            if index >= self.len() {
                break max;
            }

            let item = *self[index];
            if item > max {
                max = item
            }
            index = index + 1;
        }
    }

    // Panic if empty array
    // TODO atm there is a bug (failing setting up the runner: #33424: Inconsistent references annotations.
    // but this should be updated to use span and match
    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        ref self: Array<T>
    ) -> usize {
        if self.len() == 0 {
            panic_with_felt252('Empty array')
        }
        index_of_max_loop(ref self, *self[0], 0, 1)
    }
}

fn index_of_min_loop<T,
impl TDrop: Drop<T>,
impl TPartialEq: PartialEq<T>,
impl TPartialOrd: PartialOrd<T>,
impl TCopy: Copy<T>>(
    ref arr: Array<T>, current_min: T, index_of_min: usize, index: usize
) -> usize {
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

fn index_of_max_loop<T,
impl TDrop: Drop<T>,
impl TPartialEq: PartialEq<T>,
impl TPartialOrd: PartialOrd<T>,
impl TCopy: Copy<T>>(
    ref arr: Array<T>, current_min: T, index_of_min: usize, index: usize
) -> usize {
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
