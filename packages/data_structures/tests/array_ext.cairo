use alexandria_data_structures::array_ext::ArrayTraitExt;

#[inline(always)]
fn get_felt252_array() -> Array<felt252> {
    array![21, 42, 84]
}

#[inline(always)]
fn get_u128_array() -> Array<u128> {
    array![21_u128, 42_u128, 84_u128]
}

mod append_all {
    use super::{ArrayTraitExt, get_felt252_array};

    #[test]
    fn of_felt() {
        let mut destination = array![21];
        let mut source = array![42, 84];

        destination.append_all(ref source);

        // destination should be filled
        assert(destination.len() == 3, 'dest len should be 3');
        assert(destination[0] == @21, 'dest[0] should be 21');
        assert(destination[1] == @42, 'dest[1] should be 42');
        assert(destination[2] == @84, 'dest[2] should be 84');

        // source should be empty
        assert(source.len() == 0, 'source should be empty');
    }

    #[test]
    fn of_u128() {
        let mut destination = array![21_u128];
        let mut source = array![42_u128, 84_u128];

        destination.append_all(ref source);

        // destination should be filled
        assert(destination.len() == 3, 'dest u128 len should be 3');
        assert(destination[0] == @21_u128, 'dest[0] should be 21');
        assert(destination[1] == @42_u128, 'dest[1] should be 42');
        assert(destination[2] == @84_u128, 'dest[2] should be 84');

        // source should be empty
        assert(source.len() == 0, 'source should be empty');
    }

    #[test]
    fn destination_empty() {
        let mut destination: Array<felt252> = array![];
        let mut source = get_felt252_array();

        destination.append_all(ref source);

        assert!(destination.len() == 3);
        assert!(destination[0] == @21);
        assert!(destination[1] == @42);
        assert!(destination[2] == @84);
    }

    #[test]
    fn source_empty() {
        let mut destination: Array<felt252> = array![];
        let mut source = get_felt252_array();

        destination.append_all(ref source);

        assert!(destination.len() == 3);
        assert!(destination[0] == @21);
        assert!(destination[1] == @42);
        assert!(destination[2] == @84);
    }

    #[test]
    fn both_empty() {
        let mut destination: Array<felt252> = array![];
        let mut source = array![];

        destination.append_all(ref source);

        assert(source.len() == 0, 'both empty source len 0');
        assert(destination.len() == 0, 'both empty dest len 0');
    }
}

mod extend_from_span {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array();
        let span = array![1, 2, 3].span();

        arr.extend_from_span(span);

        assert(arr == array![21, 42, 84, 1, 2, 3], 'array doesn t match');
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array();
        let span = array![1_u128, 2_u128, 3_u128].span();

        arr.extend_from_span(span);

        assert!(
            arr == array![21_u128, 42_u128, 84_u128, 1_u128, 2_u128, 3_u128], "extend u128 failed",
        );
    }

    #[test]
    fn empty_array() {
        let mut arr1 = array![];
        let arr2 = array![1, 2, 3];

        arr1.extend_from_span(arr2.span());

        assert(arr1 == arr2, 'empty arr extend failed');
    }

    #[test]
    fn empty_span() {
        let mut arr1 = array![1, 2, 3];
        let arr2 = array![];

        arr1.extend_from_span(arr2.span());

        assert!(arr1 == array![1, 2, 3]);
    }

    #[test]
    fn from_self() {
        let mut arr = array![1, 2, 3];

        arr.extend_from_span(arr.span());

        assert!(arr == array![1, 2, 3, 1, 2, 3]);
    }
}

mod concat {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let arr1 = get_felt252_array();
        let arr2 = array![1, 2, 3];

        let concatenated = arr1.concat(@arr2);

        assert(concatenated == array![21, 42, 84, 1, 2, 3], 'concat felt failed');
        // arr1 is untouched
        assert(arr1 == get_felt252_array(), 'arr1 was modified');
    }

    #[test]
    fn of_u128() {
        let arr1 = get_u128_array();
        let arr2 = array![1_u128, 2_u128, 3_u128];

        let concatenated = arr1.concat(@arr2);

        assert(
            concatenated == array![21_u128, 42_u128, 84_u128, 1_u128, 2_u128, 3_u128],
            'concat u128 failed',
        );
        // arr1 is untouched
        assert(arr1 == get_u128_array(), 'u128 arr1 was modified');
    }

    #[test]
    fn empty_array_1() {
        let arr1 = array![];
        let arr2 = get_felt252_array();

        let concatenated = arr1.concat(@arr2);
        assert!(concatenated == arr2);
    }

    #[test]
    fn empty_array_2() {
        let arr1 = get_felt252_array();
        let arr2 = array![];

        let concatenated = arr1.concat(@arr2);
        assert!(concatenated == arr1);
    }

    #[test]
    fn both_empty() {
        let arr1 = core::array::ArrayTrait::<felt252>::new();
        let arr2 = array![];

        let concatenated = arr1.concat(@arr2);

        assert!(concatenated.is_empty());
    }
}

