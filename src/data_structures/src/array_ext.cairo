trait ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>);
    fn pop_front_n(ref self: Array<T>, n: usize);
    fn reverse(self: @Array<T>) -> Array<T>;
    fn contains<+PartialEq<T>>(self: @Array<T>, item: T) -> bool;
    fn concat(self: @Array<T>, a: @Array<T>) -> Array<T>;
    fn concat_span<+Drop<T>>(ref self: Array<T>, arr2: Span<T>);
    fn index_of<+PartialEq<T>>(self: @Array<T>, item: T) -> Option<usize>;
    fn occurrences_of<+PartialEq<T>>(self: @Array<T>, item: T) -> usize;
    fn min<+PartialEq<T>, +PartialOrd<T>>(self: @Array<T>) -> Option<T>;
    fn index_of_min<+PartialEq<T>, +PartialOrd<T>>(self: @Array<T>) -> Option<usize>;
    fn max<+PartialEq<T>, +PartialOrd<T>>(self: @Array<T>) -> Option<T>;
    fn index_of_max<+PartialEq<T>, +PartialOrd<T>>(self: @Array<T>) -> Option<usize>;
    fn dedup<+PartialEq<T>>(self: @Array<T>) -> Array<T>;
    fn unique<+PartialEq<T>>(self: @Array<T>) -> Array<T>;
}

trait SpanTraitExt<T> {
    fn pop_front_n(ref self: Span<T>, n: usize);
    fn pop_back_n(ref self: Span<T>, n: usize);
    fn reverse(self: Span<T>) -> Array<T>;
    fn contains<+PartialEq<T>>(self: Span<T>, item: T) -> bool;
    fn concat(self: Span<T>, a: Span<T>) -> Span<T>;
    fn index_of<+PartialEq<T>>(self: Span<T>, item: T) -> Option<usize>;
    fn occurrences_of<+PartialEq<T>>(self: Span<T>, item: T) -> usize;
    fn min<+PartialEq<T>, +PartialOrd<T>>(self: Span<T>) -> Option<T>;
    fn index_of_min<+PartialEq<T>, +PartialOrd<T>>(self: Span<T>) -> Option<usize>;
    fn max<+PartialEq<T>, +PartialOrd<T>>(self: Span<T>) -> Option<T>;
    fn index_of_max<+PartialEq<T>, +PartialOrd<T>>(self: Span<T>) -> Option<usize>;
    fn dedup<+PartialEq<T>>(self: Span<T>) -> Array<T>;
    fn unique<+PartialEq<T>>(self: Span<T>) -> Array<T>;
}

impl ArrayImpl<T, +Copy<T>, +Drop<T>> of ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>) {
        match arr.pop_front() {
            Option::Some(v) => {
                self.append(v);
                self.append_all(ref arr);
            },
            Option::None => (),
        }
    }

    fn pop_front_n(ref self: Array<T>, mut n: usize) {
        // Can't do self.span().pop_front_n();
        while (n != 0) {
            match self.pop_front() {
                Option::Some(_) => { n -= 1; },
                Option::None => { break; },
            };
        };
    }

    fn reverse(self: @Array<T>) -> Array<T> {
        self.span().reverse()
    }

    fn contains<+PartialEq<T>>(self: @Array<T>, item: T) -> bool {
        self.span().contains(item)
    }

    fn concat(self: @Array<T>, a: @Array<T>) -> Array<T> {
        // Can't do self.span().concat(a);
        let mut ret = array![];
        let mut i = 0;

        while (i != self.len()) {
            ret.append(*self[i]);
            i += 1;
        };
        i = 0;
        while (i != a.len()) {
            ret.append(*a[i]);
            i += 1;
        };
        ret
    }

    fn concat_span<+Destruct<T>>(ref self: Array<T>, mut arr2: Span<T>) {
        while let Option::Some(elem) = arr2.pop_front() {
            self.append(*elem);
        }
    }

    fn index_of<+PartialEq<T>>(self: @Array<T>, item: T) -> Option<usize> {
        self.span().index_of(item)
    }

    fn occurrences_of<+PartialEq<T>>(self: @Array<T>, item: T) -> usize {
        self.span().occurrences_of(item)
    }

    fn min<+PartialEq<T>, +PartialOrd<T>>(self: @Array<T>) -> Option<T> {
        self.span().min()
    }

    fn index_of_min<+PartialEq<T>, +PartialOrd<T>>(self: @Array<T>) -> Option<usize> {
        self.span().index_of_min()
    }

    fn max<+PartialEq<T>, +PartialOrd<T>>(self: @Array<T>) -> Option<T> {
        self.span().max()
    }

    fn index_of_max<+PartialEq<T>, +PartialOrd<T>>(mut self: @Array<T>) -> Option<usize> {
        self.span().index_of_max()
    }

    fn dedup<+PartialEq<T>>(mut self: @Array<T>) -> Array<T> {
        self.span().dedup()
    }

    fn unique<+PartialEq<T>>(mut self: @Array<T>) -> Array<T> {
        self.span().unique()
    }
}

