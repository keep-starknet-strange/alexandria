use alexandria_math::{count_digits_of_base, pow, BitShift, BitRotate, WrappingMath};
use integer::BoundedInt;

// Test power function
#[test]
#[available_gas(1000000000)]
fn test_pow_power_2_all() {
    assert_eq!(pow::<u128>(2, 0), 1, "0");
    assert_eq!(pow::<u128>(2, 1), 2, "1");
    assert_eq!(pow::<u128>(2, 2), 4, "2");
    assert_eq!(pow::<u128>(2, 3), 8, "3");
    assert_eq!(pow::<u128>(2, 4), 16, "4");
    assert_eq!(pow::<u128>(2, 5), 32, "5");
    assert_eq!(pow::<u128>(2, 6), 64, "6");
    assert_eq!(pow::<u128>(2, 7), 128, "7");
    assert_eq!(pow::<u128>(2, 8), 256, "8");
    assert_eq!(pow::<u128>(2, 9), 512, "9");
    assert_eq!(pow::<u128>(2, 10), 1024, "10");
    assert_eq!(pow::<u128>(2, 11), 2048, "11");
    assert_eq!(pow::<u128>(2, 12), 4096, "12");
    assert_eq!(pow::<u128>(2, 13), 8192, "13");
    assert_eq!(pow::<u128>(2, 14), 16384, "14");
    assert_eq!(pow::<u128>(2, 15), 32768, "15");
    assert_eq!(pow::<u128>(2, 16), 65536, "16");
    assert_eq!(pow::<u128>(2, 17), 131072, "17");
    assert_eq!(pow::<u128>(2, 18), 262144, "18");
    assert_eq!(pow::<u128>(2, 19), 524288, "19");
    assert_eq!(pow::<u128>(2, 20), 1048576, "20");
    assert_eq!(pow::<u128>(2, 21), 2097152, "21");
    assert_eq!(pow::<u128>(2, 22), 4194304, "22");
    assert_eq!(pow::<u128>(2, 23), 8388608, "23");
    assert_eq!(pow::<u128>(2, 24), 16777216, "24");
    assert_eq!(pow::<u128>(2, 25), 33554432, "25");
    assert_eq!(pow::<u128>(2, 26), 67108864, "26");
    assert_eq!(pow::<u128>(2, 27), 134217728, "27");
    assert_eq!(pow::<u128>(2, 28), 268435456, "28");
    assert_eq!(pow::<u128>(2, 29), 536870912, "29");
    assert_eq!(pow::<u128>(2, 30), 1073741824, "30");
    assert_eq!(pow::<u128>(2, 31), 2147483648, "31");
    assert_eq!(pow::<u128>(2, 32), 4294967296, "32");
    assert_eq!(pow::<u128>(2, 33), 8589934592, "33");
    assert_eq!(pow::<u128>(2, 34), 17179869184, "34");
    assert_eq!(pow::<u128>(2, 35), 34359738368, "35");
    assert_eq!(pow::<u128>(2, 36), 68719476736, "36");
    assert_eq!(pow::<u128>(2, 37), 137438953472, "37");
    assert_eq!(pow::<u128>(2, 38), 274877906944, "38");
    assert_eq!(pow::<u128>(2, 39), 549755813888, "39");
    assert_eq!(pow::<u128>(2, 40), 1099511627776, "40");
    assert_eq!(pow::<u128>(2, 41), 2199023255552, "41");
    assert_eq!(pow::<u128>(2, 42), 4398046511104, "42");
    assert_eq!(pow::<u128>(2, 43), 8796093022208, "43");
    assert_eq!(pow::<u128>(2, 44), 17592186044416, "44");
    assert_eq!(pow::<u128>(2, 45), 35184372088832, "45");
    assert_eq!(pow::<u128>(2, 46), 70368744177664, "46");
    assert_eq!(pow::<u128>(2, 47), 140737488355328, "47");
    assert_eq!(pow::<u128>(2, 48), 281474976710656, "48");
    assert_eq!(pow::<u128>(2, 49), 562949953421312, "49");
    assert_eq!(pow::<u128>(2, 50), 1125899906842624, "50");
    assert_eq!(pow::<u128>(2, 51), 2251799813685248, "51");
    assert_eq!(pow::<u128>(2, 52), 4503599627370496, "52");
    assert_eq!(pow::<u128>(2, 53), 9007199254740992, "53");
    assert_eq!(pow::<u128>(2, 54), 18014398509481984, "54");
    assert_eq!(pow::<u128>(2, 55), 36028797018963968, "55");
    assert_eq!(pow::<u128>(2, 56), 72057594037927936, "56");
    assert_eq!(pow::<u128>(2, 57), 144115188075855872, "57");
    assert_eq!(pow::<u128>(2, 58), 288230376151711744, "58");
    assert_eq!(pow::<u128>(2, 59), 576460752303423488, "59");
    assert_eq!(pow::<u128>(2, 60), 1152921504606846976, "60");
    assert_eq!(pow::<u128>(2, 61), 2305843009213693952, "61");
    assert_eq!(pow::<u128>(2, 62), 4611686018427387904, "62");
    assert_eq!(pow::<u128>(2, 63), 9223372036854775808, "63");
    assert_eq!(pow::<u128>(2, 64), 18446744073709551616, "64");
    assert_eq!(pow::<u128>(2, 65), 36893488147419103232, "65");
    assert_eq!(pow::<u128>(2, 66), 73786976294838206464, "66");
    assert_eq!(pow::<u128>(2, 67), 147573952589676412928, "67");
    assert_eq!(pow::<u128>(2, 68), 295147905179352825856, "68");
    assert_eq!(pow::<u128>(2, 69), 590295810358705651712, "69");
    assert_eq!(pow::<u128>(2, 70), 1180591620717411303424, "70");
    assert_eq!(pow::<u128>(2, 71), 2361183241434822606848, "71");
    assert_eq!(pow::<u128>(2, 72), 4722366482869645213696, "72");
    assert_eq!(pow::<u128>(2, 73), 9444732965739290427392, "73");
    assert_eq!(pow::<u128>(2, 74), 18889465931478580854784, "74");
    assert_eq!(pow::<u128>(2, 75), 37778931862957161709568, "75");
    assert_eq!(pow::<u128>(2, 76), 75557863725914323419136, "76");
    assert_eq!(pow::<u128>(2, 77), 151115727451828646838272, "77");
    assert_eq!(pow::<u128>(2, 78), 302231454903657293676544, "78");
    assert_eq!(pow::<u128>(2, 79), 604462909807314587353088, "79");
    assert_eq!(pow::<u128>(2, 80), 1208925819614629174706176, "80");
    assert_eq!(pow::<u128>(2, 81), 2417851639229258349412352, "81");
    assert_eq!(pow::<u128>(2, 82), 4835703278458516698824704, "82");
    assert_eq!(pow::<u128>(2, 83), 9671406556917033397649408, "83");
    assert_eq!(pow::<u128>(2, 84), 19342813113834066795298816, "84");
    assert_eq!(pow::<u128>(2, 85), 38685626227668133590597632, "85");
    assert_eq!(pow::<u128>(2, 86), 77371252455336267181195264, "86");
    assert_eq!(pow::<u128>(2, 87), 154742504910672534362390528, "87");
    assert_eq!(pow::<u128>(2, 88), 309485009821345068724781056, "88");
    assert_eq!(pow::<u128>(2, 89), 618970019642690137449562112, "89");
    assert_eq!(pow::<u128>(2, 90), 1237940039285380274899124224, "90");
    assert_eq!(pow::<u128>(2, 91), 2475880078570760549798248448, "91");
    assert_eq!(pow::<u128>(2, 92), 4951760157141521099596496896, "92");
    assert_eq!(pow::<u128>(2, 93), 9903520314283042199192993792, "93");
    assert_eq!(pow::<u128>(2, 94), 19807040628566084398385987584, "94");
    assert_eq!(pow::<u128>(2, 95), 39614081257132168796771975168, "95");
    assert_eq!(pow::<u128>(2, 96), 79228162514264337593543950336, "96");
    assert_eq!(pow::<u128>(2, 97), 158456325028528675187087900672, "97");
    assert_eq!(pow::<u128>(2, 98), 316912650057057350374175801344, "98");
    assert_eq!(pow::<u128>(2, 99), 633825300114114700748351602688, "99");
    assert_eq!(pow::<u128>(2, 100), 1267650600228229401496703205376, "100");
    assert_eq!(pow::<u128>(2, 101), 2535301200456458802993406410752, "101");
    assert_eq!(pow::<u128>(2, 102), 5070602400912917605986812821504, "102");
    assert_eq!(pow::<u128>(2, 103), 10141204801825835211973625643008, "103");
    assert_eq!(pow::<u128>(2, 104), 20282409603651670423947251286016, "104");
    assert_eq!(pow::<u128>(2, 105), 40564819207303340847894502572032, "105");
    assert_eq!(pow::<u128>(2, 106), 81129638414606681695789005144064, "106");
    assert_eq!(pow::<u128>(2, 107), 162259276829213363391578010288128, "107");
    assert_eq!(pow::<u128>(2, 108), 324518553658426726783156020576256, "108");
    assert_eq!(pow::<u128>(2, 109), 649037107316853453566312041152512, "109");
    assert_eq!(pow::<u128>(2, 110), 1298074214633706907132624082305024, "110");
    assert_eq!(pow::<u128>(2, 111), 2596148429267413814265248164610048, "111");
    assert_eq!(pow::<u128>(2, 112), 5192296858534827628530496329220096, "112");
    assert_eq!(pow::<u128>(2, 113), 10384593717069655257060992658440192, "113");
    assert_eq!(pow::<u128>(2, 114), 20769187434139310514121985316880384, "114");
    assert_eq!(pow::<u128>(2, 115), 41538374868278621028243970633760768, "115");
    assert_eq!(pow::<u128>(2, 116), 83076749736557242056487941267521536, "116");
    assert_eq!(pow::<u128>(2, 117), 166153499473114484112975882535043072, "117");
    assert_eq!(pow::<u128>(2, 118), 332306998946228968225951765070086144, "118");
    assert_eq!(pow::<u128>(2, 119), 664613997892457936451903530140172288, "119");
    assert_eq!(pow::<u128>(2, 120), 1329227995784915872903807060280344576, "120");
    assert_eq!(pow::<u128>(2, 121), 2658455991569831745807614120560689152, "121");
    assert_eq!(pow::<u128>(2, 122), 5316911983139663491615228241121378304, "122");
    assert_eq!(pow::<u128>(2, 123), 10633823966279326983230456482242756608, "123");
    assert_eq!(pow::<u128>(2, 124), 21267647932558653966460912964485513216, "124");
    assert_eq!(pow::<u128>(2, 125), 42535295865117307932921825928971026432, "125");
    assert_eq!(pow::<u128>(2, 126), 85070591730234615865843651857942052864, "126");
    assert_eq!(pow::<u128>(2, 127), 170141183460469231731687303715884105728, "127");
}


