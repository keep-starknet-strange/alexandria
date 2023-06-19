use array::SpanTrait;

fn binary_search<
    T, impl TCopy: Copy<T>, impl TDrop: Drop<T>, impl TEq: PartialEq<T>, impl TOr: PartialOrd<T>
>(
    span: Span<T>, val: T
) -> Option<u32> {
    // Initial check
    if (span.len() == 0) {
        return Option::None(());
    }
    let middle = span.len() / 2;
    if (*span[middle] == val) {
        return Option::Some(middle);
    }
    if (span.len() == 1) {
        return Option::None(());
    }
    if (*span[middle] > val) {
        return (binary_search(span.slice(0, middle), val));
    }

    let mut len = middle;
    if (span.len() % 2 == 1) {
        len += 1;
    }
    let val = binary_search(span.slice(middle, len), val);
    match val {
        Option::Some(v) => Option::Some(v + middle),
        Option::None(()) => Option::None(())
    }
}
