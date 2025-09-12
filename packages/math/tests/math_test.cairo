use alexandria_math::{BitRotate, BitShift, WrappingMath, count_digits_of_base, pow};
use core::num::traits::Bounded;

// Test power function
#[test]
fn test_pow_power_2_all() {
    assert!(pow::<u128>(2, 0) == 1);
    assert!(pow::<u128>(2, 1) == 2);
    assert!(pow::<u128>(2, 2) == 4);
    assert!(pow::<u128>(2, 3) == 8);
    assert!(pow::<u128>(2, 4) == 16);
    assert!(pow::<u128>(2, 5) == 32);
    assert!(pow::<u128>(2, 6) == 64);
    assert!(pow::<u128>(2, 7) == 128);
    assert!(pow::<u128>(2, 8) == 256);
    assert!(pow::<u128>(2, 9) == 512);
    assert!(pow::<u128>(2, 10) == 1024);
    assert!(pow::<u128>(2, 11) == 2048);
    assert!(pow::<u128>(2, 12) == 4096);
    assert!(pow::<u128>(2, 13) == 8192);
    assert!(pow::<u128>(2, 14) == 16384);
    assert!(pow::<u128>(2, 15) == 32768);
    assert!(pow::<u128>(2, 16) == 65536);
    assert!(pow::<u128>(2, 17) == 131072);
    assert!(pow::<u128>(2, 18) == 262144);
    assert!(pow::<u128>(2, 19) == 524288);
    assert!(pow::<u128>(2, 20) == 1048576);
    assert!(pow::<u128>(2, 21) == 2097152);
    assert!(pow::<u128>(2, 22) == 4194304);
    assert!(pow::<u128>(2, 23) == 8388608);
    assert!(pow::<u128>(2, 24) == 16777216);
    assert!(pow::<u128>(2, 25) == 33554432);
    assert!(pow::<u128>(2, 26) == 67108864);
    assert!(pow::<u128>(2, 27) == 134217728);
    assert!(pow::<u128>(2, 28) == 268435456);
    assert!(pow::<u128>(2, 29) == 536870912);
    assert!(pow::<u128>(2, 30) == 1073741824);
    assert!(pow::<u128>(2, 31) == 2147483648);
    assert!(pow::<u128>(2, 32) == 4294967296);
    assert!(pow::<u128>(2, 33) == 8589934592);
    assert!(pow::<u128>(2, 34) == 17179869184);
    assert!(pow::<u128>(2, 35) == 34359738368);
    assert!(pow::<u128>(2, 36) == 68719476736);
    assert!(pow::<u128>(2, 37) == 137438953472);
    assert!(pow::<u128>(2, 38) == 274877906944);
    assert!(pow::<u128>(2, 39) == 549755813888);
    assert!(pow::<u128>(2, 40) == 1099511627776);
    assert!(pow::<u128>(2, 41) == 2199023255552);
    assert!(pow::<u128>(2, 42) == 4398046511104);
    assert!(pow::<u128>(2, 43) == 8796093022208);
    assert!(pow::<u128>(2, 44) == 17592186044416);
    assert!(pow::<u128>(2, 45) == 35184372088832);
    assert!(pow::<u128>(2, 46) == 70368744177664);
    assert!(pow::<u128>(2, 47) == 140737488355328);
    assert!(pow::<u128>(2, 48) == 281474976710656);
    assert!(pow::<u128>(2, 49) == 562949953421312);
    assert!(pow::<u128>(2, 50) == 1125899906842624);
    assert!(pow::<u128>(2, 51) == 2251799813685248);
    assert!(pow::<u128>(2, 52) == 4503599627370496);
    assert!(pow::<u128>(2, 53) == 9007199254740992);
    assert!(pow::<u128>(2, 54) == 18014398509481984);
    assert!(pow::<u128>(2, 55) == 36028797018963968);
    assert!(pow::<u128>(2, 56) == 72057594037927936);
    assert!(pow::<u128>(2, 57) == 144115188075855872);
    assert!(pow::<u128>(2, 58) == 288230376151711744);
    assert!(pow::<u128>(2, 59) == 576460752303423488);
    assert!(pow::<u128>(2, 60) == 1152921504606846976);
    assert!(pow::<u128>(2, 61) == 2305843009213693952);
    assert!(pow::<u128>(2, 62) == 4611686018427387904);
    assert!(pow::<u128>(2, 63) == 9223372036854775808);
    assert!(pow::<u128>(2, 64) == 18446744073709551616);
    assert!(pow::<u128>(2, 65) == 36893488147419103232);
    assert!(pow::<u128>(2, 66) == 73786976294838206464);
    assert!(pow::<u128>(2, 67) == 147573952589676412928);
    assert!(pow::<u128>(2, 68) == 295147905179352825856);
    assert!(pow::<u128>(2, 69) == 590295810358705651712);
    assert!(pow::<u128>(2, 70) == 1180591620717411303424);
    assert!(pow::<u128>(2, 71) == 2361183241434822606848);
    assert!(pow::<u128>(2, 72) == 4722366482869645213696);
    assert!(pow::<u128>(2, 73) == 9444732965739290427392);
    assert!(pow::<u128>(2, 74) == 18889465931478580854784);
    assert!(pow::<u128>(2, 75) == 37778931862957161709568);
    assert!(pow::<u128>(2, 76) == 75557863725914323419136);
    assert!(pow::<u128>(2, 77) == 151115727451828646838272);
    assert!(pow::<u128>(2, 78) == 302231454903657293676544);
    assert!(pow::<u128>(2, 79) == 604462909807314587353088);
    assert!(pow::<u128>(2, 80) == 1208925819614629174706176);
    assert!(pow::<u128>(2, 81) == 2417851639229258349412352);
    assert!(pow::<u128>(2, 82) == 4835703278458516698824704);
    assert!(pow::<u128>(2, 83) == 9671406556917033397649408);
    assert!(pow::<u128>(2, 84) == 19342813113834066795298816);
    assert!(pow::<u128>(2, 85) == 38685626227668133590597632);
    assert!(pow::<u128>(2, 86) == 77371252455336267181195264);
    assert!(pow::<u128>(2, 87) == 154742504910672534362390528);
    assert!(pow::<u128>(2, 88) == 309485009821345068724781056);
    assert!(pow::<u128>(2, 89) == 618970019642690137449562112);
    assert!(pow::<u128>(2, 90) == 1237940039285380274899124224);
    assert!(pow::<u128>(2, 91) == 2475880078570760549798248448);
    assert!(pow::<u128>(2, 92) == 4951760157141521099596496896);
    assert!(pow::<u128>(2, 93) == 9903520314283042199192993792);
    assert!(pow::<u128>(2, 94) == 19807040628566084398385987584);
    assert!(pow::<u128>(2, 95) == 39614081257132168796771975168);
    assert!(pow::<u128>(2, 96) == 79228162514264337593543950336);
    assert!(pow::<u128>(2, 97) == 158456325028528675187087900672);
    assert!(pow::<u128>(2, 98) == 316912650057057350374175801344);
    assert!(pow::<u128>(2, 99) == 633825300114114700748351602688);
    assert!(pow::<u128>(2, 100) == 1267650600228229401496703205376);
    assert!(pow::<u128>(2, 101) == 2535301200456458802993406410752);
    assert!(pow::<u128>(2, 102) == 5070602400912917605986812821504);
    assert!(pow::<u128>(2, 103) == 10141204801825835211973625643008);
    assert!(pow::<u128>(2, 104) == 20282409603651670423947251286016);
    assert!(pow::<u128>(2, 105) == 40564819207303340847894502572032);
    assert!(pow::<u128>(2, 106) == 81129638414606681695789005144064);
    assert!(pow::<u128>(2, 107) == 162259276829213363391578010288128);
    assert!(pow::<u128>(2, 108) == 324518553658426726783156020576256);
    assert!(pow::<u128>(2, 109) == 649037107316853453566312041152512);
    assert!(pow::<u128>(2, 110) == 1298074214633706907132624082305024);
    assert!(pow::<u128>(2, 111) == 2596148429267413814265248164610048);
    assert!(pow::<u128>(2, 112) == 5192296858534827628530496329220096);
    assert!(pow::<u128>(2, 113) == 10384593717069655257060992658440192);
    assert!(pow::<u128>(2, 114) == 20769187434139310514121985316880384);
    assert!(pow::<u128>(2, 115) == 41538374868278621028243970633760768);
    assert!(pow::<u128>(2, 116) == 83076749736557242056487941267521536);
    assert!(pow::<u128>(2, 117) == 166153499473114484112975882535043072);
    assert!(pow::<u128>(2, 118) == 332306998946228968225951765070086144);
    assert!(pow::<u128>(2, 119) == 664613997892457936451903530140172288);
    assert!(pow::<u128>(2, 120) == 1329227995784915872903807060280344576);
    assert!(pow::<u128>(2, 121) == 2658455991569831745807614120560689152);
    assert!(pow::<u128>(2, 122) == 5316911983139663491615228241121378304);
    assert!(pow::<u128>(2, 123) == 10633823966279326983230456482242756608);
    assert!(pow::<u128>(2, 124) == 21267647932558653966460912964485513216);
    assert!(pow::<u128>(2, 125) == 42535295865117307932921825928971026432);
    assert!(pow::<u128>(2, 126) == 85070591730234615865843651857942052864);
    assert!(pow::<u128>(2, 127) == 170141183460469231731687303715884105728);
}


