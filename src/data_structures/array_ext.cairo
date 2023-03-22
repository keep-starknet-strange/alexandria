use array::ArrayTrait;
use array::SpanTrait;
use quaireaux::utils;

trait ArrayTraitExt<T> {
    fn append_all(ref self: Array::<T>, ref arr: Array::<T>);
    fn reverse(ref self: Array::<T>) -> Array::<T>;
}

trait ArraySearchExt<T> {
    fn contains(ref self:  Array::<T>, item: T) -> bool;
}

impl ArrayImpl<T, impl TCopy: Copy::<T>> of ArrayTraitExt::<T>  {
    fn append_all(ref self: Array::<T>, ref arr: Array::<T>) {
        utils::check_gas();

        match arr.pop_front() {
            Option::Some(v) => {
                self.append(v);
                self.append_all(ref arr);
            },
            Option::None(()) => (),
        }
    }

    fn reverse(ref self: Array::<T>) -> Array::<T>{
        if self.len() == 0_usize {
            return ArrayTrait::<T>::new();
        }
        let mut response = ArrayTrait::new();
        reverse_loop(ref self, ref response, self.len() - 1_usize);
        response
    }
}

fn reverse_loop<T, impl TCopy: Copy::<T>>(ref arr: Array<T>, ref response: Array<T>, index: usize) {
    utils::check_gas();

    response.append(*arr.at(index));
    if index == 0_usize {
        return ();
    }
    reverse_loop(ref arr, ref response, index - 1_usize);
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

