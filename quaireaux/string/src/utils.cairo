// These traits are intended to be temporary until similar traits are in the Cairo standard library,
// thus their placement in utils.

trait RandomAccessTrait<T, U> {
    fn get(self: @T, index: usize) -> Option<Box<@U>>;
    fn at(self: @T, index: usize) -> @U;
}

trait Collection<T> {
    fn len(self: @T) -> usize;
    fn is_empty(self: @T) -> bool;
}