#[test]
#[available_gas(2000000)]
fn pow_test() {
    assert_eq!(pow::<u128>(200, 0), 1, "200^0");
    assert_eq!(pow::<u128>(5, 9), 1953125, "5^9");
    assert_eq!(pow::<u128>(14, 30), 24201432355484595421941037243826176, "14^30");
    assert_eq!(pow::<u128>(3, 8), 6561, "3^8_u128");
    assert_eq!(pow::<u256>(3, 8), 6561, "3^8_u256");
}


// Test counting of number of digits function
#[test]
#[available_gas(2000000)]
fn count_digits_of_base_test() {
    assert_eq!(count_digits_of_base(0, 10), 0, "invalid result");
    assert_eq!(count_digits_of_base(2, 10), 1, "invalid result");
    assert_eq!(count_digits_of_base(10, 10), 2, "invalid result");
    assert_eq!(count_digits_of_base(100, 10), 3, "invalid result");
    assert_eq!(count_digits_of_base(0x80, 16), 2, "invalid result");
    assert_eq!(count_digits_of_base(0x800, 16), 3, "invalid result");
    assert_eq!(count_digits_of_base(0x888888888888888888, 16), 18, "invalid result");
}

#[test]
#[available_gas(2000000)]
fn shl_should_not_overflow() {
    assert_eq!(BitShift::shl(pow::<u8>(2, 7), 1), 0, "invalid result");
    assert_eq!(BitShift::shl(pow::<u16>(2, 15), 1), 0, "invalid result");
    assert_eq!(BitShift::shl(pow::<u32>(2, 31), 1), 0, "invalid result");
    assert_eq!(BitShift::shl(pow::<u64>(2, 63), 1), 0, "invalid result");
    assert_eq!(BitShift::shl(pow::<u128>(2, 127), 1), 0, "invalid result");
    assert_eq!(BitShift::shl(pow::<u256>(2, 255), 1), 0, "invalid result");
}

