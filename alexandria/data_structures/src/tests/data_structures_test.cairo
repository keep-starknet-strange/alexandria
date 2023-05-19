// Core library imports.
use array::ArrayTrait;
use traits::Into;

use alexandria_data_structures::array_slice;

#[test]
#[available_gas(2000000)]
fn array_slice_test() {
    let mut arr = ArrayTrait::<u256>::new();
    arr.append(1.into());
    arr.append(2.into());
    arr.append(3.into());

    let slice = array_slice(@arr, 0, 2);
    assert(slice.len() == 2, 'invalid result');
    assert(*slice[0] == 1.into(), 'invalid result');
    assert(*slice[1] == 2.into(), 'invalid result');
}
