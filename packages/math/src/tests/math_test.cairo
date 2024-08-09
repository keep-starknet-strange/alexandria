use alexandria_math::{count_digits_of_base, pow, BitShift, BitRotate, WrappingMath};
use core::num::traits::Bounded;

// Test power function
#[test]
#[available_gas(1000000000)]
fn test_pow_power_2_all() {
    assert_eq!(pow::<u128>(2, 0), 1);
    assert_eq!(pow::<u128>(2, 1), 2);
    assert_eq!(pow::<u128>(2, 2), 4);
    assert_eq!(pow::<u128>(2, 3), 8);
    assert_eq!(pow::<u128>(2, 4), 16);
    assert_eq!(pow::<u128>(2, 5), 32);
    assert_eq!(pow::<u128>(2, 6), 64);
    assert_eq!(pow::<u128>(2, 7), 128);
    assert_eq!(pow::<u128>(2, 8), 256);
    assert_eq!(pow::<u128>(2, 9), 512);
    assert_eq!(pow::<u128>(2, 10), 1024);
    assert_eq!(pow::<u128>(2, 11), 2048);
    assert_eq!(pow::<u128>(2, 12), 4096);
    assert_eq!(pow::<u128>(2, 13), 8192);
    assert_eq!(pow::<u128>(2, 14), 16384);
    assert_eq!(pow::<u128>(2, 15), 32768);
    assert_eq!(pow::<u128>(2, 16), 65536);
    assert_eq!(pow::<u128>(2, 17), 131072);
    assert_eq!(pow::<u128>(2, 18), 262144);
    assert_eq!(pow::<u128>(2, 19), 524288);
    assert_eq!(pow::<u128>(2, 20), 1048576);
    assert_eq!(pow::<u128>(2, 21), 2097152);
    assert_eq!(pow::<u128>(2, 22), 4194304);
    assert_eq!(pow::<u128>(2, 23), 8388608);
    assert_eq!(pow::<u128>(2, 24), 16777216);
    assert_eq!(pow::<u128>(2, 25), 33554432);
    assert_eq!(pow::<u128>(2, 26), 67108864);
    assert_eq!(pow::<u128>(2, 27), 134217728);
    assert_eq!(pow::<u128>(2, 28), 268435456);
    assert_eq!(pow::<u128>(2, 29), 536870912);
    assert_eq!(pow::<u128>(2, 30), 1073741824);
    assert_eq!(pow::<u128>(2, 31), 2147483648);
    assert_eq!(pow::<u128>(2, 32), 4294967296);
    assert_eq!(pow::<u128>(2, 33), 8589934592);
    assert_eq!(pow::<u128>(2, 34), 17179869184);
    assert_eq!(pow::<u128>(2, 35), 34359738368);
    assert_eq!(pow::<u128>(2, 36), 68719476736);
    assert_eq!(pow::<u128>(2, 37), 137438953472);
    assert_eq!(pow::<u128>(2, 38), 274877906944);
    assert_eq!(pow::<u128>(2, 39), 549755813888);
    assert_eq!(pow::<u128>(2, 40), 1099511627776);
    assert_eq!(pow::<u128>(2, 41), 2199023255552);
    assert_eq!(pow::<u128>(2, 42), 4398046511104);
    assert_eq!(pow::<u128>(2, 43), 8796093022208);
    assert_eq!(pow::<u128>(2, 44), 17592186044416);
    assert_eq!(pow::<u128>(2, 45), 35184372088832);
    assert_eq!(pow::<u128>(2, 46), 70368744177664);
    assert_eq!(pow::<u128>(2, 47), 140737488355328);
    assert_eq!(pow::<u128>(2, 48), 281474976710656);
    assert_eq!(pow::<u128>(2, 49), 562949953421312);
    assert_eq!(pow::<u128>(2, 50), 1125899906842624);
    assert_eq!(pow::<u128>(2, 51), 2251799813685248);
    assert_eq!(pow::<u128>(2, 52), 4503599627370496);
    assert_eq!(pow::<u128>(2, 53), 9007199254740992);
    assert_eq!(pow::<u128>(2, 54), 18014398509481984);
    assert_eq!(pow::<u128>(2, 55), 36028797018963968);
    assert_eq!(pow::<u128>(2, 56), 72057594037927936);
    assert_eq!(pow::<u128>(2, 57), 144115188075855872);
    assert_eq!(pow::<u128>(2, 58), 288230376151711744);
    assert_eq!(pow::<u128>(2, 59), 576460752303423488);
    assert_eq!(pow::<u128>(2, 60), 1152921504606846976);
    assert_eq!(pow::<u128>(2, 61), 2305843009213693952);
    assert_eq!(pow::<u128>(2, 62), 4611686018427387904);
    assert_eq!(pow::<u128>(2, 63), 9223372036854775808);
    assert_eq!(pow::<u128>(2, 64), 18446744073709551616);
    assert_eq!(pow::<u128>(2, 65), 36893488147419103232);
    assert_eq!(pow::<u128>(2, 66), 73786976294838206464);
    assert_eq!(pow::<u128>(2, 67), 147573952589676412928);
    assert_eq!(pow::<u128>(2, 68), 295147905179352825856);
    assert_eq!(pow::<u128>(2, 69), 590295810358705651712);
    assert_eq!(pow::<u128>(2, 70), 1180591620717411303424);
    assert_eq!(pow::<u128>(2, 71), 2361183241434822606848);
    assert_eq!(pow::<u128>(2, 72), 4722366482869645213696);
    assert_eq!(pow::<u128>(2, 73), 9444732965739290427392);
    assert_eq!(pow::<u128>(2, 74), 18889465931478580854784);
    assert_eq!(pow::<u128>(2, 75), 37778931862957161709568);
    assert_eq!(pow::<u128>(2, 76), 75557863725914323419136);
    assert_eq!(pow::<u128>(2, 77), 151115727451828646838272);
    assert_eq!(pow::<u128>(2, 78), 302231454903657293676544);
    assert_eq!(pow::<u128>(2, 79), 604462909807314587353088);
    assert_eq!(pow::<u128>(2, 80), 1208925819614629174706176);
    assert_eq!(pow::<u128>(2, 81), 2417851639229258349412352);
    assert_eq!(pow::<u128>(2, 82), 4835703278458516698824704);
    assert_eq!(pow::<u128>(2, 83), 9671406556917033397649408);
    assert_eq!(pow::<u128>(2, 84), 19342813113834066795298816);
    assert_eq!(pow::<u128>(2, 85), 38685626227668133590597632);
    assert_eq!(pow::<u128>(2, 86), 77371252455336267181195264);
    assert_eq!(pow::<u128>(2, 87), 154742504910672534362390528);
    assert_eq!(pow::<u128>(2, 88), 309485009821345068724781056);
    assert_eq!(pow::<u128>(2, 89), 618970019642690137449562112);
    assert_eq!(pow::<u128>(2, 90), 1237940039285380274899124224);
    assert_eq!(pow::<u128>(2, 91), 2475880078570760549798248448);
    assert_eq!(pow::<u128>(2, 92), 4951760157141521099596496896);
    assert_eq!(pow::<u128>(2, 93), 9903520314283042199192993792);
    assert_eq!(pow::<u128>(2, 94), 19807040628566084398385987584);
    assert_eq!(pow::<u128>(2, 95), 39614081257132168796771975168);
    assert_eq!(pow::<u128>(2, 96), 79228162514264337593543950336);
    assert_eq!(pow::<u128>(2, 97), 158456325028528675187087900672);
    assert_eq!(pow::<u128>(2, 98), 316912650057057350374175801344);
    assert_eq!(pow::<u128>(2, 99), 633825300114114700748351602688);
    assert_eq!(pow::<u128>(2, 100), 1267650600228229401496703205376);
    assert_eq!(pow::<u128>(2, 101), 2535301200456458802993406410752);
    assert_eq!(pow::<u128>(2, 102), 5070602400912917605986812821504);
    assert_eq!(pow::<u128>(2, 103), 10141204801825835211973625643008);
    assert_eq!(pow::<u128>(2, 104), 20282409603651670423947251286016);
    assert_eq!(pow::<u128>(2, 105), 40564819207303340847894502572032);
    assert_eq!(pow::<u128>(2, 106), 81129638414606681695789005144064);
    assert_eq!(pow::<u128>(2, 107), 162259276829213363391578010288128);
    assert_eq!(pow::<u128>(2, 108), 324518553658426726783156020576256);
    assert_eq!(pow::<u128>(2, 109), 649037107316853453566312041152512);
    assert_eq!(pow::<u128>(2, 110), 1298074214633706907132624082305024);
    assert_eq!(pow::<u128>(2, 111), 2596148429267413814265248164610048);
    assert_eq!(pow::<u128>(2, 112), 5192296858534827628530496329220096);
    assert_eq!(pow::<u128>(2, 113), 10384593717069655257060992658440192);
    assert_eq!(pow::<u128>(2, 114), 20769187434139310514121985316880384);
    assert_eq!(pow::<u128>(2, 115), 41538374868278621028243970633760768);
    assert_eq!(pow::<u128>(2, 116), 83076749736557242056487941267521536);
    assert_eq!(pow::<u128>(2, 117), 166153499473114484112975882535043072);
    assert_eq!(pow::<u128>(2, 118), 332306998946228968225951765070086144);
    assert_eq!(pow::<u128>(2, 119), 664613997892457936451903530140172288);
    assert_eq!(pow::<u128>(2, 120), 1329227995784915872903807060280344576);
    assert_eq!(pow::<u128>(2, 121), 2658455991569831745807614120560689152);
    assert_eq!(pow::<u128>(2, 122), 5316911983139663491615228241121378304);
    assert_eq!(pow::<u128>(2, 123), 10633823966279326983230456482242756608);
    assert_eq!(pow::<u128>(2, 124), 21267647932558653966460912964485513216);
    assert_eq!(pow::<u128>(2, 125), 42535295865117307932921825928971026432);
    assert_eq!(pow::<u128>(2, 126), 85070591730234615865843651857942052864);
    assert_eq!(pow::<u128>(2, 127), 170141183460469231731687303715884105728);
}


