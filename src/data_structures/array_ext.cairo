use array::ArrayTrait;
use quaireaux::utils;

trait ArrayTraitExt<T> {
    fn append_all(ref self: Array::<T>, ref arr: Array::<T>);
}

impl ArrayImpl<T, impl TDrop: Drop::<T>> of ArrayTraitExt::<T> {
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
}