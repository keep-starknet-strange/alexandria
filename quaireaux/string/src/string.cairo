// T is the string-like type, U is the type of the code-point
trait StringTrait<T, U> {
    fn new() -> T;
    fn codepoint(self: @T, index: usize) -> @U;
}

mod generic_impl {
    use traits::IndexView;
    use quaireaux_string::string::StringTrait;

    impl StringIndexing<T, U, impl TIsStringLike: StringTrait<T, U>> of IndexView<T, usize, @U> {
        fn index(self: @T, index: usize) -> @U {
            self.codepoint(index)
        }
    }
}
