use core::clone::Clone;
use core::cmp::min;
use core::num::traits::CheckedSub;
use super::array_ext::ArrayTraitExt;

pub trait SpanTraitExt<T> {
    /// Removes up to `n` elements from the front of `self` and returns them in a new span.
    fn pop_front_n(ref self: Span<T>, n: usize) -> Span<T>;
    /// Removes up to `n` elements from the back of `self` and returns them in a new span.
    fn pop_back_n(ref self: Span<T>, n: usize) -> Span<T>;
    /// Removes up to `n` elements from the front of `self`.
    fn remove_front_n(ref self: Span<T>, n: usize);
    /// Removes up to `n` elements from the back of `self`.
    fn remove_back_n(ref self: Span<T>, n: usize);
    /// Clones and appends all the elements of `self` and then `other` in a single new array.
    fn concat(self: Span<T>, other: Span<T>) -> Array<T>;
    /// Return a new array containing the elements of `self` in a reversed order.
    fn reversed(self: Span<T>) -> Array<T>;
    /// Returns `true` if the span contains an element with the given value.
    fn contains<+PartialEq<T>>(self: Span<T>, item: @T) -> bool;
    /// Searches for an element the span, returning its index.
    fn position<+PartialEq<T>>(self: Span<T>, item: @T) -> Option<usize>;
    /// Returns the number of elements in the span with the given value.
    fn occurrences<+PartialEq<T>>(self: Span<T>, item: @T) -> usize;
    /// Returns the minimum element of a span.
    fn min<+PartialOrd<@T>>(self: Span<T>) -> Option<T>;
    /// Returns the position of the minimum element of a span.
    fn min_position<+PartialOrd<@T>>(self: Span<T>) -> Option<usize>;
    /// Returns the maximum element of a span.
    fn max<+PartialOrd<@T>>(self: Span<T>) -> Option<T>;
    /// Returns the position of the maximum element of a span.
    fn max_position<+PartialOrd<@T>>(self: Span<T>) -> Option<usize>;
    /// Returns a new array, cloned from `self` but removes consecutive repeated elements.
    /// If the span is sorted, this removes all duplicates.
    fn dedup<+PartialEq<T>>(self: Span<T>) -> Array<T>;
    /// Returns a new array, cloned from `self` but without any duplicate.
    fn unique<+PartialEq<T>>(self: Span<T>) -> Array<T>;
}

impl SpanImpl<T, +Clone<T>, +Drop<T>> of SpanTraitExt<T> {
    fn pop_front_n(ref self: Span<T>, mut n: usize) -> Span<T> {
        let span_len = self.len();
        let separator = min(n, span_len);

        let res = self.slice(0, separator);
        self = self.slice(separator, span_len - separator);

        res
    }

    fn pop_back_n(ref self: Span<T>, n: usize) -> Span<T> {
        let span_len = self.len();
        // Saturating substraction
        let separator = span_len.checked_sub(n).unwrap_or(0);

        let res = self.slice(separator, span_len - separator);
        self = self.slice(0, separator);

        res
    }

    fn remove_front_n(ref self: Span<T>, mut n: usize) {
        let span_len = self.len();
        let separator = min(n, span_len);

        self = self.slice(separator, span_len - separator);
    }

    fn remove_back_n(ref self: Span<T>, mut n: usize) {
        let span_len = self.len();
        // Saturating substraction
        let separator = span_len.checked_sub(n).unwrap_or(0);

        self = self.slice(0, separator);
    }

    fn concat(mut self: Span<T>, mut other: Span<T>) -> Array<T> {
        let mut ret = array![];

        ret.extend_from_span(self);
        ret.extend_from_span(other);

        ret
    }

    fn reversed(mut self: Span<T>) -> Array<T> {
        let mut res = array![];

        while let Option::Some(v) = self.pop_back() {
            res.append(v.clone());
        }

        res
    }

    fn contains<+PartialEq<T>>(mut self: Span<T>, item: @T) -> bool {
        loop {
            match self.pop_front() {
                Option::Some(v) => { if v == item {
                    break true;
                } },
                Option::None => { break false; },
            };
        }
    }

    fn position<+PartialEq<T>>(mut self: Span<T>, item: @T) -> Option<usize> {
        let mut index = 0_usize;
        loop {
            match self.pop_front() {
                Option::Some(v) => {
                    if v == item {
                        break Option::Some(index);
                    }
                    index += 1;
                },
                Option::None => { break Option::None; },
            };
        }
    }

    fn occurrences<+PartialEq<T>>(mut self: Span<T>, item: @T) -> usize {
        let mut count = 0_usize;
        for v in self {
            if v == item {
                count += 1;
            }
        }
        count
    }

    fn min<+PartialOrd<@T>>(mut self: Span<T>) -> Option<T> {
        let mut min = match self.pop_front() {
            Option::Some(item) => item,
            Option::None => { return Option::None; },
        };

        for item in self {
            if item < min {
                min = item
            }
        }

        Option::Some(min.clone())
    }

    fn min_position<+PartialOrd<@T>>(mut self: Span<T>) -> Option<usize> {
        let mut index = 0;
        let mut min_position = 0;
        let mut min = match self.pop_front() {
            Option::Some(item) => item,
            Option::None => { return Option::None; },
        };
        for item in self {
            if item < min {
                min_position = index + 1;
                min = item;
            }
            index += 1;
        }

        Option::Some(min_position)
    }

    fn max<+PartialOrd<@T>>(mut self: Span<T>) -> Option<T> {
        let mut max = match self.pop_front() {
            Option::Some(item) => item,
            Option::None => { return Option::None; },
        };

        for item in self {
            if item > max {
                max = item
            }
        }

        Option::Some(max.clone())
    }

    fn max_position<+PartialOrd<@T>>(mut self: Span<T>) -> Option<usize> {
        let mut index = 0;
        let mut max_position = 0;
        let mut max = match self.pop_front() {
            Option::Some(item) => item,
            Option::None => { return Option::None; },
        };

        for item in self {
            if item > max {
                max_position = index + 1;
                max = item
            }
            index += 1;
        }

        Option::Some(max_position)
    }

    fn dedup<+PartialEq<T>>(mut self: Span<T>) -> Array<T> {
        if self.len() == 0 {
            return array![];
        }

        // Safe to unwrap because we checked for empty vec
        let mut last_value = self.pop_front().unwrap();
        let mut ret = array![last_value.clone()];

        for v in self {
            if (last_value != v) {
                last_value = v;
                ret.append(v.clone());
            }
        }

        ret
    }

    fn unique<+PartialEq<T>>(mut self: Span<T>) -> Array<T> {
        let mut ret = array![];

        for v in self {
            if !ret.span().contains(v) {
                ret.append(v.clone());
            }
        }

        ret
    }
}
