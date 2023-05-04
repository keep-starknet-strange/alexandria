use array::ArrayTrait;
use option::OptionTrait;
use traits::Into;
use traits::TryInto;
use traits::IndexView;
use quaireaux_string::string;
use quaireaux_string::string::generic_impl;

#[test]
#[available_gas(9999999999)]
fn test_from_number() {
    let tb: string::String = string::StringTrait::from_number(123456);
    assert(*tb[0] == '1'.try_into().unwrap(), 'Bad conv 1');
    assert(*tb[1] == '2'.try_into().unwrap(), 'Bad conv 2');
    assert(*tb[2] == '3'.try_into().unwrap(), 'Bad conv 3');
    assert(*tb[3] == '4'.try_into().unwrap(), 'Bad conv 4');
    assert(*tb[4] == '5'.try_into().unwrap(), 'Bad conv 5');
    assert(*tb[5] == '6'.try_into().unwrap(), 'Bad conv 6');
}
