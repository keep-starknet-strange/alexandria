use array::ArrayTrait;
use option::OptionTrait;
use traits::Into;
use traits::TryInto;

use quaireaux_string::ascii;
use debug::PrintTrait;


#[test]
#[available_gas(9999999999)]
fn test_small_string() {
    let tb = ascii::ascii_representation(123456);
    assert(*tb[0] == '1'.try_into().unwrap(), 'Bad conv 1');
    assert(*tb[1] == '2'.try_into().unwrap(), 'Bad conv 2');
    assert(*tb[2] == '3'.try_into().unwrap(), 'Bad conv 3');
    assert(*tb[3] == '4'.try_into().unwrap(), 'Bad conv 4');
    assert(*tb[4] == '5'.try_into().unwrap(), 'Bad conv 5');
    assert(*tb[5] == '6'.try_into().unwrap(), 'Bad conv 6');
}

#[test]
#[available_gas(9999999999)]
fn test_small_string_hex() {
    let tb = ascii::ascii_representation_hex(0xcafe123fade);
    assert(*tb[0] == 'C'.try_into().unwrap(), 'Bad conv 0');
    assert(*tb[1] == 'A'.try_into().unwrap(), 'Bad conv 1');
    assert(*tb[2] == 'F'.try_into().unwrap(), 'Bad conv 2');
    assert(*tb[3] == 'E'.try_into().unwrap(), 'Bad conv 3');
    assert(*tb[4] == '1'.try_into().unwrap(), 'Bad conv 4');
    assert(*tb[5] == '2'.try_into().unwrap(), 'Bad conv 5');
    assert(*tb[6] == '3'.try_into().unwrap(), 'Bad conv 6');
    assert(*tb[7] == 'F'.try_into().unwrap(), 'Bad conv 7');
    assert(*tb[8] == 'A'.try_into().unwrap(), 'Bad conv 8');
    assert(*tb[9] == 'D'.try_into().unwrap(), 'Bad conv 9');
    assert(*tb[10] == 'E'.try_into().unwrap(), 'Bad conv 10');
}

#[test]
#[available_gas(9999999999)]
fn test_big_string() {
    let tb = ascii::ascii_representation(0xCAFE0000000000000000000000000000000000000);
    //tb.print();
    // Matches 18542088399789477794768722172103116064316452765696
    assert(*tb[0] == '1', 'Bad conv 0'); // 8542088399789477794768722172103116064316452765696
    assert(*tb[1] == '8', 'Bad conv 1'); // 542088399789477794768722172103116064316452765696
    assert(*tb[2] == '5', 'Bad conv 2'); // 42088399789477794768722172103116064316452765696
    assert(*tb[3] == '4', 'Bad conv 3'); // 2088399789477794768722172103116064316452765696
    assert(*tb[4] == '2', 'Bad conv 4'); // 088399789477794768722172103116064316452765696
    assert(*tb[5] == '0', 'Bad conv 5'); // 88399789477794768722172103116064316452765696
    assert(*tb[6] == '8', 'Bad conv 6'); // 8399789477794768722172103116064316452765696
    assert(*tb[7] == '8', 'Bad conv 7'); // 399789477794768722172103116064316452765696
    assert(*tb[8] == '3', 'Bad conv 8'); // 99789477794768722172103116064316452765696
    assert(*tb[9] == '9', 'Bad conv 9'); // 9789477794768722172103116064316452765696
    assert(*tb[10] == '9', 'Bad conv 10'); // 789477794768722172103116064316452765696
    assert(*tb[11] == '7', 'Bad conv 11'); // 89477794768722172103116064316452765696
    assert(*tb[12] == '8', 'Bad conv 12'); // 9477794768722172103116064316452765696
    assert(*tb[13] == '9', 'Bad conv 13'); // 477794768722172103116064316452765696
    assert(*tb[14] == '4', 'Bad conv 14'); // 77794768722172103116064316452765696
    assert(*tb[15] == '7', 'Bad conv 15'); // 7794768722172103116064316452765696
    assert(*tb[16] == '7', 'Bad conv 16'); // 794768722172103116064316452765696
    assert(*tb[17] == '7', 'Bad conv 17'); // 94768722172103116064316452765696
    assert(*tb[18] == '9', 'Bad conv 18'); // 4768722172103116064316452765696
    assert(*tb[19] == '4', 'Bad conv 19'); // 768722172103116064316452765696
    assert(*tb[20] == '7', 'Bad conv 20'); // 68722172103116064316452765696
    assert(*tb[21] == '6', 'Bad conv 21'); // 8722172103116064316452765696
    assert(*tb[22] == '8', 'Bad conv 22'); // 722172103116064316452765696
    assert(*tb[23] == '7', 'Bad conv 23'); // 22172103116064316452765696
    assert(*tb[24] == '2', 'Bad conv 24'); // 2172103116064316452765696
    assert(*tb[25] == '2', 'Bad conv 25'); // 172103116064316452765696
    assert(*tb[26] == '1', 'Bad conv 26'); // 72103116064316452765696
    assert(*tb[27] == '7', 'Bad conv 27'); // 2103116064316452765696
    assert(*tb[28] == '2', 'Bad conv 28'); // 103116064316452765696
    assert(*tb[29] == '1', 'Bad conv 29'); // 03116064316452765696
    assert(*tb[30] == '0', 'Bad conv 30'); // 3116064316452765696
    assert(*tb[31] == '3', 'Bad conv 31'); // 116064316452765696
    assert(*tb[32] == '1', 'Bad conv 32'); // 16064316452765696
    assert(*tb[33] == '1', 'Bad conv 33'); // 6064316452765696
    assert(*tb[34] == '6', 'Bad conv 34'); // 064316452765696
    assert(*tb[35] == '0', 'Bad conv 35'); // 64316452765696
    assert(*tb[36] == '6', 'Bad conv 36'); // 4316452765696
    assert(*tb[37] == '4', 'Bad conv 37'); // 316452765696
    assert(*tb[38] == '3', 'Bad conv 38'); // 16452765696
    assert(*tb[39] == '1', 'Bad conv 39'); // 6452765696
    assert(*tb[40] == '6', 'Bad conv 40'); // 452765696
    assert(*tb[41] == '4', 'Bad conv 41'); // 52765696
    assert(*tb[42] == '5', 'Bad conv 42'); // 2765696
    assert(*tb[43] == '2', 'Bad conv 43'); // 765696
    assert(*tb[44] == '7', 'Bad conv 44'); // 65696
    assert(*tb[45] == '6', 'Bad conv 45'); // 5696
    assert(*tb[46] == '5', 'Bad conv 46'); // 696
    assert(*tb[47] == '6', 'Bad conv 47'); // 96
    assert(*tb[48] == '9', 'Bad conv 48'); // 6
    assert(*tb[49] == '6', 'Bad conv 49');
}
