use super::span_ext::SpanTraitExt;

pub trait ArrayTraitExt<T, +Clone<T>, +Drop<T>> {
    /// Moves all the elements of `other` into `self`, leaving `other` empty.
    ///
    /// #### Arguments
    /// * `self` - The array to append elements to
    /// * `other` - The array to move elements from
    fn append_all(ref self: Array<T>, ref other: Array<T>);
    /// Clones and appends all the elements of `other` into `self`.
    ///
    /// #### Arguments
    /// * `self` - The array to extend
    /// * `other` - The span containing elements to clone and append
    fn extend_from_span(ref self: Array<T>, other: Span<T>);
    /// Removes up to `n` elements from the front of `self` and returns them in a new array.
    ///
    /// #### Arguments
    /// * `self` - The array to remove elements from
    /// * `n` - The maximum number of elements to remove
    ///
    /// #### Returns
    /// * `Array<T>` - New array containing the removed elements
    fn pop_front_n(ref self: Array<T>, n: usize) -> Array<T>;
    /// Removes up to `n` elements from the front of `self`.
    ///
    /// #### Arguments
    /// * `self` - The array to remove elements from
    /// * `n` - The maximum number of elements to remove
    fn remove_front_n(ref self: Array<T>, n: usize);
    /// Clones and appends all the elements of `self` and then `other` in a single new array.
    ///
    /// #### Arguments
    /// * `self` - The first array to concatenate
    /// * `other` - The second array to concatenate
    ///
    /// #### Returns
    /// * `Array<T>` - New array containing elements from both arrays
    fn concat(self: @Array<T>, other: @Array<T>) -> Array<T>;
    /// Return a new array containing the elements of `self` in a reversed order.
    ///
    /// #### Arguments
    /// * `self` - The array to reverse
    ///
    /// #### Returns
    /// * `Array<T>` - New array with elements in reverse order
    fn reversed(self: @Array<T>) -> Array<T>;
    /// Returns `true` if the array contains an element with the given value.
    ///
    /// #### Arguments
    /// * `self` - The array to search
    /// * `item` - The item to search for
    ///
    /// #### Returns
    /// * `bool` - True if the item is found, false otherwise
    fn contains<+PartialEq<T>>(self: @Array<T>, item: @T) -> bool;
    /// Searches for an element in the array, returning its index.
    ///
    /// #### Arguments
    /// * `self` - The array to search
    /// * `item` - The item to find the position of
    ///
    /// #### Returns
    /// * `Option<usize>` - Some(index) if found, None otherwise
    fn position<+PartialEq<T>>(self: @Array<T>, item: @T) -> Option<usize>;
    /// Returns the number of elements in the array with the given value.
    ///
    /// #### Arguments
    /// * `self` - The array to search
    /// * `item` - The item to count occurrences of
    ///
    /// #### Returns
    /// * `usize` - The number of times the item appears
    fn occurrences<+PartialEq<T>>(self: @Array<T>, item: @T) -> usize;
    /// Returns the minimum element of an array.
    ///
    /// #### Arguments
    /// * `self` - The array to find the minimum in
    ///
    /// #### Returns
    /// * `Option<T>` - Some(min_element) if array is not empty, None otherwise
    fn min<+PartialOrd<@T>>(self: @Array<T>) -> Option<T>;
    /// Returns the position of the minimum element of an array.
    ///
    /// #### Arguments
    /// * `self` - The array to find the minimum position in
    ///
    /// #### Returns
    /// * `Option<usize>` - Some(index) of minimum element, None if array is empty
    fn min_position<+PartialOrd<@T>>(self: @Array<T>) -> Option<usize>;
    /// Returns the maximum element of an array.
    ///
    /// #### Arguments
    /// * `self` - The array to find the maximum in
    ///
    /// #### Returns
    /// * `Option<T>` - Some(max_element) if array is not empty, None otherwise
    fn max<+PartialOrd<@T>>(self: @Array<T>) -> Option<T>;
    /// Returns the position of the maximum element of an array.
    ///
    /// #### Arguments
    /// * `self` - The array to find the maximum position in
    ///
    /// #### Returns
    /// * `Option<usize>` - Some(index) of maximum element, None if array is empty
    fn max_position<+PartialOrd<@T>>(self: @Array<T>) -> Option<usize>;
    /// Returns a new array, cloned from `self` but removes consecutive repeated elements.
    /// If the array is sorted, this removes all duplicates.
    ///
    /// #### Arguments
    /// * `self` - The array to deduplicate
    ///
    /// #### Returns
    /// * `Array<T>` - New array with consecutive duplicates removed
    fn dedup<+PartialEq<T>>(self: @Array<T>) -> Array<T>;
    /// Returns a new array, cloned from `self` but without any duplicate.
    ///
    /// #### Arguments
    /// * `self` - The array to remove duplicates from
    ///
    /// #### Returns
    /// * `Array<T>` - New array with all duplicates removed
    fn unique<+PartialEq<T>>(self: @Array<T>) -> Array<T>;
}

impl ArrayImpl<T, +Clone<T>, +Drop<T>> of ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref other: Array<T>) {
        while let Option::Some(elem) = other.pop_front() {
            self.append(elem);
        }
    }

    fn extend_from_span(ref self: Array<T>, mut other: Span<T>) {
        while let Option::Some(elem) = other.pop_front() {
            self.append(elem.clone());
        }
    }

    fn pop_front_n(ref self: Array<T>, mut n: usize) -> Array<T> {
        let mut res = array![];

        while (n != 0) {
            match self.pop_front() {
                Option::Some(e) => {
                    res.append(e);
                    n -= 1;
                },
                Option::None => { break; },
            };
        }

        res
    }

    fn remove_front_n(ref self: Array<T>, mut n: usize) {
        while (n != 0) {
            match self.pop_front() {
                Option::Some(_) => { n -= 1; },
                Option::None => { break; },
            };
        }
    }

    fn concat(self: @Array<T>, other: @Array<T>) -> Array<T> {
        self.span().concat(other.span())
    }

    fn reversed(self: @Array<T>) -> Array<T> {
        self.span().reversed()
    }

    fn contains<+PartialEq<T>>(self: @Array<T>, item: @T) -> bool {
        self.span().contains(item)
    }

    fn position<+PartialEq<T>>(self: @Array<T>, item: @T) -> Option<usize> {
        self.span().position(item)
    }

    fn occurrences<+PartialEq<T>>(self: @Array<T>, item: @T) -> usize {
        self.span().occurrences(item)
    }

    fn min<+PartialOrd<@T>>(self: @Array<T>) -> Option<T> {
        self.span().min()
    }

    fn min_position<+PartialOrd<@T>>(self: @Array<T>) -> Option<usize> {
        self.span().min_position()
    }

    fn max<+PartialOrd<@T>>(self: @Array<T>) -> Option<T> {
        self.span().max()
    }

    fn max_position<+PartialOrd<@T>>(mut self: @Array<T>) -> Option<usize> {
        self.span().max_position()
    }

    fn dedup<+PartialEq<T>>(mut self: @Array<T>) -> Array<T> {
        self.span().dedup()
    }

    fn unique<+PartialEq<T>>(mut self: @Array<T>) -> Array<T> {
        self.span().unique()
    }
}