#[test]
fn pow_test() {
    assert!(pow::<u128>(200, 0) == 1);
    assert!(pow::<u128>(5, 9) == 1953125);
    assert!(pow::<u128>(14, 30) == 24201432355484595421941037243826176);
    assert!(pow::<u128>(3, 8) == 6561);
    assert!(pow::<u256>(3, 8) == 6561);
}


// Test counting of number of digits function
#[test]
fn count_digits_of_base_test() {
    assert!(count_digits_of_base(0, 10) == 0);
    assert!(count_digits_of_base(2, 10) == 1);
    assert!(count_digits_of_base(10, 10) == 2);
    assert!(count_digits_of_base(100, 10) == 3);
    assert!(count_digits_of_base(0x80, 16) == 2);
    assert!(count_digits_of_base(0x800, 16) == 3);
    assert!(count_digits_of_base(0x888888888888888888, 16) == 18);
}

#[test]
fn shl_should_not_overflow() {
    assert!(BitShift::shl(pow::<u8>(2, 7), 1) == 0);
    assert!(BitShift::shl(pow::<u16>(2, 15), 1) == 0);
    assert!(BitShift::shl(pow::<u32>(2, 31), 1) == 0);
    assert!(BitShift::shl(pow::<u64>(2, 63), 1) == 0);
    assert!(BitShift::shl(pow::<u128>(2, 127), 1) == 0);
    assert!(BitShift::shl(pow::<u256>(2, 255), 1) == 0);
}