impl SpanImpl<T, +Copy<T>, +Drop<T>> of SpanTraitExt<T> {
    fn pop_front_n(ref self: Span<T>, mut n: usize) {
        while (n != 0) {
            match self.pop_front() {
                Option::Some(_) => { n -= 1; },
                Option::None => { break; },
            };
        };
    }

    fn pop_back_n(ref self: Span<T>, mut n: usize) {
        while (n != 0) {
            match self.pop_back() {
                Option::Some(_) => { n -= 1; },
                Option::None => { break; },
            };
        };
    }

    fn reverse(mut self: Span<T>) -> Array<T> {
        let mut response = array![];
        loop {
            match self.pop_back() {
                Option::Some(v) => { response.append(*v); },
                Option::None => {
                    break; // Can't `break response;` "Variable was previously moved"
                },
            };
        };
        response
    }

    fn contains<+PartialEq<T>>(mut self: Span<T>, item: T) -> bool {
        loop {
            match self.pop_front() {
                Option::Some(v) => { if *v == item {
                    break true;
                } },
                Option::None => { break false; },
            };
        }
    }

    fn concat(self: Span<T>, a: Span<T>) -> Span<T> {
        let mut ret = array![];
        let mut i = 0;

        while (i != self.len()) {
            ret.append(*self[i]);
            i += 1;
        };
        i = 0;
        while (i != a.len()) {
            ret.append(*a[i]);
            i += 1;
        };
        ret.span()
    }

    fn index_of<+PartialEq<T>>(mut self: Span<T>, item: T) -> Option<usize> {
        let mut index = 0_usize;
        loop {
            match self.pop_front() {
                Option::Some(v) => {
                    if *v == item {
                        break Option::Some(index);
                    }
                    index += 1;
                },
                Option::None => { break Option::None; },
            };
        }
    }

    fn occurrences_of<+PartialEq<T>>(mut self: Span<T>, item: T) -> usize {
        let mut count = 0_usize;
        while let Option::Some(v) = self.pop_front() {
            if *v == item {
                count += 1;
            }
        };
        count
    }

    fn min<+PartialEq<T>, +PartialOrd<T>>(mut self: Span<T>) -> Option<T> {
        let mut min = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None => { return Option::None; },
        };
        while let Option::Some(item) = self.pop_front() {
            if *item < min {
                min = *item
            }
        };
        Option::Some(min)
    }

    fn index_of_min<+PartialEq<T>, +PartialOrd<T>>(mut self: Span<T>) -> Option<usize> {
        let mut index = 0;
        let mut index_of_min = 0;
        let mut min: T = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None => { return Option::None; },
        };
        while let Option::Some(item) = self
            .pop_front() {
                if *item < min {
                    index_of_min = index + 1;
                    min = *item;
                }
                index += 1;
            };
        Option::Some(index_of_min)
    }

    fn max<+PartialEq<T>, +PartialOrd<T>>(mut self: Span<T>) -> Option<T> {
        let mut max = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None => { return Option::None; },
        };
        while let Option::Some(item) = self.pop_front() {
            if *item > max {
                max = *item
            }
        };
        Option::Some(max)
    }

    fn index_of_max<+PartialEq<T>, +PartialOrd<T>>(mut self: Span<T>) -> Option<usize> {
        let mut index = 0;
        let mut index_of_max = 0;
        let mut max = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None => { return Option::None; },
        };
        while let Option::Some(item) = self
            .pop_front() {
                if *item > max {
                    index_of_max = index + 1;
                    max = *item
                }
                index += 1;
            };
        Option::Some(index_of_max)
    }

    fn dedup<+PartialEq<T>>(mut self: Span<T>) -> Array<T> {
        if self.len() == 0 {
            return array![];
        }

        let mut last_value = self.pop_front().unwrap();
        let mut ret = array![*last_value];

        while let Option::Some(v) = self
            .pop_front() {
                if (last_value != v) {
                    last_value = v;
                    ret.append(*v);
                }
            };

        ret
    }

    fn unique<+PartialEq<T>>(mut self: Span<T>) -> Array<T> {
        let mut ret = array![];
        while let Option::Some(v) = self.pop_front() {
            if !ret.contains(*v) {
                ret.append(*v);
            }
        };
        ret
    }
}