#[test]
#[available_gas(3000000)]
fn test_rotl_min() {
    assert_eq!(BitRotate::rotate_left(pow::<u8>(2, 7) + 1, 1), 3, "invalid result");
    assert_eq!(BitRotate::rotate_left(pow::<u16>(2, 15) + 1, 1), 3, "invalid result");
    assert_eq!(BitRotate::rotate_left(pow::<u32>(2, 31) + 1, 1), 3, "invalid result");
    assert_eq!(BitRotate::rotate_left(pow::<u64>(2, 63) + 1, 1), 3, "invalid result");
    assert_eq!(BitRotate::rotate_left(pow::<u128>(2, 127) + 1, 1), 3, "invalid result");
    assert_eq!(BitRotate::rotate_left(pow::<u256>(2, 255) + 1, 1), 3, "invalid result");
}

#[test]
#[available_gas(3000000)]
fn test_rotl_max() {
    assert_eq!(BitRotate::rotate_left(0b101, 7), pow::<u8>(2, 7) + 0b10, "invalid result");
    assert_eq!(BitRotate::rotate_left(0b101, 15), pow::<u16>(2, 15) + 0b10, "invalid result");
    assert_eq!(BitRotate::rotate_left(0b101, 31), pow::<u32>(2, 31) + 0b10, "invalid result");
    assert_eq!(BitRotate::rotate_left(0b101, 63), pow::<u64>(2, 63) + 0b10, "invalid result");
    assert_eq!(BitRotate::rotate_left(0b101, 127), pow::<u128>(2, 127) + 0b10, "invalid result");
    assert_eq!(BitRotate::rotate_left(0b101, 255), pow::<u256>(2, 255) + 0b10, "invalid result");
}

