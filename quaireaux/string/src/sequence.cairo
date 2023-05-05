// This is intended to be a supertype provided by Cairo 1, but it's not yet implemented.
trait SequenceTrait<T, U> {
    fn get(self: @T, index: usize) -> Option<Box<@U>>;
    fn at(self: @T, index: usize) -> @U;
    fn len(self: @T) -> usize;
    fn is_empty(self: @T) -> bool;
}