#[test]
#[available_gas(2000000)]
fn pow_test() {
    assert_eq!(pow::<u128>(200, 0), 1);
    assert_eq!(pow::<u128>(5, 9), 1953125);
    assert_eq!(pow::<u128>(14, 30), 24201432355484595421941037243826176);
    assert_eq!(pow::<u128>(3, 8), 6561);
    assert_eq!(pow::<u256>(3, 8), 6561);
}


// Test counting of number of digits function
#[test]
#[available_gas(2000000)]
fn count_digits_of_base_test() {
    assert_eq!(count_digits_of_base(0, 10), 0);
    assert_eq!(count_digits_of_base(2, 10), 1);
    assert_eq!(count_digits_of_base(10, 10), 2);
    assert_eq!(count_digits_of_base(100, 10), 3);
    assert_eq!(count_digits_of_base(0x80, 16), 2);
    assert_eq!(count_digits_of_base(0x800, 16), 3);
    assert_eq!(count_digits_of_base(0x888888888888888888, 16), 18);
}

#[test]
#[available_gas(2000000)]
fn shl_should_not_overflow() {
    assert_eq!(BitShift::shl(pow::<u8>(2, 7), 1), 0);
    assert_eq!(BitShift::shl(pow::<u16>(2, 15), 1), 0);
    assert_eq!(BitShift::shl(pow::<u32>(2, 31), 1), 0);
    assert_eq!(BitShift::shl(pow::<u64>(2, 63), 1), 0);
    assert_eq!(BitShift::shl(pow::<u128>(2, 127), 1), 0);
    assert_eq!(BitShift::shl(pow::<u256>(2, 255), 1), 0);
}

