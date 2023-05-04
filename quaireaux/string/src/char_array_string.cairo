use array::ArrayTrait;
use traits::Into;
use clone::Clone;
use quaireaux_string::string;
use quaireaux_string::string::StringTrait;

type AsciiCharArrayString = Array<u8>;

impl AsciiCharArrayStringImpl of StringTrait<AsciiCharArrayString, u8> {
    fn new() -> AsciiCharArrayString {
        ArrayTrait::new()
    }

    fn codepoint(self: @AsciiCharArrayString, index: usize) -> @u8 {
        self[index]
    }
}
