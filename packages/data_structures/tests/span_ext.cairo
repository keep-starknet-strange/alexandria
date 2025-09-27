use alexandria_data_structures::span_ext::SpanTraitExt;

#[inline(always)]
fn get_felt252_array() -> Array<felt252> {
    array![21, 42, 84]
}

#[inline(always)]
fn get_u128_array() -> Array<u128> {
    array![21_u128, 42_u128, 84_u128]
}

mod pop_front_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'values should match');
        assert(poped.len() == 2, 'poped len should be 2');
        assert(*poped[0] == 21, 'values should match');
        assert(*poped[1] == 42, 'values should match');
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array().span();

        arr.pop_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'values should match');
    }

    #[test]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        let poped = arr.pop_front_n(2);

        assert(arr.is_empty(), 'arr should be empty');
        assert(poped.is_empty(), 'poped should be empty');
    }

    #[test]
    fn pop_zero() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_front_n(0);

        assert(arr.len() == 3, 'arr len should be 3');
        assert(arr.pop_front().unwrap() == @21, 'values should match');
        assert(arr.pop_front().unwrap() == @42, 'values should match');
        assert(arr.pop_front().unwrap() == @84, 'values should match');
        assert(poped.is_empty(), 'poped should be empty');
    }

    #[test]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_front_n(3);

        assert(arr.is_empty(), 'arr should be empty');
        assert(poped.len() == 3, 'poped len should be 3');
    }

    #[test]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.pop_front_n(4);

        assert(arr.is_empty(), 'arr should be empty');
    }
}

mod pop_back_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_back_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(arr[0] == @21, 'values should match');
        assert(poped.len() == 2, 'poped len should be 2');
        assert(poped[0] == @42, 'values should match');
        assert(poped[1] == @84, 'values should match');
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array().span();

        arr.pop_back_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(arr[0] == @21, 'values should match');
    }

    #[test]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        let poped = arr.pop_back_n(2);

        assert(arr.is_empty(), 'arr should be empty');
        assert(poped.is_empty(), 'poped should be empty');
    }

    #[test]
    fn pop_zero() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_back_n(0);

        assert!(arr.len() == 3);
        assert!(arr[0] == @21);
        assert!(arr[1] == @42);
        assert!(arr[2] == @84);
        assert!(poped.is_empty());
    }

    #[test]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_back_n(3);

        assert(arr.is_empty(), 'arr should be empty');
        assert(poped.len() == 3, 'poped len should be 3');
    }

    #[test]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.pop_back_n(4);

        assert(arr.is_empty(), 'arr should be empty');
    }
}

mod remove_front_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'values should match');
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array().span();

        arr.remove_front_n(2);

        assert(arr.len() == 1, 'arr len should be 1');
        assert(*arr[0] == 84, 'values should match');
    }

    #[test]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        arr.remove_front_n(2);

        assert(arr.is_empty(), 'arr should be empty');
    }

    #[test]
    fn remove_zero() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(0);

        assert(arr.len() == 3, 'arr len should be 3');
        assert(arr[0] == @21, 'values should match');
        assert(arr[1] == @42, 'values should match');
        assert(arr[2] == @84, 'values should match');
    }

    #[test]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(3);

        assert(arr.is_empty(), 'arr should be empty');
    }

    #[test]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(4);

        assert(arr.is_empty(), 'arr should be empty');
    }
}

mod remove_back_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(2);

        assert!(arr.len() == 1);
        assert!(arr[0] == @21);
    }

    #[test]
    fn of_u128() {
        let mut arr = get_u128_array().span();

        arr.remove_back_n(2);

        assert!(arr.len() == 1);
        assert!(arr[0] == @21);
    }

    #[test]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        arr.remove_back_n(2);

        assert!(arr.is_empty());
    }

    #[test]
    fn remove_zero() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(0);

        assert!(arr.len() == 3);
        assert!(arr[0] == @21);
        assert!(arr[1] == @42);
        assert!(arr[2] == @84);
    }

    #[test]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(3);

        assert!(arr.is_empty());
    }

    #[test]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(4);

        assert!(arr.is_empty());
    }
}
// All the other methods are already tested by the ArrayTraitExt tests,
// as they internally call their SpanTraitExt counterpart


