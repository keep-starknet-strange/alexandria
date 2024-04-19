pub trait Sortable {
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>>(array: Span<T>) -> Array<T>;
}
