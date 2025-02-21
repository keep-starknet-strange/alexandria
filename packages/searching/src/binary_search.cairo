pub fn binary_search<T, +Copy<T>, +Drop<T>, +PartialEq<T>, +PartialOrd<T>>(
    span: Span<T>, val: T
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
        Option::None => Option::None
    }
}

pub fn binary_search_closest<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(
    span: Span<T>, val: T
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
            Option::None => Option::None
        }
    } else {
        let index = binary_search_closest(span.slice(middle, len), val);
        match index {
            Option::Some(v) => Option::Some(v + middle),
            Option::None => Option::None
        }
    }
}
