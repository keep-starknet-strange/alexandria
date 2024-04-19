pub trait Sortable {
    fn sort<T, +Copy<T>, +Drop<T>, +PartialOrd<T>, +PartialEq<T>>(array: Array<T>) -> Array<T>;
}