#[test]
#[available_gas(4000000)]
fn test_rotr_min() {
    assert_eq!(BitRotate::rotate_right(pow::<u8>(2, 7) + 1, 1), 0b11 * pow(2, 6), "invalid result");
    assert(
        BitRotate::rotate_right(pow::<u16>(2, 15) + 1, 1) == 0b11 * pow(2, 14), 'invalid result'
    );
    assert(
        BitRotate::rotate_right(pow::<u32>(2, 31) + 1, 1) == 0b11 * pow(2, 30), 'invalid result'
    );
    assert(
        BitRotate::rotate_right(pow::<u64>(2, 63) + 1, 1) == 0b11 * pow(2, 62), 'invalid result'
    );
    assert(
        BitRotate::rotate_right(pow::<u128>(2, 127) + 1, 1) == 0b11 * pow(2, 126), 'invalid result'
    );
    assert(
        BitRotate::rotate_right(pow::<u256>(2, 255) + 1, 1) == 0b11 * pow(2, 254), 'invalid result'
    );
}

#[test]
#[available_gas(2000000)]
fn test_rotr_max() {
    assert_eq!(BitRotate::rotate_right(0b101_u8, 7), 0b1010, "invalid result");
    assert_eq!(BitRotate::rotate_right(0b101_u16, 15), 0b1010, "invalid result");
    assert_eq!(BitRotate::rotate_right(0b101_u32, 31), 0b1010, "invalid result");
    assert_eq!(BitRotate::rotate_right(0b101_u64, 63), 0b1010, "invalid result");
    assert_eq!(BitRotate::rotate_right(0b101_u128, 127), 0b1010, "invalid result");
    assert_eq!(BitRotate::rotate_right(0b101_u256, 255), 0b1010, "invalid result");
}

