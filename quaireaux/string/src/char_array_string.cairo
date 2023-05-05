// Generic implementation for Array (strings as array of codepoints)
// Provided in a separate module to avoid auto-inference polluting the namespaces.
mod as_array {
    use array::ArrayTrait;
    use quaireaux_string::sequence::SequenceTrait;
    impl StringAsArray<U> of SequenceTrait<Array<U>, U> {
        #[inline(always)]
        fn get(self: @Array<U>, index: usize) -> Option<Box<@U>> {
            ArrayTrait::get(self, index)
        }
        fn at(self: @Array<U>, index: usize) -> @U {
            ArrayTrait::at(self, index)
        }
        #[inline(always)]
        fn len(self: @Array<U>) -> usize {
            ArrayTrait::len(self)
        }
        #[inline(always)]
        fn is_empty(self: @Array<U>) -> bool {
            ArrayTrait::is_empty(self)
        }
    }
}

// Array<u8> is an array of ASCII values, implement it directly.
impl AsciiCharArrayStringImpl = as_array::StringAsArray<u8>;
