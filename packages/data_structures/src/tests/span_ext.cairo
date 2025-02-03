use alexandria_data_structures::span_ext::SpanTraitExt;
use super::{get_felt252_array, get_u128_array};

mod pop_front_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

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
        let mut arr = get_u128_array().span();

        arr.pop_front_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(*arr[0], 84);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        let poped = arr.pop_front_n(2);

        assert!(arr.is_empty());
        assert!(poped.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn pop_zero() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_front_n(0);

        assert_eq!(arr.len(), 3);
        assert_eq!(arr.pop_front().unwrap(), @21);
        assert_eq!(arr.pop_front().unwrap(), @42);
        assert_eq!(arr.pop_front().unwrap(), @84);
        assert!(poped.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_front_n(3);

        assert!(arr.is_empty());
        assert_eq!(poped.len(), 3);
    }

    #[test]
    #[available_gas(2000000)]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.pop_front_n(4);

        assert!(arr.is_empty());
    }
}

mod pop_back_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_back_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(arr[0], @21);
        assert_eq!(poped.len(), 2);
        assert_eq!(poped[0], @42);
        assert_eq!(poped[1], @84);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array().span();

        arr.pop_back_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(arr[0], @21);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        let poped = arr.pop_back_n(2);

        assert!(arr.is_empty());
        assert!(poped.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn pop_zero() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_back_n(0);

        assert_eq!(arr.len(), 3);
        assert_eq!(arr[0], @21);
        assert_eq!(arr[1], @42);
        assert_eq!(arr[2], @84);
        assert!(poped.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        let poped = arr.pop_back_n(3);

        assert!(arr.is_empty());
        assert_eq!(poped.len(), 3);
    }

    #[test]
    #[available_gas(2000000)]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.pop_back_n(4);

        assert!(arr.is_empty());
    }
}

mod remove_front_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(*arr[0], 84);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array().span();

        arr.remove_front_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(*arr[0], 84);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        arr.remove_front_n(2);

        assert!(arr.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn remove_zero() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(0);

        assert_eq!(arr.len(), 3);
        assert_eq!(arr[0], @21);
        assert_eq!(arr[1], @42);
        assert_eq!(arr[2], @84);
    }

    #[test]
    #[available_gas(2000000)]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(3);

        assert!(arr.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_front_n(4);

        assert!(arr.is_empty());
    }
}

mod remove_back_n {
    use super::{SpanTraitExt, get_felt252_array, get_u128_array};

    #[test]
    #[available_gas(2000000)]
    fn of_felt() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(arr[0], @21);
    }

    #[test]
    #[available_gas(2000000)]
    fn of_u128() {
        let mut arr = get_u128_array().span();

        arr.remove_back_n(2);

        assert_eq!(arr.len(), 1);
        assert_eq!(arr[0], @21);
    }

    #[test]
    #[available_gas(2000000)]
    fn empty_array() {
        let mut arr: Span<felt252> = array![].span();

        arr.remove_back_n(2);

        assert!(arr.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn remove_zero() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(0);

        assert_eq!(arr.len(), 3);
        assert_eq!(arr[0], @21);
        assert_eq!(arr[1], @42);
        assert_eq!(arr[2], @84);
    }

    #[test]
    #[available_gas(2000000)]
    fn exact_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(3);

        assert!(arr.is_empty());
    }

    #[test]
    #[available_gas(2000000)]
    fn more_then_len() {
        let mut arr = get_felt252_array().span();

        arr.remove_back_n(4);

        assert!(arr.is_empty());
    }
}
// All the other methods are already tested by the ArrayTraitExt tests,
// as they internally call their SpanTraitExt counterpart