#[test]
#[available_gas(3000000)]
fn test_rotl_min() {
    assert_eq!(BitRotate::rotate_left(pow::<u8>(2, 7) + 1, 1), 3);
    assert_eq!(BitRotate::rotate_left(pow::<u16>(2, 15) + 1, 1), 3);
    assert_eq!(BitRotate::rotate_left(pow::<u32>(2, 31) + 1, 1), 3);
    assert_eq!(BitRotate::rotate_left(pow::<u64>(2, 63) + 1, 1), 3);
    assert_eq!(BitRotate::rotate_left(pow::<u128>(2, 127) + 1, 1), 3);
    assert_eq!(BitRotate::rotate_left(pow::<u256>(2, 255) + 1, 1), 3);
}

#[test]
#[available_gas(3000000)]
fn test_rotl_max() {
    assert_eq!(BitRotate::rotate_left(0b101, 7), pow::<u8>(2, 7) + 0b10);
    assert_eq!(BitRotate::rotate_left(0b101, 15), pow::<u16>(2, 15) + 0b10);
    assert_eq!(BitRotate::rotate_left(0b101, 31), pow::<u32>(2, 31) + 0b10);
    assert_eq!(BitRotate::rotate_left(0b101, 63), pow::<u64>(2, 63) + 0b10);
    assert_eq!(BitRotate::rotate_left(0b101, 127), pow::<u128>(2, 127) + 0b10);
    assert_eq!(BitRotate::rotate_left(0b101, 255), pow::<u256>(2, 255) + 0b10);
}