mod pop_front_n {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array();

        let poped = arr.pop_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'arr[0] should be 84');

        assert(poped.len() == 2, 'poped len should be 2');
        assert(*poped[0] == 21, 'poped[0] should be 21');
        assert(*poped[1] == 42, 'poped[1] should be 42');
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array();

        arr.pop_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'arr[0] should be 84');
    }

    #[test]
    fn empty_array() {
        let mut arr: Array<felt252> = array![];

        let poped = arr.pop_front_n(2);

        assert(arr.is_empty(), 'arr should be empty');
        assert(poped.is_empty(), 'poped should be empty');
    }

    #[test]
    fn pop_zero() {
        let mut arr = get_felt252_array();

        let poped = arr.pop_front_n(0);

        assert!(arr.len() == 3);
        assert!(arr.pop_front().unwrap() == 21);
        assert!(arr.pop_front().unwrap() == 42);
        assert!(arr.pop_front().unwrap() == 84);
        assert!(poped.is_empty());
    }

    #[test]
    fn exact_len() {
        let mut arr = get_felt252_array();

        let poped = arr.pop_front_n(3);

        assert(arr.is_empty(), 'arr should be empty');
        assert(poped.len() == 3, 'poped len should be 3');
    }

    #[test]
    fn more_then_len() {
        let mut arr = get_felt252_array();

        arr.pop_front_n(4);

        assert(arr.is_empty(), 'arr should be empty');
    }
}

mod remove_front_n {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'arr[0] should be 84');
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array();

        arr.remove_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'arr[0] should be 84');
    }

    #[test]
    fn empty_array() {
        let mut arr: Array<felt252> = array![];

        arr.remove_front_n(2);

        assert(arr.is_empty(), 'arr should be empty');
    }

    #[test]
    fn remove_zero() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(0);

        assert!(arr.len() == 3);
        assert!(arr[0] == @21);
        assert!(arr[1] == @42);
        assert!(arr[2] == @84);
    }

    #[test]
    fn exact_len() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(3);

        assert!(arr.is_empty());
    }

    #[test]
    fn more_then_len() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(4);

        assert!(arr.is_empty());
    }
}

mod reversed {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array();

        let response = arr.reversed();

        assert(response.len() == 3, 'response len should be 3');
        assert(response == array![84, 42, 21], 'reversed array mismatch');
        // Original untouched
        assert(arr == get_felt252_array(), 'arrays should match');
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array();

        let response = arr.reversed();

        assert(response.len() == 3, 'response len should be 3');
        assert(response == array![84_u128, 42_u128, 21_u128], 'u128 reversed mismatch');
    }

    #[test]
    fn even() {
        let mut arr = array![21, 42];

        let response = arr.reversed();

        assert!(response.len() == 2);
        assert!(response == array![42, 21]);
    }

    #[test]
    fn size_1() {
        let mut arr = array![21];

        let response = arr.reversed();

        assert!(response.len() == 1);
        assert!(response[0] == @21);
    }

    #[test]
    fn empty() {
        let mut arr: Array<felt252> = array![];
        let response = arr.reversed();
        assert(response.len() == 0, 'response len should be 0');
    }
}

mod contains {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let arr = get_felt252_array();
        assert(arr.contains(@21) == true, 'arrays should match');
        assert(arr.contains(@42) == true, 'arrays should match');
        assert(arr.contains(@84) == true, 'arrays should match');
        assert(!arr.contains(@1) == true, 'arrays should match');
    }

    #[test]
    fn of_u128() {
        let arr = get_u128_array();
        assert(arr.contains(@21_u128) == true, 'arrays should match');
        assert(arr.contains(@42_u128) == true, 'arrays should match');
        assert(arr.contains(@84_u128) == true, 'arrays should match');
        assert(!arr.contains(@1) == true, 'arrays should match');
    }

    #[test]
    fn empty_array() {
        let arr: Array<felt252> = array![];
        assert(!arr.contains(@21) == true, 'arrays should match');
    }
}

