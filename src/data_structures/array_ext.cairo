use array::{ArrayTrait, SpanTrait};
use option::{Option, OptionTrait};

trait ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>);
    fn pop_front_n(ref self: Array<T>, n: usize);
    fn reverse(self: @Array<T>) -> Array<T>;
    fn contains<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> bool;
    fn concat(self: @Array<T>, a: @Array<T>) -> Array<T>;
    fn index_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> Option<usize>;
    fn occurrences_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> usize;
    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: @Array<T>
    ) -> Option<T>;
    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: @Array<T>
    ) -> Option<usize>;
    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: @Array<T>
    ) -> Option<T>;
    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: @Array<T>
    ) -> Option<usize>;
}

trait SpanTraitExt<T> {
    fn pop_front_n(ref self: Span<T>, n: usize);
    fn pop_back_n(ref self: Span<T>, n: usize);
    fn reverse(self: Span<T>) -> Array<T>;
    fn contains<impl TPartialEq: PartialEq<T>>(self: Span<T>, item: T) -> bool;
    fn concat(self: Span<T>, a: Span<T>) -> Span<T>;
    fn index_of<impl TPartialEq: PartialEq<T>>(self: Span<T>, item: T) -> Option<usize>;
    fn occurrences_of<impl TPartialEq: PartialEq<T>>(self: Span<T>, item: T) -> usize;
    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: Span<T>
    ) -> Option<T>;
    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: Span<T>
    ) -> Option<usize>;
    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: Span<T>
    ) -> Option<T>;
    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: Span<T>
    ) -> Option<usize>;
}

impl ArrayImpl<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>> of ArrayTraitExt<T> {
    fn append_all(ref self: Array<T>, ref arr: Array<T>) {
        match arr.pop_front() {
            Option::Some(v) => {
                self.append(v);
                self.append_all(ref arr);
            },
            Option::None(()) => (),
        }
    }

    fn pop_front_n(ref self: Array<T>, mut n: usize) {
        // Can't do self.span().pop_front_n();
        loop {
            if n == 0 {
                break ();
            }
            match self.pop_front() {
                Option::Some(v) => {
                    n -= 1;
                },
                Option::None(_) => {
                    break ();
                },
            };
        };
    }

    fn reverse(self: @Array<T>) -> Array<T> {
        self.span().reverse()
    }

    fn contains<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> bool {
        self.span().contains(item)
    }

    fn concat(self: @Array<T>, a: @Array<T>) -> Array<T> {
        // Can't do self.span().concat(a);
        let mut ret: Array<T> = Default::default();
        let mut i = 0;

        loop {
            if (i == self.len()) {
                break;
            }
            ret.append(*self[i]);
            i += 1;
        };
        i = 0;
        loop {
            if (i == a.len()) {
                break;
            }
            ret.append(*a[i]);
            i += 1;
        };
        ret
    }

    fn index_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> Option<usize> {
        self.span().index_of(item)
    }

    fn occurrences_of<impl TPartialEq: PartialEq<T>>(self: @Array<T>, item: T) -> usize {
        self.span().occurrences_of(item)
    }

    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: @Array<T>
    ) -> Option<T> {
        self.span().min()
    }

    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: @Array<T>
    ) -> Option<usize> {
        self.span().index_of_min()
    }

    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        self: @Array<T>
    ) -> Option<T> {
        self.span().max()
    }

    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        mut self: @Array<T>
    ) -> Option<usize> {
        self.span().index_of_max()
    }
}

impl SpanImpl<T, impl TCopy: Copy<T>, impl TDrop: Drop<T>> of SpanTraitExt<T> {
    fn pop_front_n(ref self: Span<T>, mut n: usize) {
        loop {
            if n == 0 {
                break ();
            }
            match self.pop_front() {
                Option::Some(v) => {
                    n -= 1;
                },
                Option::None(_) => {
                    break ();
                },
            };
        };
    }