#[test]
fn test_rotl_min() {
    assert!(BitRotate::rotate_left(pow::<u8>(2, 7) + 1, 1) == 3);
    assert!(BitRotate::rotate_left(pow::<u16>(2, 15) + 1, 1) == 3);
    assert!(BitRotate::rotate_left(pow::<u32>(2, 31) + 1, 1) == 3);
    assert!(BitRotate::rotate_left(pow::<u64>(2, 63) + 1, 1) == 3);
    assert!(BitRotate::rotate_left(pow::<u128>(2, 127) + 1, 1) == 3);
    assert!(BitRotate::rotate_left(pow::<u256>(2, 255) + 1, 1) == 3);
}

#[test]
fn test_rotl_max() {
    assert!(BitRotate::rotate_left(0b101, 7) == pow::<u8>(2, 7) + 0b10);
    assert!(BitRotate::rotate_left(0b101, 15) == pow::<u16>(2, 15) + 0b10);
    assert!(BitRotate::rotate_left(0b101, 31) == pow::<u32>(2, 31) + 0b10);
    assert!(BitRotate::rotate_left(0b101, 63) == pow::<u64>(2, 63) + 0b10);
    assert!(BitRotate::rotate_left(0b101, 127) == pow::<u128>(2, 127) + 0b10);
    assert!(BitRotate::rotate_left(0b101, 255) == pow::<u256>(2, 255) + 0b10);
}

#[test]
fn test_rotr_min() {
    assert!(BitRotate::rotate_right(pow::<u8>(2, 7) + 1, 1) == 0b11 * pow(2, 6));
    assert!(BitRotate::rotate_right(pow::<u16>(2, 15) + 1, 1) == 0b11 * pow(2, 14));
    assert!(BitRotate::rotate_right(pow::<u32>(2, 31) + 1, 1) == 0b11 * pow(2, 30));
    assert!(BitRotate::rotate_right(pow::<u64>(2, 63) + 1, 1) == 0b11 * pow(2, 62));
    assert!(BitRotate::rotate_right(pow::<u128>(2, 127) + 1, 1) == 0b11 * pow(2, 126));
    assert!(BitRotate::rotate_right(pow::<u256>(2, 255) + 1, 1) == 0b11 * pow(2, 254));
}

