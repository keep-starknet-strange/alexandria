use alexandria_data_structures::array_ext::ArrayTraitExt;
use super::{get_felt252_array, get_u128_array};

mod append_all {
    use super::{ArrayTraitExt, get_felt252_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut destination = array![21];
        let mut source = array![42, 84];

        destination.append_all(ref source);

        // destination should be filled
        assert_eq!(destination.len(), 3);
        assert_eq!(destination[0], @21);
        assert_eq!(destination[1], @42);
        assert_eq!(destination[2], @84);

        // source should be empty
        assert_eq!(source.len(), 0);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut destination = array![21_u128];
        let mut source = array![42_u128, 84_u128];

        destination.append_all(ref source);

        // destination should be filled
        assert_eq!(destination.len(), 3);
        assert_eq!(destination[0], @21_u128);
        assert_eq!(destination[1], @42_u128);
        assert_eq!(destination[2], @84_u128);

        // source should be empty
        assert_eq!(source.len(), 0);
    }

    #[test]
    #[available_gas(2000000)]
    fn destination_empty() {
        let mut destination: Array<felt252> = array![];
        let mut source = get_felt252_array();

        destination.append_all(ref source);

        assert_eq!(destination.len(), 3);
        assert_eq!(destination[0], @21);
        assert_eq!(destination[1], @42);
        assert_eq!(destination[2], @84);
    }

    #[test]
    #[available_gas(2000000)]
    fn source_empty() {
        let mut destination: Array<felt252> = array![];
        let mut source = get_felt252_array();

        destination.append_all(ref source);

        assert_eq!(destination.len(), 3);
        assert_eq!(destination[0], @21);
        assert_eq!(destination[1], @42);
        assert_eq!(destination[2], @84);
    }

    #[test]
    #[available_gas(2000000)]
    fn both_empty() {
        let mut destination: Array<felt252> = array![];
        let mut source = array![];

        destination.append_all(ref source);

        assert_eq!(source.len(), 0);
        assert_eq!(destination.len(), 0);
    }
}

mod extend_from_span {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array();
        let span = array![1, 2, 3].span();

        arr.extend_from_span(span);

        assert_eq!(arr, array![21, 42, 84, 1, 2, 3]);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array();
        let span = array![1_u128, 2_u128, 3_u128].span();

        arr.extend_from_span(span);

        assert_eq!(arr, array![21_u128, 42_u128, 84_u128, 1_u128, 2_u128, 3_u128]);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let mut arr1 = array![];
        let arr2 = array![1, 2, 3];

        arr1.extend_from_span(arr2.span());

        assert_eq!(arr1, arr2);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_span() {
        let mut arr1 = array![1, 2, 3];
        let arr2 = array![];

        arr1.extend_from_span(arr2.span());

        assert_eq!(arr1, array![1, 2, 3]);
    }

    #[test]
    #[available_gas(2000000)]
    fn from_self() {
        let mut arr = array![1, 2, 3];

        arr.extend_from_span(arr.span());

        assert_eq!(arr, array![1, 2, 3, 1, 2, 3]);
    }
}

mod concat {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let arr1 = get_felt252_array();
        let arr2 = array![1, 2, 3];

        let concatenated = arr1.concat(@arr2);

        assert_eq!(concatenated, array![21, 42, 84, 1, 2, 3]);
        // arr1 is untouched
        assert_eq!(arr1, get_felt252_array());
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let arr1 = get_u128_array();
        let arr2 = array![1_u128, 2_u128, 3_u128];

        let concatenated = arr1.concat(@arr2);