#[test]
fn test_wrapping_math_non_wrapping() {
    assert_eq!(10_u8.wrapping_add(10_u8), 20_u8);
    assert_eq!(0_u8.wrapping_add(10_u8), 10_u8);
    assert_eq!(10_u8.wrapping_add(0_u8), 10_u8);
    assert_eq!(0_u8.wrapping_add(0_u8), 0_u8);
    assert_eq!(20_u8.wrapping_sub(10_u8), 10_u8);
    assert_eq!(10_u8.wrapping_sub(0_u8), 10_u8);
    assert_eq!(0_u8.wrapping_sub(0_u8), 0_u8);
    assert_eq!(10_u8.wrapping_mul(10_u8), 100_u8);
    assert_eq!(10_u8.wrapping_mul(0_u8), 0_u8);
    assert_eq!(0_u8.wrapping_mul(10_u8), 0_u8);
    assert_eq!(0_u8.wrapping_mul(0_u8), 0_u8);

    assert_eq!(10_u16.wrapping_add(10_u16), 20_u16);
    assert_eq!(0_u16.wrapping_add(10_u16), 10_u16);
    assert_eq!(10_u16.wrapping_add(0_u16), 10_u16);
    assert_eq!(0_u16.wrapping_add(0_u16), 0_u16);
    assert_eq!(20_u16.wrapping_sub(10_u16), 10_u16);
    assert_eq!(10_u16.wrapping_sub(0_u16), 10_u16);
    assert_eq!(0_u16.wrapping_sub(0_u16), 0_u16);
    assert_eq!(10_u16.wrapping_mul(10_u16), 100_u16);
    assert_eq!(10_u16.wrapping_mul(0_u16), 0_u16);
    assert_eq!(0_u16.wrapping_mul(10_u16), 0_u16);
    assert_eq!(0_u16.wrapping_mul(0_u16), 0_u16);

    assert_eq!(10_u32.wrapping_add(10_u32), 20_u32);
    assert_eq!(0_u32.wrapping_add(10_u32), 10_u32);
    assert_eq!(10_u32.wrapping_add(0_u32), 10_u32);
    assert_eq!(0_u32.wrapping_add(0_u32), 0_u32);
    assert_eq!(20_u32.wrapping_sub(10_u32), 10_u32);
    assert_eq!(10_u32.wrapping_sub(0_u32), 10_u32);
    assert_eq!(0_u32.wrapping_sub(0_u32), 0_u32);
    assert_eq!(10_u32.wrapping_mul(10_u32), 100_u32);
    assert_eq!(10_u32.wrapping_mul(0_u32), 0_u32);
    assert_eq!(0_u32.wrapping_mul(10_u32), 0_u32);
    assert_eq!(0_u32.wrapping_mul(0_u32), 0_u32);

    assert_eq!(10_u64.wrapping_add(10_u64), 20_u64);
    assert_eq!(0_u64.wrapping_add(10_u64), 10_u64);
    assert_eq!(10_u64.wrapping_add(0_u64), 10_u64);
    assert_eq!(0_u64.wrapping_add(0_u64), 0_u64);
    assert_eq!(20_u64.wrapping_sub(10_u64), 10_u64);
    assert_eq!(10_u64.wrapping_sub(0_u64), 10_u64);
    assert_eq!(0_u64.wrapping_sub(0_u64), 0_u64);
    assert_eq!(10_u64.wrapping_mul(10_u64), 100_u64);
    assert_eq!(10_u64.wrapping_mul(0_u64), 0_u64);
    assert_eq!(0_u64.wrapping_mul(10_u64), 0_u64);
    assert_eq!(0_u64.wrapping_mul(0_u64), 0_u64);

    assert_eq!(10_u128.wrapping_add(10_u128), 20_u128);
    assert_eq!(0_u128.wrapping_add(10_u128), 10_u128);
    assert_eq!(10_u128.wrapping_add(0_u128), 10_u128);
    assert_eq!(0_u128.wrapping_add(0_u128), 0_u128);
    assert_eq!(20_u128.wrapping_sub(10_u128), 10_u128);
    assert_eq!(10_u128.wrapping_sub(0_u128), 10_u128);
    assert_eq!(0_u128.wrapping_sub(0_u128), 0_u128);
    assert_eq!(10_u128.wrapping_mul(10_u128), 100_u128);
    assert_eq!(10_u128.wrapping_mul(0_u128), 0_u128);
    assert_eq!(0_u128.wrapping_mul(10_u128), 0_u128);
    assert_eq!(0_u128.wrapping_mul(0_u128), 0_u128);

    assert_eq!(10_u256.wrapping_add(10_u256), 20_u256);
    assert_eq!(0_u256.wrapping_add(10_u256), 10_u256);
    assert_eq!(10_u256.wrapping_add(0_u256), 10_u256);
    assert_eq!(0_u256.wrapping_add(0_u256), 0_u256);
    assert_eq!(20_u256.wrapping_sub(10_u256), 10_u256);
    assert_eq!(10_u256.wrapping_sub(0_u256), 10_u256);
    assert_eq!(0_u256.wrapping_sub(0_u256), 0_u256);
    assert_eq!(10_u256.wrapping_mul(10_u256), 100_u256);
    assert_eq!(10_u256.wrapping_mul(0_u256), 0_u256);
    assert_eq!(0_u256.wrapping_mul(10_u256), 0_u256);
    assert_eq!(0_u256.wrapping_mul(0_u256), 0_u256);
}