#[test]
fn test_rotr_max() {
    assert!(BitRotate::rotate_right(0b101_u8, 7) == 0b1010);
    assert!(BitRotate::rotate_right(0b101_u16, 15) == 0b1010);
    assert!(BitRotate::rotate_right(0b101_u32, 31) == 0b1010);
    assert!(BitRotate::rotate_right(0b101_u64, 63) == 0b1010);
    assert!(BitRotate::rotate_right(0b101_u128, 127) == 0b1010);
    assert!(BitRotate::rotate_right(0b101_u256, 255) == 0b1010);
}

#[test]
fn test_wrapping_math_non_wrapping() {
    assert!(10_u8.wrapping_add(10_u8) == 20_u8);
    assert!(0_u8.wrapping_add(10_u8) == 10_u8);
    assert!(10_u8.wrapping_add(0_u8) == 10_u8);
    assert!(0_u8.wrapping_add(0_u8) == 0_u8);
    assert!(20_u8.wrapping_sub(10_u8) == 10_u8);
    assert!(10_u8.wrapping_sub(0_u8) == 10_u8);
    assert!(0_u8.wrapping_sub(0_u8) == 0_u8);
    assert!(10_u8.wrapping_mul(10_u8) == 100_u8);
    assert!(10_u8.wrapping_mul(0_u8) == 0_u8);
    assert!(0_u8.wrapping_mul(10_u8) == 0_u8);
    assert!(0_u8.wrapping_mul(0_u8) == 0_u8);

    assert!(10_u16.wrapping_add(10_u16) == 20_u16);
    assert!(0_u16.wrapping_add(10_u16) == 10_u16);
    assert!(10_u16.wrapping_add(0_u16) == 10_u16);
    assert!(0_u16.wrapping_add(0_u16) == 0_u16);
    assert!(20_u16.wrapping_sub(10_u16) == 10_u16);
    assert!(10_u16.wrapping_sub(0_u16) == 10_u16);
    assert!(0_u16.wrapping_sub(0_u16) == 0_u16);
    assert!(10_u16.wrapping_mul(10_u16) == 100_u16);
    assert!(10_u16.wrapping_mul(0_u16) == 0_u16);
    assert!(0_u16.wrapping_mul(10_u16) == 0_u16);
    assert!(0_u16.wrapping_mul(0_u16) == 0_u16);

    assert!(10_u32.wrapping_add(10_u32) == 20_u32);
    assert!(0_u32.wrapping_add(10_u32) == 10_u32);
    assert!(10_u32.wrapping_add(0_u32) == 10_u32);
    assert!(0_u32.wrapping_add(0_u32) == 0_u32);
    assert!(20_u32.wrapping_sub(10_u32) == 10_u32);
    assert!(10_u32.wrapping_sub(0_u32) == 10_u32);
    assert!(0_u32.wrapping_sub(0_u32) == 0_u32);
    assert!(10_u32.wrapping_mul(10_u32) == 100_u32);
    assert!(10_u32.wrapping_mul(0_u32) == 0_u32);
    assert!(0_u32.wrapping_mul(10_u32) == 0_u32);
    assert!(0_u32.wrapping_mul(0_u32) == 0_u32);

    assert!(10_u64.wrapping_add(10_u64) == 20_u64);
    assert!(0_u64.wrapping_add(10_u64) == 10_u64);
    assert!(10_u64.wrapping_add(0_u64) == 10_u64);
    assert!(0_u64.wrapping_add(0_u64) == 0_u64);
    assert!(20_u64.wrapping_sub(10_u64) == 10_u64);
    assert!(10_u64.wrapping_sub(0_u64) == 10_u64);
    assert!(0_u64.wrapping_sub(0_u64) == 0_u64);
    assert!(10_u64.wrapping_mul(10_u64) == 100_u64);
    assert!(10_u64.wrapping_mul(0_u64) == 0_u64);
    assert!(0_u64.wrapping_mul(10_u64) == 0_u64);
    assert!(0_u64.wrapping_mul(0_u64) == 0_u64);

    assert!(10_u128.wrapping_add(10_u128) == 20_u128);
    assert!(0_u128.wrapping_add(10_u128) == 10_u128);
    assert!(10_u128.wrapping_add(0_u128) == 10_u128);
    assert!(0_u128.wrapping_add(0_u128) == 0_u128);
    assert!(20_u128.wrapping_sub(10_u128) == 10_u128);
    assert!(10_u128.wrapping_sub(0_u128) == 10_u128);
    assert!(0_u128.wrapping_sub(0_u128) == 0_u128);
    assert!(10_u128.wrapping_mul(10_u128) == 100_u128);
    assert!(10_u128.wrapping_mul(0_u128) == 0_u128);
    assert!(0_u128.wrapping_mul(10_u128) == 0_u128);
    assert!(0_u128.wrapping_mul(0_u128) == 0_u128);

    assert!(10_u256.wrapping_add(10_u256) == 20_u256);
    assert!(0_u256.wrapping_add(10_u256) == 10_u256);
    assert!(10_u256.wrapping_add(0_u256) == 10_u256);
    assert!(0_u256.wrapping_add(0_u256) == 0_u256);
    assert!(20_u256.wrapping_sub(10_u256) == 10_u256);
    assert!(10_u256.wrapping_sub(0_u256) == 10_u256);
    assert!(0_u256.wrapping_sub(0_u256) == 0_u256);
    assert!(10_u256.wrapping_mul(10_u256) == 100_u256);
    assert!(10_u256.wrapping_mul(0_u256) == 0_u256);
    assert!(0_u256.wrapping_mul(10_u256) == 0_u256);
    assert!(0_u256.wrapping_mul(0_u256) == 0_u256);
}

