use super::span_ext::SpanTraitExt;

pub trait ArrayTraitExt<T, +Clone<T>, +Drop<T>> {
    /// Moves all the elements of `other` into `self`, leaving `other` empty.
    fn append_all(ref self: Array<T>, ref other: Array<T>);
    /// Clones and appends all the elements of `other` into `self`.
    fn extend_from_span(ref self: Array<T>, other: Span<T>);
    /// Removes up to `n` elements from the front of `self` and returns them in a new array.
    fn pop_front_n(ref self: Array<T>, n: usize) -> Array<T>;
    /// Removes up to `n` elements from the front of `self`.
    fn remove_front_n(ref self: Array<T>, n: usize);
    /// Clones and appends all the elements of `self` and then `other` in a single new array.
    fn concat(self: @Array<T>, other: @Array<T>) -> Array<T>;
    /// Return a new array containing the elements of `self` in a reversed order.
    fn reversed(self: @Array<T>) -> Array<T>;
    /// Returns `true` if the array contains an element with the given value.
    fn contains<+PartialEq<T>>(self: @Array<T>, item: @T) -> bool;
    /// Searches for an element in the array, returning its index.
    fn position<+PartialEq<T>>(self: @Array<T>, item: @T) -> Option<usize>;
    /// Returns the number of elements in the array with the given value.
    fn occurrences<+PartialEq<T>>(self: @Array<T>, item: @T) -> usize;
    /// Returns the minimum element of an array.
    fn min<+PartialOrd<@T>>(self: @Array<T>) -> Option<T>;
    /// Returns the position of the minimum element of an array.
    fn min_position<+PartialOrd<@T>>(self: @Array<T>) -> Option<usize>;
    /// Returns the maximum element of an array.
    fn max<+PartialOrd<@T>>(self: @Array<T>) -> Option<T>;
    /// Returns the position of the maximum element of an array.
    fn max_position<+PartialOrd<@T>>(self: @Array<T>) -> Option<usize>;
    /// Returns a new array, cloned from `self` but removes consecutive repeated elements.
    /// If the array is sorted, this removes all duplicates.
    fn dedup<+PartialEq<T>>(self: @Array<T>) -> Array<T>;
    /// Returns a new array, cloned from `self` but without any duplicate.
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

