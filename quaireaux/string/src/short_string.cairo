use quaireaux_string::string::StringTrait;
use quaireaux_string::ascii;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;

use quaireaux_utils::check_gas;

#[derive(Drop, Copy)]
struct ShortString {
    data: felt252
}

impl IntoShortString of Into<felt252, ShortString> {
    fn into(self: felt252) -> ShortString {
        ShortString { data: self }
    }
}

use debug::PrintTrait;

// Temporary
fn get_len(a: @ShortString) -> usize {
    if *a.data == 0 {
        return 0;
    }
    let mut n = 1;
    let mut data: u256 = (*a.data).into();
    loop {
        check_gas();
        data = data / 256.into();
        if data == 0.into() {
            break n;
        }
        n = n + 1;
    }
}

impl ShortStringImpl of StringTrait<ShortString, u8> {
    fn new() -> ShortString {
        ShortString { data: 0 }
    }

    fn codepoint(self: @ShortString, index: usize) -> @u8 {
        let len = get_len(self);
        if len == 0 {
            return @0;
        }
        let mut n = len - index - 1;
        let mut shift: felt252 = 0xFF;
        shift = loop {
            check_gas();
            if n == 0 {
                break shift;
            }
            shift = shift * 256;
            n = n - 1;
        };
        let su: u256 = (*self.data).into();
        let sh: u256 = shift.into();
        let mut tt: u256 = su & sh;
        if sh > 255.into() {
            tt = tt / (sh / 256.into());
        }
        @tt.low.try_into().unwrap()
    }
}

// This leads to a compiler error right now
// TODO: once that's fixed, uncomment that so the generic print impl works
//impl ShortStringIndexing = string::generic_impl::StringIndexing<ShortString, u8>;
impl ShortStringIndexing of IndexView<ShortString, usize, @u8> {
    fn index(self: @ShortString, index: usize) -> @u8 {
        self.codepoint(index)
    }
}
