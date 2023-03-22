use array::ArrayTrait;
use array::SpanTrait;
use quaireaux::utils;

// Split in 2 Traits because searching require more impl 

trait ArrayTraitExt<T> {
    fn append_all(ref self: Array::<T>, ref arr: Array::<T>);
    fn reverse(ref self: Array::<T>) -> Array::<T>;
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