        assert_eq!(concatenated, array![21_u128, 42_u128, 84_u128, 1_u128, 2_u128, 3]);
        // arr1 is untouched
        assert_eq!(arr1, get_u128_array());
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array_1() {
        let arr1 = array![];
        let arr2 = get_felt252_array();

        let concatenated = arr1.concat(@arr2);
        assert_eq!(concatenated, arr2);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array_2() {
        let arr1 = get_felt252_array();
        let arr2 = array![];

        let concatenated = arr1.concat(@arr2);
        assert_eq!(concatenated, arr1);
    }

    #[test]
    #[available_gas(2000000)]
    fn both_empty() {
        let arr1 = core::array::ArrayTrait::<felt252>::new();
        let arr2 = array![];

        let concatenated = arr1.concat(@arr2);

        assert!(concatenated.is_empty());
    }
}

mod pop_front_n {
    use super::{ArrayTraitExt, get_u128_array, get_felt252_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array();

        let poped = arr.pop_front_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(*arr[0], 84);

        assert_eq!(poped.len(), 2);
        assert_eq!(*poped[0], 21);
        assert_eq!(*poped[1], 42);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array();

        arr.pop_front_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(*arr[0], 84);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let mut arr: Array<felt252> = array![];

        let poped = arr.pop_front_n(2);

        assert!(arr.is_empty());
        assert!(poped.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn pop_zero() {
        let mut arr = get_felt252_array();

        let poped = arr.pop_front_n(0);

        assert_eq!(arr.len(), 3);
        assert_eq!(arr.pop_front().unwrap(), 21);
        assert_eq!(arr.pop_front().unwrap(), 42);
        assert_eq!(arr.pop_front().unwrap(), 84);
        assert!(poped.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn exact_len() {
        let mut arr = get_felt252_array();

        let poped = arr.pop_front_n(3);

        assert!(arr.is_empty());
        assert_eq!(poped.len(), 3);
    }

    #[test]
    #[available_gas(2000000)]
    fn more_then_len() {
        let mut arr = get_felt252_array();

        arr.pop_front_n(4);

        assert!(arr.is_empty());
    }
}

mod remove_front_n {
    use super::{ArrayTraitExt, get_u128_array, get_felt252_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(*arr[0], 84);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array();

        arr.remove_front_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(*arr[0], 84);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let mut arr: Array<felt252> = array![];

        arr.remove_front_n(2);

        assert!(arr.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn remove_zero() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(0);

        assert_eq!(arr.len(), 3);
        assert_eq!(arr[0], @21);
        assert_eq!(arr[1], @42);
        assert_eq!(arr[2], @84);
    }

    #[test]
    #[available_gas(2000000)]
    fn exact_len() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(3);

        assert!(arr.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn more_then_len() {
        let mut arr = get_felt252_array();

        arr.remove_front_n(4);

        assert!(arr.is_empty());
    }
}

mod reversed {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array();

        let response = arr.reversed();

        assert_eq!(response.len(), 3);
        assert_eq!(response, array![84, 42, 21]);
        // Original untouched
        assert_eq!(arr, get_felt252_array());
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array();

        let response = arr.reversed();

        assert_eq!(response.len(), 3);
        assert_eq!(response, array![84_u128, 42_u128, 21_u128]);
    }

    #[test]
    #[available_gas(2000000)]
    fn even() {
        let mut arr = array![21, 42];

        let response = arr.reversed();

        assert_eq!(response.len(), 2);
        assert_eq!(response, array![42, 21]);
    }

    #[test]
    #[available_gas(2000000)]
    fn size_1() {
        let mut arr = array![21];

        let response = arr.reversed();

        assert_eq!(response.len(), 1);
        assert_eq!(response[0], @21);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty() {
        let mut arr: Array<felt252> = array![];
        let response = arr.reversed();
        assert_eq!(response.len(), 0);
    }
}

mod contains {
    use super::{ArrayTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let arr = get_felt252_array();
        assert!(arr.contains(@21));
        assert!(arr.contains(@42));
        assert!(arr.contains(@84));
        assert!(!arr.contains(@1));
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let arr = get_u128_array();
        assert!(arr.contains(@21_u128));
        assert!(arr.contains(@42_u128));
        assert!(arr.contains(@84_u128));
        assert!(!arr.contains(@1));
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let arr: Array<felt252> = array![];
        assert!(!arr.contains(@21));
    }
}

mod position {
    use super::{ArrayTraitExt, get_u128_array, get_felt252_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let arr = get_felt252_array();
        assert_eq!(arr.position(@21).unwrap(), 0);
        assert_eq!(arr.position(@42).unwrap(), 1);
        assert_eq!(arr.position(@84).unwrap(), 2);
        assert!(arr.position(@12).is_none());
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let arr = get_u128_array();
        assert_eq!(arr.position(@21_u128).unwrap(), 0);
        assert_eq!(arr.position(@42_u128).unwrap(), 1);
        assert_eq!(arr.position(@84_u128).unwrap(), 2);
        assert!(arr.position(@12_u128).is_none());
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let arr: Array<felt252> = array![];
        assert!(arr.position(@21).is_none());
    }
}

mod occurrences {
    use super::{ArrayTraitExt, get_u128_array, get_felt252_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let arr = array![1, 2, 2, 3, 3, 3];
        assert_eq!(arr.occurrences(@1), 1);
        assert_eq!(arr.occurrences(@2), 2);
        assert_eq!(arr.occurrences(@3), 3);
        assert_eq!(arr.occurrences(@42), 0);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let arr = array![1_u128, 2_u128, 2_u128, 3_u128, 3_u128, 3_u128];
        assert_eq!(arr.occurrences(@1_u128), 1);
        assert_eq!(arr.occurrences(@2_u128), 2);
        assert_eq!(arr.occurrences(@3_u128), 3);
        assert_eq!(arr.occurrences(@42_u128), 0);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let arr: Array<felt252> = array![];
        assert_eq!(arr.occurrences(@21), 0);
    }
}

mod min {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_u128_array();
        assert_eq!(arr.min().unwrap(), 21_u128);
        assert_eq!(arr.len(), 3);
        arr.append(20_u128);
        assert_eq!(arr.min().unwrap(), 20_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array();
        assert_eq!(arr.min().unwrap(), 21_u128);
        assert_eq!(arr.len(), 3);
        arr.append(20_u128);
        assert_eq!(arr.min().unwrap(), 20_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn one_item() {
        let arr = array![21_u128];
        assert_eq!(arr.min().unwrap(), 21_u128);
        assert_eq!(arr.len(), 1);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty() {
        let arr: Array<u128> = array![];
        assert!(arr.min().is_none());
    }
}


mod min_position {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array();
        assert_eq!(arr.min_position().unwrap(), 0);
        assert_eq!(arr.len(), 3);
        arr.append(21_u128);
        assert_eq!(arr.min_position().unwrap(), 0);
        arr.append(20_u128);
        assert_eq!(arr.min_position().unwrap(), 4);
    }

    #[test]
    #[available_gas(2000000)]
    fn min_position_empty_array() {
        let arr: Array<u128> = array![];
        assert!(arr.min_position().is_none());
    }

    #[test]
    #[available_gas(2000000)]
    fn min_position_one_item() {
        let arr = array![21_u128];
        assert_eq!(arr.min_position().unwrap(), 0);
    }
}

mod max {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn max() {
        let mut arr = get_u128_array();

        assert_eq!(arr.max().unwrap(), 84_u128);
        arr.append(85_u128);
        assert_eq!(arr.max().unwrap(), 85_u128);
    }
    #[test]
    #[available_gas(2000000)]
    fn max_empty_array() {
        let arr: Array<u128> = array![];
        assert!(arr.position(@12).is_none());
    }

    #[test]
    #[available_gas(2000000)]
    fn max_one_item() {
        let arr = array![21_u128];
        assert_eq!(arr.max().unwrap(), 21_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty() {
        let arr: Array<u128> = array![];
        assert!(arr.max().is_none());
    }
}


mod max_position {
    use super::{ArrayTraitExt, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn max_position() {
        let mut arr = get_u128_array();
        assert_eq!(arr.max_position().unwrap(), 2);
        assert_eq!(arr.len(), 3);
        arr.append(84_u128);
        assert_eq!(arr.max_position().unwrap(), 2);
        arr.append(85_u128);
        assert_eq!(arr.max_position().unwrap(), 4);
    }

    #[test]
    #[available_gas(2000000)]
    fn max_position_empty_array() {
        let arr: Array<u128> = array![];
        assert!(arr.max_position().is_none());
    }

    #[test]
    #[available_gas(2000000)]
    fn max_position_one_item() {
        let arr = array![21_u128];
        assert_eq!(arr.max_position().unwrap(), 0);
        assert_eq!(arr.len(), 1);
    }
}

mod dedup {
    use super::{ArrayTraitExt, get_u128_array, get_felt252_array};

    #[test]
    #[available_gas(2000000)]
    fn all_different() {
        let arr = array![1, 2, 3, 4];
        let new_arr = arr.dedup();

        assert_eq!(new_arr, arr);
    }

    #[test]
    #[available_gas(2000000)]
    fn one_match() {
        let arr = array![1, 2, 2, 3, 4];
        let new_arr = arr.dedup();

        assert_eq!(new_arr, array![1, 2, 3, 4]);
    }

    #[test]
    #[available_gas(2000000)]
    fn two_matches() {
        let arr = array![1, 2, 2, 3, 4, 4];
        let new_arr = arr.dedup();

        assert_eq!(new_arr, array![1, 2, 3, 4]);
    }

    #[test]
    #[available_gas(2000000)]
    fn one_match_more() {
        let arr = array![1, 2, 2, 2, 3, 4, 4];
        let new_arr = arr.dedup();

        assert_eq!(new_arr, array![1, 2, 3, 4]);
    }

    #[test]
    #[available_gas(2000000)]
    fn all_same() {
        let arr = array![2, 2, 2, 2];
        let new_arr = arr.dedup();

        assert_eq!(*new_arr[0], 2);
        assert_eq!(new_arr.len(), 1);
    }

    #[test]
    #[available_gas(2000000)]
    fn one_elem() {
        let arr = array![2];
        let new_arr = arr.dedup();

        assert_eq!(new_arr, arr);
    }

    #[test]
    #[available_gas(2000000)]
    fn no_elem() {
        let arr: Array<u128> = array![];
        let new_arr = arr.dedup();

        assert_eq!(new_arr, arr);
    }

    #[test]
    #[available_gas(2000000)]
    fn multiple_duplicates_same() {
        let mut arr = array![1, 1, 3, 4, 3, 3, 3, 4, 2, 2];
        let new_arr = arr.dedup();

        assert_eq!(new_arr.len(), 6);
        assert_eq!(*new_arr[0], 1);
        assert_eq!(*new_arr[1], 3);
        assert_eq!(*new_arr[2], 4);
        assert_eq!(*new_arr[3], 3);
        assert_eq!(*new_arr[4], 4);
        assert_eq!(*new_arr[5], 2);
    }
}

mod unique {
    use super::{ArrayTraitExt, get_u128_array, get_felt252_array};

    #[test]
    #[available_gas(2000000)]
    fn one_duplicate() {
        let arr = array![32_u128, 256_u128, 128_u128, 256_u128, 1024_u128];

        let out_arr = arr.unique();

        assert_eq!(out_arr.len(), 4);
        assert_eq!(*out_arr[0], 32_u128);
        assert_eq!(*out_arr[1], 256_u128);
        assert_eq!(*out_arr[2], 128_u128);
        assert_eq!(*out_arr[3], 1024_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn all_same() {
        let arr = array![84_u128, 84_u128, 84_u128];

        let out_arr = arr.unique();

        assert_eq!(out_arr.len(), 1);
        assert_eq!(*out_arr[0], 84_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty() {
        let arr: Array<u128> = array![];

        let out_arr = arr.unique();

        assert!(out_arr.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn duplicate_front() {
        let arr = array![16_u128, 16_u128, 16_u128, 128_u128, 64_u128, 32_u128];

        let out_arr = arr.unique();

        assert_eq!(out_arr.len(), 4);
        assert_eq!(*out_arr[0], 16_u128);
        assert_eq!(*out_arr[1], 128_u128);
        assert_eq!(*out_arr[2], 64_u128);
        assert_eq!(*out_arr[3], 32_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn duplicate_middle() {
        let arr = array![128_u128, 256_u128, 84_u128, 84_u128, 84_u128, 1_u128];

        let out_arr = arr.unique();

        assert_eq!(out_arr.len(), 4);
        assert_eq!(*out_arr[0], 128_u128);
        assert_eq!(*out_arr[1], 256_u128);
        assert_eq!(*out_arr[2], 84_u128);
        assert_eq!(*out_arr[3], 1_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn duplicate_back() {
        let arr = array![32_u128, 16_u128, 64_u128, 128_u128, 128_u128, 128_u128];

        let out_arr = arr.unique();

        assert_eq!(out_arr.len(), 4);
        assert_eq!(*out_arr[0], 32_u128);
        assert_eq!(*out_arr[1], 16_u128);
        assert_eq!(*out_arr[2], 64_u128);
        assert_eq!(*out_arr[3], 128_u128);
    }

    #[test]
    #[available_gas(2000000)]
    fn without_duplicates() {
        let arr = array![42_u128, 84_u128, 21_u128];

        let out_arr = arr.unique();

        assert_eq!(out_arr, arr);
    }
}

