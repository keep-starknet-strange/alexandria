use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use quaireaux_string::sequence::SequenceTrait;
use quaireaux_string::ascii;

use quaireaux_utils::check_gas;
use quaireaux_utils::Construct;

use box::BoxTrait;

#[derive(Drop, Copy)]
struct ShortString {
    data: felt252
}

impl IntoShortString of Into<felt252, ShortString> {
    fn into(self: felt252) -> ShortString {
        ShortString { data: self }
    }
}

impl ShortStringConstructor of Construct<ShortString> {
    fn new() -> ShortString {
        ShortString { data: 0 }
    }
}

use debug::PrintTrait;

// Implement a 0-terminated (if size < 31) wrapper around the short-string native to Cairo 1.
impl ShortStringImpl of SequenceTrait<ShortString, u8> {
    fn get(self: @ShortString, index: usize) -> Option<Box<@u8>> {
        // Not the most efficient implementation I'm afraid
        let len = self.len();
        if index >= len {
            return Option::None(());
        }
        if len == 0 {
            return Option::None(());
        }
        let mut n = len - index - 1;
        let mut shift: felt252 = 1;
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
        let tt: u256 = (su & (sh * 0xFF.into())) / sh;
        Option::Some(BoxTrait::<@u8>::new(@tt.low.try_into().unwrap()))
    }

    fn at(self: @ShortString, index: usize) -> @u8 {
        let v = self.get(index);
        assert(v.is_some(), 'OOB index');
        v.unwrap().unbox()
    }

    fn len(self: @ShortString) -> usize {
        if *self.data == 0 {
            return 0;
        }
        let mut n = 1;
        let mut data: u256 = (*self.data).into();
        loop {
            check_gas();
            data = data / 256.into();
            if data == 0.into() {
                break n;
            }
            if n == 31 {
                break n;
            }
            n = n + 1;
        }
    }

    fn is_empty(self: @ShortString) -> bool {
        self.len() == 0
    }
}

impl ShortStringIndexing of IndexView<ShortString, usize, @u8> {
    fn index(self: @ShortString, index: usize) -> @u8 {
        self.at(index)
    }
}