#[test]
#[available_gas(4000000)]
fn test_rotr_min() {
    assert_eq!(BitRotate::rotate_right(pow::<u8>(2, 7) + 1, 1), 0b11 * pow(2, 6));
    assert_eq!(BitRotate::rotate_right(pow::<u16>(2, 15) + 1, 1), 0b11 * pow(2, 14));
    assert_eq!(BitRotate::rotate_right(pow::<u32>(2, 31) + 1, 1), 0b11 * pow(2, 30));
    assert_eq!(BitRotate::rotate_right(pow::<u64>(2, 63) + 1, 1), 0b11 * pow(2, 62));
    assert_eq!(BitRotate::rotate_right(pow::<u128>(2, 127) + 1, 1), 0b11 * pow(2, 126));
    assert_eq!(BitRotate::rotate_right(pow::<u256>(2, 255) + 1, 1), 0b11 * pow(2, 254));
}

#[test]
#[available_gas(2000000)]
fn test_rotr_max() {
    assert_eq!(BitRotate::rotate_right(0b101_u8, 7), 0b1010);
    assert_eq!(BitRotate::rotate_right(0b101_u16, 15), 0b1010);
    assert_eq!(BitRotate::rotate_right(0b101_u32, 31), 0b1010);
    assert_eq!(BitRotate::rotate_right(0b101_u64, 63), 0b1010);
    assert_eq!(BitRotate::rotate_right(0b101_u128, 127), 0b1010);
    assert_eq!(BitRotate::rotate_right(0b101_u256, 255), 0b1010);
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
    assert_eq!(Bounded::<u8>::MAX.wrapping_add(1_u8), 0_u8);
    assert_eq!(1_u8.wrapping_add(Bounded::<u8>::MAX), 0_u8);
    assert_eq!(Bounded::<u8>::MAX.wrapping_add(2_u8), 1_u8);
    assert_eq!(2_u8.wrapping_add(Bounded::<u8>::MAX), 1_u8);
    assert_eq!(Bounded::<u8>::MAX.wrapping_add(Bounded::<u8>::MAX), Bounded::<u8>::MAX - 1_u8);
    assert_eq!(Bounded::<u8>::MIN.wrapping_sub(1_u8), Bounded::<u8>::MAX);
    assert_eq!(Bounded::<u8>::MIN.wrapping_sub(2_u8), Bounded::<u8>::MAX - 1_u8);
    assert_eq!(1_u8.wrapping_sub(Bounded::<u8>::MAX), 2_u8);
    assert_eq!(0_u8.wrapping_sub(Bounded::<u8>::MAX), 1_u8);
    assert_eq!(Bounded::<u8>::MAX.wrapping_mul(Bounded::<u8>::MAX), 1_u8);
    assert_eq!((Bounded::<u8>::MAX - 1_u8).wrapping_mul(2_u8), Bounded::<u8>::MAX - 3_u8);

    assert_eq!(Bounded::<u16>::MAX.wrapping_add(1_u16), 0_u16);
    assert_eq!(1_u16.wrapping_add(Bounded::<u16>::MAX), 0_u16);
    assert_eq!(Bounded::<u16>::MAX.wrapping_add(2_u16), 1_u16);
    assert_eq!(2_u16.wrapping_add(Bounded::<u16>::MAX), 1_u16);
    assert_eq!(Bounded::<u16>::MAX.wrapping_add(Bounded::<u16>::MAX), Bounded::<u16>::MAX - 1_u16);
    assert_eq!(Bounded::<u16>::MIN.wrapping_sub(1_u16), Bounded::<u16>::MAX);
    assert_eq!(Bounded::<u16>::MIN.wrapping_sub(2_u16), Bounded::<u16>::MAX - 1_u16);
    assert_eq!(1_u16.wrapping_sub(Bounded::<u16>::MAX), 2_u16);
    assert_eq!(0_u16.wrapping_sub(Bounded::<u16>::MAX), 1_u16);
    assert_eq!(Bounded::<u16>::MAX.wrapping_mul(Bounded::<u16>::MAX), 1_u16);
    assert_eq!((Bounded::<u16>::MAX - 1_u16).wrapping_mul(2_u16), Bounded::<u16>::MAX - 3_u16);

    assert_eq!(Bounded::<u32>::MAX.wrapping_add(1_u32), 0_u32);
    assert_eq!(1_u32.wrapping_add(Bounded::<u32>::MAX), 0_u32);
    assert_eq!(Bounded::<u32>::MAX.wrapping_add(2_u32), 1_u32);
    assert_eq!(2_u32.wrapping_add(Bounded::<u32>::MAX), 1_u32);
    assert_eq!(Bounded::<u32>::MAX.wrapping_add(Bounded::<u32>::MAX), Bounded::<u32>::MAX - 1_u32);
    assert_eq!(Bounded::<u32>::MIN.wrapping_sub(1_u32), Bounded::<u32>::MAX);
    assert_eq!(Bounded::<u32>::MIN.wrapping_sub(2_u32), Bounded::<u32>::MAX - 1_u32);
    assert_eq!(1_u32.wrapping_sub(Bounded::<u32>::MAX), 2_u32);
    assert_eq!(0_u32.wrapping_sub(Bounded::<u32>::MAX), 1_u32);
    assert_eq!(Bounded::<u32>::MAX.wrapping_mul(Bounded::<u32>::MAX), 1_u32);
    assert_eq!((Bounded::<u32>::MAX - 1_u32).wrapping_mul(2_u32), Bounded::<u32>::MAX - 3_u32);

    assert_eq!(Bounded::<u64>::MAX.wrapping_add(1_u64), 0_u64);
    assert_eq!(1_u64.wrapping_add(Bounded::<u64>::MAX), 0_u64);
    assert_eq!(Bounded::<u64>::MAX.wrapping_add(2_u64), 1_u64);
    assert_eq!(2_u64.wrapping_add(Bounded::<u64>::MAX), 1_u64);
    assert_eq!(Bounded::<u64>::MAX.wrapping_add(Bounded::<u64>::MAX), Bounded::<u64>::MAX - 1_u64);
    assert_eq!(Bounded::<u64>::MIN.wrapping_sub(1_u64), Bounded::<u64>::MAX);
    assert_eq!(Bounded::<u64>::MIN.wrapping_sub(2_u64), Bounded::<u64>::MAX - 1_u64);
    assert_eq!(1_u64.wrapping_sub(Bounded::<u64>::MAX), 2_u64);
    assert_eq!(0_u64.wrapping_sub(Bounded::<u64>::MAX), 1_u64);
    assert_eq!(Bounded::<u64>::MAX.wrapping_mul(Bounded::<u64>::MAX), 1_u64);
    assert_eq!((Bounded::<u64>::MAX - 1_u64).wrapping_mul(2_u64), Bounded::<u64>::MAX - 3_u64);

    assert_eq!(Bounded::<u128>::MAX.wrapping_add(1_u128), 0_u128);
    assert_eq!(1_u128.wrapping_add(Bounded::<u128>::MAX), 0_u128);
    assert_eq!(Bounded::<u128>::MAX.wrapping_add(2_u128), 1_u128);
    assert_eq!(2_u128.wrapping_add(Bounded::<u128>::MAX), 1_u128);
    assert_eq!(
        Bounded::<u128>::MAX.wrapping_add(Bounded::<u128>::MAX), Bounded::<u128>::MAX - 1_u128
    );
    assert_eq!(Bounded::<u128>::MIN.wrapping_sub(1_u128), Bounded::<u128>::MAX);
    assert_eq!(Bounded::<u128>::MIN.wrapping_sub(2_u128), Bounded::<u128>::MAX - 1_u128);
    assert_eq!(1_u128.wrapping_sub(Bounded::<u128>::MAX), 2_u128);
    assert_eq!(0_u128.wrapping_sub(Bounded::<u128>::MAX), 1_u128);
    assert_eq!(Bounded::<u128>::MAX.wrapping_mul(Bounded::<u128>::MAX), 1_u128);
    assert_eq!((Bounded::<u128>::MAX - 1_u128).wrapping_mul(2_u128), Bounded::<u128>::MAX - 3_u128);

    assert_eq!(Bounded::<u256>::MAX.wrapping_add(1_u256), 0_u256);
    assert_eq!(1_u256.wrapping_add(Bounded::<u256>::MAX), 0_u256);
    assert_eq!(Bounded::<u256>::MAX.wrapping_add(2_u256), 1_u256);
    assert_eq!(2_u256.wrapping_add(Bounded::<u256>::MAX), 1_u256);
    assert_eq!(
        Bounded::<u256>::MAX.wrapping_add(Bounded::<u256>::MAX), Bounded::<u256>::MAX - 1_u256
    );
    assert_eq!(Bounded::<u256>::MIN.wrapping_sub(1_u256), Bounded::<u256>::MAX);
    assert_eq!(Bounded::<u256>::MIN.wrapping_sub(2_u256), Bounded::<u256>::MAX - 1_u256);
    assert_eq!(1_u256.wrapping_sub(Bounded::<u256>::MAX), 2_u256);
    assert_eq!(0_u256.wrapping_sub(Bounded::<u256>::MAX), 1_u256);
    assert_eq!(Bounded::<u256>::MAX.wrapping_mul(Bounded::<u256>::MAX), 1_u256);
    assert_eq!((Bounded::<u256>::MAX - 1_u256).wrapping_mul(2_u256), Bounded::<u256>::MAX - 3_u256);
}