mod position {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let arr = get_felt252_array();
        assert(arr.position(@21).unwrap() == 0, 'arrays should match');
        assert(arr.position(@42).unwrap() == 1, 'arrays should match');
        assert(arr.position(@84).unwrap() == 2, 'arrays should match');
        assert(arr.position(@12).is_none() == true, 'arrays should match');
    }

    #[test]
    fn of_u128() {
        let arr = get_u128_array();
        assert(arr.position(@21_u128).unwrap() == 0, 'arrays should match');
        assert(arr.position(@42_u128).unwrap() == 1, 'arrays should match');
        assert(arr.position(@84_u128).unwrap() == 2, 'arrays should match');
        assert(arr.position(@12_u128).is_none() == true, 'arrays should match');
    }

    #[test]
    fn empty_array() {
        let arr: Array<felt252> = array![];
        assert(arr.position(@21).is_none() == true, 'arrays should match');
    }
}

mod occurrences {
    use super::ArrayTraitExt;

    #[test]
    fn of_felt() {
        let arr = array![1, 2, 2, 3, 3, 3];
        assert(arr.occurrences(@1) == 1, 'arrays should match');
        assert(arr.occurrences(@2) == 2, 'arrays should match');
        assert(arr.occurrences(@3) == 3, 'arrays should match');
        assert(arr.occurrences(@42) == 0, 'arrays should match');
    }

    #[test]
    fn of_u128() {
        let arr = array![1_u128, 2_u128, 2_u128, 3_u128, 3_u128, 3_u128];
        assert(arr.occurrences(@1_u128) == 1, 'arrays should match');
        assert(arr.occurrences(@2_u128) == 2, 'arrays should match');
        assert(arr.occurrences(@3_u128) == 3, 'arrays should match');
        assert(arr.occurrences(@42_u128) == 0, 'arrays should match');
    }

    #[test]
    fn empty_array() {
        let arr: Array<felt252> = array![];
        assert!(arr.occurrences(@21) == 0);
    }
}

mod min {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_u128_array();
        assert!(arr.min().unwrap() == 21_u128);
        assert!(arr.len() == 3);
        arr.append(20_u128);
        assert!(arr.min().unwrap() == 20_u128);
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array();
        assert(arr.min().unwrap() == 21_u128, 'arrays should match');
        assert(arr.len() == 3, 'arr len should be 3');
        arr.append(20_u128);
        assert(arr.min().unwrap() == 20_u128, 'arrays should match');
    }

    #[test]
    fn one_item() {
        let arr = array![21_u128];
        assert!(arr.min().unwrap() == 21_u128);
        assert!(arr.len() == 1);
    }

    #[test]
    fn empty() {
        let arr: Array<u128> = array![];
        assert(arr.min().is_none() == true, 'arrays should match');
    }
}


mod min_position {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array();
        assert!(arr.min_position().unwrap() == 0);
        assert!(arr.len() == 3);
        arr.append(21_u128);
        assert!(arr.min_position().unwrap() == 0);
        arr.append(20_u128);
        assert!(arr.min_position().unwrap() == 4);
    }

    #[test]
    fn min_position_empty_array() {
        let arr: Array<u128> = array![];
        assert!(arr.min_position().is_none());
    }

    #[test]
    fn min_position_one_item() {
        let arr = array![21_u128];
        assert!(arr.min_position().unwrap() == 0);
    }
}

mod max {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    fn max() {
        let mut arr = get_u128_array();

        assert!(arr.max().unwrap() == 84_u128);
        arr.append(85_u128);
        assert!(arr.max().unwrap() == 85_u128);
    }
    #[test]
    fn max_empty_array() {
        let arr: Array<u128> = array![];
        assert!(arr.position(@12).is_none());
    }

    #[test]
    fn max_one_item() {
        let arr = array![21_u128];
        assert!(arr.max().unwrap() == 21_u128);
    }

    #[test]
    fn empty() {
        let arr: Array<u128> = array![];
        assert(arr.max().is_none() == true, 'arrays should match');
    }
}


mod max_position {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    fn max_position() {
        let mut arr = get_u128_array();
        assert!(arr.max_position().unwrap() == 2);
        assert!(arr.len() == 3);
        arr.append(84_u128);
        assert!(arr.max_position().unwrap() == 2);
        arr.append(85_u128);
        assert!(arr.max_position().unwrap() == 4);
    }

    #[test]
    fn max_position_empty_array() {
        let arr: Array<u128> = array![];
        assert!(arr.max_position().is_none());
    }