    fn pop_back_n(ref self: Span<T>, mut n: usize) {
        loop {
            if n == 0 {
                break ();
            }
            match self.pop_back() {
                Option::Some(v) => {
                    n -= 1;
                },
                Option::None(_) => {
                    break ();
                },
            };
        };
    }

    fn reverse(mut self: Span<T>) -> Array<T> {
        let mut response = ArrayTrait::new();
        loop {
            match self.pop_back() {
                Option::Some(v) => {
                    response.append(*v);
                },
                Option::None(_) => {
                    break (); // Can't `break response;` "Variable was previously moved"
                },
            };
        };
        response
    }

    fn contains<impl TPartialEq: PartialEq<T>>(mut self: Span<T>, item: T) -> bool {
        loop {
            match self.pop_front() {
                Option::Some(v) => {
                    if *v == item {
                        break true;
                    }
                },
                Option::None(_) => {
                    break false;
                },
            };
        }
    }

    fn concat(self: Span<T>, a: Span<T>) -> Span<T> {
        let mut ret: Array<T> = Default::default();
        let mut i = 0;

        loop {
            if (i == self.len()) {
                break;
            }
            ret.append(*self[i]);
            i += 1;
        };
        i = 0;
        loop {
            if (i == a.len()) {
                break;
            }
            ret.append(*a[i]);
            i += 1;
        };
        ret.span()
    }

    fn index_of<impl TPartialEq: PartialEq<T>>(mut self: Span<T>, item: T) -> Option<usize> {
        let mut index = 0_usize;
        loop {
            match self.pop_front() {
                Option::Some(v) => {
                    if *v == item {
                        break Option::Some(index);
                    }
                    index += 1;
                },
                Option::None(_) => {
                    break Option::None(());
                },
            };
        }
    }

    fn occurrences_of<impl TPartialEq: PartialEq<T>>(mut self: Span<T>, item: T) -> usize {
        let mut count = 0_usize;
        loop {
            match self.pop_front() {
                Option::Some(v) => {
                    if *v == item {
                        count += 1;
                    }
                },
                Option::None(_) => {
                    break count;
                },
            };
        }
    }

    fn min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        mut self: Span<T>
    ) -> Option<T> {
        let mut min = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None(_) => {
                return Option::None(());
            },
        };
        loop {
            match self.pop_front() {
                Option::Some(item) => {
                    if *item < min {
                        min = *item
                    }
                },
                Option::None(_) => {
                    break Option::Some(min);
                },
            };
        }
    }

    fn index_of_min<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        mut self: Span<T>
    ) -> Option<usize> {
        let mut index = 0;
        let mut index_of_min = 0;
        let mut min: T = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None(_) => {
                return Option::None(());
            },
        };
        loop {
            match self.pop_front() {
                Option::Some(item) => {
                    if *item < min {
                        index_of_min = index + 1;
                        min = *item;
                    }
                },
                Option::None(_) => {
                    break Option::Some(index_of_min);
                },
            };
            index += 1;
        }
    }

    fn max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        mut self: Span<T>
    ) -> Option<T> {
        let mut max = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None(_) => {
                return Option::None(());
            },
        };
        loop {
            match self.pop_front() {
                Option::Some(item) => {
                    if *item > max {
                        max = *item
                    }
                },
                Option::None(_) => {
                    break Option::Some(max);
                },
            };
        }
    }

    fn index_of_max<impl TPartialEq: PartialEq<T>, impl TPartialOrd: PartialOrd<T>>(
        mut self: Span<T>
    ) -> Option<usize> {
        let mut index = 0;
        let mut index_of_max = 0;
        let mut max = match self.pop_front() {
            Option::Some(item) => *item,
            Option::None(_) => {
                return Option::None(());
            },
        };
        loop {
            match self.pop_front() {
                Option::Some(item) => {
                    if *item > max {
                        index_of_max = index + 1;
                        max = *item
                    }
                },
                Option::None(_) => {
                    break Option::Some(index_of_max);
                },
            };
            index += 1;
        }
    }
}
