/// Performs binary search on a sorted span to find the exact position of a target value.
///
/// Time complexity: O(log n)
/// Space complexity: O(log n) due to recursion
///
/// #### Arguments
/// * `span` - A sorted span of elements to search in
/// * `val` - The target value to search for
///
/// #### Returns
/// * `Option<u32>` - Some(index) if value is found, None if not found
///
/// #### Requirements
/// * The input span must be sorted in ascending order
/// * Type T must implement Copy, Drop, PartialEq, and PartialOrd traits
pub fn binary_search<T, +Copy<T>, +Drop<T>, +PartialEq<T>, +PartialOrd<T>>(
    span: Span<T>, val: T,
) -> Option<u32> {
    // Initial check
    if span.len() == 0 {
        return Option::None;
    }
    let middle = span.len() / 2;
    if *span[middle] == val {
        return Option::Some(middle);
    }
    if span.len() == 1 {
        return Option::None;
    }
    if *span[middle] > val {
        return binary_search(span.slice(0, middle), val);
    }

    let mut len = middle;
    if span.len() % 2 == 1 {
        len += 1;
    }
    let val = binary_search(span.slice(middle, len), val);
    match val {
        Option::Some(v) => Option::Some(v + middle),
        Option::None => Option::None,
    }
}

/// Performs binary search to find the position where a value would be inserted
/// to maintain sorted order, or the closest position to the target value.
///
/// Time complexity: O(log n)
/// Space complexity: O(log n) due to recursion
///
/// #### Arguments
/// * `span` - A sorted span of elements to search in
/// * `val` - The target value to find the closest position for
///
/// #### Returns
/// * `Option<u32>` - Some(index) of the closest position, None if span is empty or no valid
/// position
///
/// #### Requirements
/// * The input span must be sorted in ascending order
/// * Type T must implement Copy, Drop, and PartialOrd traits
///
/// #### Behavior
/// * Returns the index where val would fit in the sorted order
/// * Useful for insertion points and range queries
pub fn binary_search_closest<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(
    span: Span<T>, val: T,
) -> Option<u32> {
    // Initial check
    if (span.len() == 0) {
        return Option::None;
    }
    let middle = span.len() / 2;
    if (*span[middle] <= val && val <= *span[middle]) {
        return Option::Some(middle);
    }
    if (span.len() == 1) {
        return Option::None;
    }
    if (span.len() == 2) {
        if (*span[0] <= val && val < *span[1]) {
            return Option::Some(0);
        } else {
            return Option::None;
        }
    }

    let mut len = middle;
    if (middle * 2 < span.len()) {
        len += 1;
    }
    if (*span[middle] > val) {
        let index = binary_search_closest(span.slice(0, middle + 1), val);
        match index {
            Option::Some(v) => Option::Some(v),
            Option::None => Option::None,
        }
    } else {
        let index = binary_search_closest(span.slice(middle, len), val);
        match index {
            Option::Some(v) => Option::Some(v + middle),
            Option::None => Option::None,
        }
    }
}
