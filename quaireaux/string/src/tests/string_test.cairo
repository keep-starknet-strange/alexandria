use array::ArrayTrait;
use option::OptionTrait;
use traits::Into;
use traits::TryInto;
use traits::IndexView;

use debug::PrintTrait;

use quaireaux_string::ascii;
use quaireaux_string::char_array_string;
use quaireaux_string::short_string::ShortString;
use quaireaux_utils::new;

#[test]
#[available_gas(9999999999)]
fn test_char_array_string_from_number() {
    let tb: Array<u8> = ascii::ascii_representation(123456);
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
    let tb: ShortString = '123456'.into();
    assert(*tb[0] == '1'.try_into().unwrap(), 'Bad conv 1');
    assert(*tb[1] == '2'.try_into().unwrap(), 'Bad conv 2');
    assert(*tb[2] == '3'.try_into().unwrap(), 'Bad conv 3');
    assert(*tb[3] == '4'.try_into().unwrap(), 'Bad conv 4');
    assert(*tb[4] == '5'.try_into().unwrap(), 'Bad conv 5');
    assert(*tb[5] == '6'.try_into().unwrap(), 'Bad conv 6');
}

#[test]
#[available_gas(9999999999)]
fn test_short_string_bounds() {
    let tb: ShortString = '1'.into();
    assert(*tb[0] == '1'.try_into().unwrap(), 'Bad conv 1');
    let a = '123456789ABCDEFGHIJKLMNOPQRSTUV';
    let tb2: ShortString = a.into();
    assert(*tb2[23] == 'O', 'Bad conv 2');
// TODO: this triggers a range crash in u256 division
//assert(*tb2[0] == 'a', 'Bad conv 2');
}

#[test]
#[should_panic]
#[available_gas(9999999999)]
fn test_short_string_oob_index() {
    let tb2: ShortString = new();
    tb2[0];
}

#[test]
#[should_panic]
#[available_gas(9999999999)]
fn test_short_string_oob_index2() {
    let tb: ShortString = 'cafe'.into();
    assert(*tb[0] == 'c', 'Bad conv 1');
    tb[5];
}
