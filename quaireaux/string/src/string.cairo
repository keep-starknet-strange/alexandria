use array::ArrayTrait;
use traits::Into;
use clone::Clone;
use quaireaux_string::ascii;

#[derive(Drop, Clone)]
struct String {
    data: Array<u8>,
}

trait StringTrait<T> {
    fn new() -> T;
    fn from_number<U, impl UTou256: Into<U, u256>>(n: U) -> T;

    fn len(self: @T) -> usize;
    fn raw(self: @T) -> @Array<u8>;   
}

impl StringImpl of StringTrait<String> {
    fn new() -> String {
        String { data: ArrayTrait::new() }
    }

    fn from_number<U, impl UTou256: Into<U, u256>>(n: U) -> String {
        String { data: ascii::to_ascii_numbers(n.into()) }
    }

    fn len(self: @String) -> usize {
        self.data.len()
    }

    fn raw(self: @String) -> @Array<u8> {
        self.data
    }
}

mod generic_impl {
    use array::ArrayTrait;
    use traits::IndexView;
    use debug::PrintTrait;
    use quaireaux_string::string::StringTrait;
    use quaireaux_utils::utils::check_gas;

    impl StringIndexing<T, impl TIsStringLike: StringTrait<T>> of IndexView<T, usize, @u8> {
        fn index(self: @T, index: usize) -> @u8 {
            self.raw().index(index)
        }
    }

    impl StringPrint<T, impl TIsStringLike: StringTrait<T>, impl TIsDroppable: Drop<T>> of PrintTrait<T> {
        fn print(self: T) {
            let mut n: usize = 0;
            loop {
                check_gas();
                (*self[n]).print();
                n = n + 1;
            };
        }
    }
}