    #[test]
    fn max_position_one_item() {
        let arr = array![21_u128];
        assert!(arr.max_position().unwrap() == 0);
        assert!(arr.len() == 1);
    }
}

mod dedup {
    use super::ArrayTraitExt;

    #[test]
    fn all_different() {
        let arr = array![1, 2, 3, 4];
        let new_arr = arr.dedup();

        assert!(new_arr == arr);
    }

    #[test]
    fn one_match() {
        let arr = array![1, 2, 2, 3, 4];
        let new_arr = arr.dedup();

        assert!(new_arr == array![1, 2, 3, 4]);
    }

    #[test]
    fn two_matches() {
        let arr = array![1, 2, 2, 3, 4, 4];
        let new_arr = arr.dedup();

        assert!(new_arr == array![1, 2, 3, 4]);
    }

    #[test]
    fn one_match_more() {
        let arr = array![1, 2, 2, 2, 3, 4, 4];
        let new_arr = arr.dedup();

        assert!(new_arr == array![1, 2, 3, 4]);
    }

    #[test]
    fn all_same() {
        let arr = array![2, 2, 2, 2];
        let new_arr = arr.dedup();

        assert(*new_arr[0] == 2, 'new_arr[0] should be 2');
        assert(new_arr.len() == 1, 'new_arr len should be 1');
    }

    #[test]
    fn one_elem() {
        let arr = array![2];
        let new_arr = arr.dedup();

        assert!(new_arr == arr);
    }

    #[test]
    fn no_elem() {
        let arr: Array<u128> = array![];
        let new_arr = arr.dedup();

        assert!(new_arr == arr);
    }

    #[test]
    fn multiple_duplicates_same() {
        let mut arr = array![1, 1, 3, 4, 3, 3, 3, 4, 2, 2];
        let new_arr = arr.dedup();

        assert!(new_arr.len() == 6);
        assert!(*new_arr[0] == 1);
        assert!(*new_arr[1] == 3);
        assert!(*new_arr[2] == 4);
        assert!(*new_arr[3] == 3);
        assert!(*new_arr[4] == 4);
        assert!(*new_arr[5] == 2);
    }
}

mod unique {
    use super::ArrayTraitExt;

    #[test]
    fn one_duplicate() {
        let arr = array![32_u128, 256_u128, 128_u128, 256_u128, 1024_u128];

        let out_arr = arr.unique();

        assert!(out_arr.len() == 4);
        assert!(*out_arr[0] == 32_u128);
        assert!(*out_arr[1] == 256_u128);
        assert!(*out_arr[2] == 128_u128);
        assert!(*out_arr[3] == 1024_u128);
    }

    #[test]
    fn all_same() {
        let arr = array![84_u128, 84_u128, 84_u128];

        let out_arr = arr.unique();

        assert!(out_arr.len() == 1);
        assert!(*out_arr[0] == 84_u128);
    }

    #[test]
    fn empty() {
        let arr: Array<u128> = array![];

        let out_arr = arr.unique();

        assert!(out_arr.is_empty());
    }

    #[test]
    fn duplicate_front() {
        let arr = array![16_u128, 16_u128, 16_u128, 128_u128, 64_u128, 32_u128];

        let out_arr = arr.unique();

        assert!(out_arr.len() == 4);
        assert!(*out_arr[0] == 16_u128);
        assert!(*out_arr[1] == 128_u128);
        assert!(*out_arr[2] == 64_u128);
        assert!(*out_arr[3] == 32_u128);
    }

    #[test]
    fn duplicate_middle() {
        let arr = array![128_u128, 256_u128, 84_u128, 84_u128, 84_u128, 1_u128];

        let out_arr = arr.unique();

        assert!(out_arr.len() == 4);
        assert!(*out_arr[0] == 128_u128);
        assert!(*out_arr[1] == 256_u128);
        assert!(*out_arr[2] == 84_u128);
        assert!(*out_arr[3] == 1_u128);
    }

    #[test]
    fn duplicate_back() {
        let arr = array![32_u128, 16_u128, 64_u128, 128_u128, 128_u128, 128_u128];

        let out_arr = arr.unique();

        assert!(out_arr.len() == 4);
        assert!(*out_arr[0] == 32_u128);
        assert!(*out_arr[1] == 16_u128);
        assert!(*out_arr[2] == 64_u128);
        assert!(*out_arr[3] == 128_u128);
    }

    #[test]
    fn without_duplicates() {
        let arr = array![42_u128, 84_u128, 21_u128];

        let out_arr = arr.unique();

        assert!(out_arr == arr);
    }
}