#[test]
fn test_wrapping_math_wrapping() {
    assert_eq!(BoundedInt::<u8>::max().wrapping_add(1_u8), 0_u8);
    assert_eq!(1_u8.wrapping_add(BoundedInt::<u8>::max()), 0_u8);
    assert_eq!(BoundedInt::<u8>::max().wrapping_add(2_u8), 1_u8);
    assert_eq!(2_u8.wrapping_add(BoundedInt::<u8>::max()), 1_u8);
    assert_eq!(
        BoundedInt::<u8>::max().wrapping_add(BoundedInt::<u8>::max()),
        BoundedInt::<u8>::max() - 1_u8
    );
    assert_eq!(BoundedInt::<u8>::min().wrapping_sub(1_u8), BoundedInt::<u8>::max());
    assert_eq!(BoundedInt::<u8>::min().wrapping_sub(2_u8), BoundedInt::<u8>::max() - 1_u8);
    assert_eq!(1_u8.wrapping_sub(BoundedInt::<u8>::max()), 2_u8);
    assert_eq!(0_u8.wrapping_sub(BoundedInt::<u8>::max()), 1_u8);
    assert_eq!(BoundedInt::<u8>::max().wrapping_mul(BoundedInt::<u8>::max()), 1_u8);
    assert_eq!((BoundedInt::<u8>::max() - 1_u8).wrapping_mul(2_u8), BoundedInt::<u8>::max() - 3_u8);

    assert_eq!(BoundedInt::<u16>::max().wrapping_add(1_u16), 0_u16);
    assert_eq!(1_u16.wrapping_add(BoundedInt::<u16>::max()), 0_u16);
    assert_eq!(BoundedInt::<u16>::max().wrapping_add(2_u16), 1_u16);
    assert_eq!(2_u16.wrapping_add(BoundedInt::<u16>::max()), 1_u16);
    assert_eq!(
        BoundedInt::<u16>::max().wrapping_add(BoundedInt::<u16>::max()),
        BoundedInt::<u16>::max() - 1_u16
    );
    assert_eq!(BoundedInt::<u16>::min().wrapping_sub(1_u16), BoundedInt::<u16>::max());
    assert_eq!(BoundedInt::<u16>::min().wrapping_sub(2_u16), BoundedInt::<u16>::max() - 1_u16);
    assert_eq!(1_u16.wrapping_sub(BoundedInt::<u16>::max()), 2_u16);
    assert_eq!(0_u16.wrapping_sub(BoundedInt::<u16>::max()), 1_u16);
    assert_eq!(BoundedInt::<u16>::max().wrapping_mul(BoundedInt::<u16>::max()), 1_u16);
    assert_eq!(
        (BoundedInt::<u16>::max() - 1_u16).wrapping_mul(2_u16), BoundedInt::<u16>::max() - 3_u16
    );

    assert_eq!(BoundedInt::<u32>::max().wrapping_add(1_u32), 0_u32);
    assert_eq!(1_u32.wrapping_add(BoundedInt::<u32>::max()), 0_u32);
    assert_eq!(BoundedInt::<u32>::max().wrapping_add(2_u32), 1_u32);
    assert_eq!(2_u32.wrapping_add(BoundedInt::<u32>::max()), 1_u32);
    assert_eq!(
        BoundedInt::<u32>::max().wrapping_add(BoundedInt::<u32>::max()),
        BoundedInt::<u32>::max() - 1_u32
    );
    assert_eq!(BoundedInt::<u32>::min().wrapping_sub(1_u32), BoundedInt::<u32>::max());
    assert_eq!(BoundedInt::<u32>::min().wrapping_sub(2_u32), BoundedInt::<u32>::max() - 1_u32);
    assert_eq!(1_u32.wrapping_sub(BoundedInt::<u32>::max()), 2_u32);
    assert_eq!(0_u32.wrapping_sub(BoundedInt::<u32>::max()), 1_u32);
    assert_eq!(BoundedInt::<u32>::max().wrapping_mul(BoundedInt::<u32>::max()), 1_u32);
    assert_eq!(
        (BoundedInt::<u32>::max() - 1_u32).wrapping_mul(2_u32), BoundedInt::<u32>::max() - 3_u32
    );

    assert_eq!(BoundedInt::<u64>::max().wrapping_add(1_u64), 0_u64);
    assert_eq!(1_u64.wrapping_add(BoundedInt::<u64>::max()), 0_u64);
    assert_eq!(BoundedInt::<u64>::max().wrapping_add(2_u64), 1_u64);
    assert_eq!(2_u64.wrapping_add(BoundedInt::<u64>::max()), 1_u64);
    assert_eq!(
        BoundedInt::<u64>::max().wrapping_add(BoundedInt::<u64>::max()),
        BoundedInt::<u64>::max() - 1_u64
    );
    assert_eq!(BoundedInt::<u64>::min().wrapping_sub(1_u64), BoundedInt::<u64>::max());
    assert_eq!(BoundedInt::<u64>::min().wrapping_sub(2_u64), BoundedInt::<u64>::max() - 1_u64);
    assert_eq!(1_u64.wrapping_sub(BoundedInt::<u64>::max()), 2_u64);
    assert_eq!(0_u64.wrapping_sub(BoundedInt::<u64>::max()), 1_u64);
    assert_eq!(BoundedInt::<u64>::max().wrapping_mul(BoundedInt::<u64>::max()), 1_u64);
    assert_eq!(
        (BoundedInt::<u64>::max() - 1_u64).wrapping_mul(2_u64), BoundedInt::<u64>::max() - 3_u64
    );

    assert_eq!(BoundedInt::<u128>::max().wrapping_add(1_u128), 0_u128);
    assert_eq!(1_u128.wrapping_add(BoundedInt::<u128>::max()), 0_u128);
    assert_eq!(BoundedInt::<u128>::max().wrapping_add(2_u128), 1_u128);
    assert_eq!(2_u128.wrapping_add(BoundedInt::<u128>::max()), 1_u128);
    assert_eq!(
        BoundedInt::<u128>::max().wrapping_add(BoundedInt::<u128>::max()),
        BoundedInt::<u128>::max() - 1_u128
    );
    assert_eq!(BoundedInt::<u128>::min().wrapping_sub(1_u128), BoundedInt::<u128>::max());
    assert_eq!(BoundedInt::<u128>::min().wrapping_sub(2_u128), BoundedInt::<u128>::max() - 1_u128);
    assert_eq!(1_u128.wrapping_sub(BoundedInt::<u128>::max()), 2_u128);
    assert_eq!(0_u128.wrapping_sub(BoundedInt::<u128>::max()), 1_u128);
    assert_eq!(BoundedInt::<u128>::max().wrapping_mul(BoundedInt::<u128>::max()), 1_u128);
    assert_eq!(
        (BoundedInt::<u128>::max() - 1_u128).wrapping_mul(2_u128),
        BoundedInt::<u128>::max() - 3_u128
    );

    assert_eq!(BoundedInt::<u256>::max().wrapping_add(1_u256), 0_u256);
    assert_eq!(1_u256.wrapping_add(BoundedInt::<u256>::max()), 0_u256);
    assert_eq!(BoundedInt::<u256>::max().wrapping_add(2_u256), 1_u256);
    assert_eq!(2_u256.wrapping_add(BoundedInt::<u256>::max()), 1_u256);
    assert_eq!(
        BoundedInt::<u256>::max().wrapping_add(BoundedInt::<u256>::max()),
        BoundedInt::<u256>::max() - 1_u256
    );
    assert_eq!(BoundedInt::<u256>::min().wrapping_sub(1_u256), BoundedInt::<u256>::max());
    assert_eq!(BoundedInt::<u256>::min().wrapping_sub(2_u256), BoundedInt::<u256>::max() - 1_u256);
    assert_eq!(1_u256.wrapping_sub(BoundedInt::<u256>::max()), 2_u256);
    assert_eq!(0_u256.wrapping_sub(BoundedInt::<u256>::max()), 1_u256);
    assert_eq!(BoundedInt::<u256>::max().wrapping_mul(BoundedInt::<u256>::max()), 1_u256);
    assert_eq!(
        (BoundedInt::<u256>::max() - 1_u256).wrapping_mul(2_u256),
        BoundedInt::<u256>::max() - 3_u256
    );
}
