use array::ArrayTrait;
use option::OptionTrait;
use traits::Into;
use traits::TryInto;
use traits::IndexView;

use debug::PrintTrait;

use quaireaux_string::ascii;
use quaireaux_string::string::StringTrait;
use quaireaux_string::char_array_string;
use quaireaux_string::short_string;

#[test]
#[available_gas(9999999999)]
fn test_char_array_string_from_number() {
    let tb: char_array_string::AsciiCharArrayString = ascii::ascii_representation(123456);
    tb.len();
    assert(*tb[0] == '1'.try_into().unwrap(), 'Bad conv 1');
    assert(*tb[1] == '2'.try_into().unwrap(), 'Bad conv 2');
    assert(*tb[2] == '3'.try_into().unwrap(), 'Bad conv 3');
    assert(*tb[3] == '4'.try_into().unwrap(), 'Bad conv 4');
    assert(*tb[4] == '5'.try_into().unwrap(), 'Bad conv 5');
    assert(*tb[5] == '6'.try_into().unwrap(), 'Bad conv 6');
}


#[test]
#[available_gas(9999999999)]
fn test_short_string_from_number() {
    let tb: short_string::ShortString = '123456'.into();
    assert(*tb[0] == '1'.try_into().unwrap(), 'Bad conv 1');
    assert(*tb[1] == '2'.try_into().unwrap(), 'Bad conv 2');
    assert(*tb[2] == '3'.try_into().unwrap(), 'Bad conv 3');
    assert(*tb[3] == '4'.try_into().unwrap(), 'Bad conv 4');
    assert(*tb[4] == '5'.try_into().unwrap(), 'Bad conv 5');
    assert(*tb[5] == '6'.try_into().unwrap(), 'Bad conv 6');
}

#[test]
#[available_gas(9999999999)]
fn test_shortest_string() {
    let tb: short_string::ShortString = '1'.into();
    assert(*tb[0] == '1'.try_into().unwrap(), 'Bad conv 1');
    let tb2: short_string::ShortString = 0.into();
    assert(*tb2[0] == 0, 'Bad conv 2');
}