#[test]
fn test_wrapping_math_wrapping() {
    assert!(Bounded::<u8>::MAX.wrapping_add(1_u8) == 0_u8);
    assert!(1_u8.wrapping_add(Bounded::<u8>::MAX) == 0_u8);
    assert!(Bounded::<u8>::MAX.wrapping_add(2_u8) == 1_u8);
    assert!(2_u8.wrapping_add(Bounded::<u8>::MAX) == 1_u8);
    assert!(Bounded::<u8>::MAX.wrapping_add(Bounded::<u8>::MAX) == Bounded::<u8>::MAX - 1_u8);
    assert!(Bounded::<u8>::MIN.wrapping_sub(1_u8) == Bounded::<u8>::MAX);
    assert!(Bounded::<u8>::MIN.wrapping_sub(2_u8) == Bounded::<u8>::MAX - 1_u8);
    assert!(1_u8.wrapping_sub(Bounded::<u8>::MAX) == 2_u8);
    assert!(0_u8.wrapping_sub(Bounded::<u8>::MAX) == 1_u8);
    assert!(Bounded::<u8>::MAX.wrapping_mul(Bounded::<u8>::MAX) == 1_u8);
    assert!((Bounded::<u8>::MAX - 1_u8).wrapping_mul(2_u8) == Bounded::<u8>::MAX - 3_u8);

    assert!(Bounded::<u16>::MAX.wrapping_add(1_u16) == 0_u16);
    assert!(1_u16.wrapping_add(Bounded::<u16>::MAX) == 0_u16);
    assert!(Bounded::<u16>::MAX.wrapping_add(2_u16) == 1_u16);
    assert!(2_u16.wrapping_add(Bounded::<u16>::MAX) == 1_u16);
    assert!(Bounded::<u16>::MAX.wrapping_add(Bounded::<u16>::MAX) == Bounded::<u16>::MAX - 1_u16);
    assert!(Bounded::<u16>::MIN.wrapping_sub(1_u16) == Bounded::<u16>::MAX);
    assert!(Bounded::<u16>::MIN.wrapping_sub(2_u16) == Bounded::<u16>::MAX - 1_u16);
    assert!(1_u16.wrapping_sub(Bounded::<u16>::MAX) == 2_u16);
    assert!(0_u16.wrapping_sub(Bounded::<u16>::MAX) == 1_u16);
    assert!(Bounded::<u16>::MAX.wrapping_mul(Bounded::<u16>::MAX) == 1_u16);
    assert!((Bounded::<u16>::MAX - 1_u16).wrapping_mul(2_u16) == Bounded::<u16>::MAX - 3_u16);

    assert!(Bounded::<u32>::MAX.wrapping_add(1_u32) == 0_u32);
    assert!(1_u32.wrapping_add(Bounded::<u32>::MAX) == 0_u32);
    assert!(Bounded::<u32>::MAX.wrapping_add(2_u32) == 1_u32);
    assert!(2_u32.wrapping_add(Bounded::<u32>::MAX) == 1_u32);
    assert!(Bounded::<u32>::MAX.wrapping_add(Bounded::<u32>::MAX) == Bounded::<u32>::MAX - 1_u32);
    assert!(Bounded::<u32>::MIN.wrapping_sub(1_u32) == Bounded::<u32>::MAX);
    assert!(Bounded::<u32>::MIN.wrapping_sub(2_u32) == Bounded::<u32>::MAX - 1_u32);
    assert!(1_u32.wrapping_sub(Bounded::<u32>::MAX) == 2_u32);
    assert!(0_u32.wrapping_sub(Bounded::<u32>::MAX) == 1_u32);
    assert!(Bounded::<u32>::MAX.wrapping_mul(Bounded::<u32>::MAX) == 1_u32);
    assert!((Bounded::<u32>::MAX - 1_u32).wrapping_mul(2_u32) == Bounded::<u32>::MAX - 3_u32);

    assert!(Bounded::<u64>::MAX.wrapping_add(1_u64) == 0_u64);
    assert!(1_u64.wrapping_add(Bounded::<u64>::MAX) == 0_u64);
    assert!(Bounded::<u64>::MAX.wrapping_add(2_u64) == 1_u64);
    assert!(2_u64.wrapping_add(Bounded::<u64>::MAX) == 1_u64);
    assert!(Bounded::<u64>::MAX.wrapping_add(Bounded::<u64>::MAX) == Bounded::<u64>::MAX - 1_u64);
    assert!(Bounded::<u64>::MIN.wrapping_sub(1_u64) == Bounded::<u64>::MAX);
    assert!(Bounded::<u64>::MIN.wrapping_sub(2_u64) == Bounded::<u64>::MAX - 1_u64);
    assert!(1_u64.wrapping_sub(Bounded::<u64>::MAX) == 2_u64);
    assert!(0_u64.wrapping_sub(Bounded::<u64>::MAX) == 1_u64);
    assert!(Bounded::<u64>::MAX.wrapping_mul(Bounded::<u64>::MAX) == 1_u64);
    assert!((Bounded::<u64>::MAX - 1_u64).wrapping_mul(2_u64) == Bounded::<u64>::MAX - 3_u64);

    assert!(Bounded::<u128>::MAX.wrapping_add(1_u128) == 0_u128);
    assert!(1_u128.wrapping_add(Bounded::<u128>::MAX) == 0_u128);
    assert!(Bounded::<u128>::MAX.wrapping_add(2_u128) == 1_u128);
    assert!(2_u128.wrapping_add(Bounded::<u128>::MAX) == 1_u128);
    assert!(
        Bounded::<u128>::MAX.wrapping_add(Bounded::<u128>::MAX) == Bounded::<u128>::MAX - 1_u128,
    );
    assert!(Bounded::<u128>::MIN.wrapping_sub(1_u128) == Bounded::<u128>::MAX);
    assert!(Bounded::<u128>::MIN.wrapping_sub(2_u128) == Bounded::<u128>::MAX - 1_u128);
    assert!(1_u128.wrapping_sub(Bounded::<u128>::MAX) == 2_u128);
    assert!(0_u128.wrapping_sub(Bounded::<u128>::MAX) == 1_u128);
    assert!(Bounded::<u128>::MAX.wrapping_mul(Bounded::<u128>::MAX) == 1_u128);
    assert!((Bounded::<u128>::MAX - 1_u128).wrapping_mul(2_u128) == Bounded::<u128>::MAX - 3_u128);

    assert!(Bounded::<u256>::MAX.wrapping_add(1_u256) == 0_u256);
    assert!(1_u256.wrapping_add(Bounded::<u256>::MAX) == 0_u256);
    assert!(Bounded::<u256>::MAX.wrapping_add(2_u256) == 1_u256);
    assert!(2_u256.wrapping_add(Bounded::<u256>::MAX) == 1_u256);
    assert!(
        Bounded::<u256>::MAX.wrapping_add(Bounded::<u256>::MAX) == Bounded::<u256>::MAX - 1_u256,
    );
    assert!(Bounded::<u256>::MIN.wrapping_sub(1_u256) == Bounded::<u256>::MAX);
    assert!(Bounded::<u256>::MIN.wrapping_sub(2_u256) == Bounded::<u256>::MAX - 1_u256);
    assert!(1_u256.wrapping_sub(Bounded::<u256>::MAX) == 2_u256);
    assert!(0_u256.wrapping_sub(Bounded::<u256>::MAX) == 1_u256);
    assert!(Bounded::<u256>::MAX.wrapping_mul(Bounded::<u256>::MAX) == 1_u256);
    assert!((Bounded::<u256>::MAX - 1_u256).wrapping_mul(2_u256) == Bounded::<u256>::MAX - 3_u256);
}
