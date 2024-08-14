use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_data_structures::array_ext::ArrayTraitExt;
use core::fmt::{Debug, Display, Formatter, Error};
use core::integer::u128_byte_reverse;
use core::keccak::cairo_keccak;
use core::to_byte_array::{AppendFormattedToByteArray, FormatAsByteArray};

fn format_byte_hex(byte: u8, ref f: Formatter) -> Result<(), Error> {
    let base: NonZero<u8> = 16_u8.try_into().unwrap();
    if byte < 0x10 {
        // Add leading zero for single digit numbers
        let zero: ByteArray = "0";
        Display::fmt(@zero, ref f)?;
    }
    Display::fmt(@byte.format_as_byte_array(base), ref f)
}

pub impl BytesDebug of Debug<Bytes> {
    fn fmt(self: @Bytes, ref f: Formatter) -> Result<(), Error> {
        let mut i: usize = 0;
        let prefix: ByteArray = "0x";
        Display::fmt(@prefix, ref f)?;
        let mut res: Result<(), Error> = Result::Ok(());
        while i < self.size() {
            let (new_i, value) = self.read_u8(i);
            res = format_byte_hex(value, ref f);
            if res.is_err() {
                break;
            }
            i = new_i;
        };
        res
    }
}

pub impl BytesDisplay of Display<Bytes> {
    fn fmt(self: @Bytes, ref f: Formatter) -> Result<(), Error> {
        let mut i: usize = 0;
        let prefix: ByteArray = "0x";
        Display::fmt(@prefix, ref f)?;
        let mut res: Result<(), Error> = Result::Ok(());
        while i < self.size() {
            let (new_i, value) = self.read_u8(i);
            res = format_byte_hex(value, ref f);
            if res.is_err() {
                break;
            }
            i = new_i;
        };
        res
    }
}

/// Computes the keccak256 of multiple uint128 values.
/// The values are interpreted as big-endian.
/// https://github.com/starkware-libs/cairo/blob/main/corelib/src/keccak.cairo
pub fn keccak_u128s_be(input: Span<u128>, n_bytes: usize) -> u256 {
    let mut keccak_input = array![];
    let mut size = n_bytes;
    for v in input {
        let value_size = core::cmp::min(size, 16);
        keccak_add_uint128_be(ref keccak_input, *v, value_size);
        size -= value_size;
    };

    let aligned = n_bytes % 8 == 0;
    if aligned {
        u256_reverse_endian(cairo_keccak(ref keccak_input, 0, 0))
    } else {
        let last_input_num_bytes = n_bytes % 8;
        let last_input_word = *keccak_input[keccak_input.len() - 1];
        let mut inputs = u64_array_slice(@keccak_input, 0, keccak_input.len() - 1);
        u256_reverse_endian(cairo_keccak(ref inputs, last_input_word, last_input_num_bytes))
    }
}

fn u256_reverse_endian(input: u256) -> u256 {
    let low = u128_byte_reverse(input.high);
    let high = u128_byte_reverse(input.low);
    u256 { low, high }
}

fn keccak_add_uint128_be(ref keccak_input: Array::<u64>, value: u128, value_size: usize) {
    if value_size == 16 {
        let (high, low) = core::integer::u128_safe_divmod(
            u128_byte_reverse(value), 0x10000000000000000_u128.try_into().unwrap()
        );
        keccak_input.append(low.try_into().unwrap());
        keccak_input.append(high.try_into().unwrap());
    } else {
        let reversed_value = u128_byte_reverse(value);
        let (reversed_value, _) = u128_split(reversed_value, 16, value_size);
        if value_size <= 8 {
            keccak_input.append(reversed_value.try_into().unwrap());
        } else {
            let (high, low) = DivRem::div_rem(
                reversed_value, u128_fast_pow2(64).try_into().expect('Division by 0')
            );
            keccak_input.append(low.try_into().unwrap());
            keccak_input.append(high.try_into().unwrap());
        }
    }
}

fn update_u256_array_at(arr: @Array<u256>, index: usize, value: u256) -> Array<u256> {
    assert(index < arr.len(), 'index out of range');
    let mut new_arr = array![];
    let mut i = 0;

    while i != arr.len() {
        if i == index {
            new_arr.append(value);
        } else {
            new_arr.append(*arr[i]);
        }
        i += 1;
    };
    new_arr
}

/// Convert sha256 result(Array<u8>) to u256
/// result length MUST be 32
pub fn u8_array_to_u256(arr: Span<u8>) -> u256 {
    assert(arr.len() == 32, 'too large');
    let mut i = 0;
    let mut high = 0;
    let mut low = 0;
    // process high
    while i < arr.len() && i != 16 {
        high = u128_join(high, (*arr[i]).into(), 1);
        i += 1;
    };
    // process low
    while i < arr.len() && i != 32 {
        low = u128_join(low, (*arr[i]).into(), 1);
        i += 1;
    };

    u256 { low, high }
}

pub fn u32s_to_u256(arr: Span<u32>) -> u256 {
    assert!(arr.len() == 8, "u32s_to_u2562: input must be 8 elements long");
    let low: u128 = (*arr[7]).into()
        + (*arr[6]).into() * 0x1_0000_0000
        + (*arr[5]).into() * 0x1_0000_0000_0000_0000
        + (*arr[4]).into() * 0x1_0000_0000_0000_0000_0000_0000;
    let low = low.try_into().expect('u32s_to_u2562:overflow-low');
    let high = (*arr[3]).into()
        + (*arr[2]).into() * 0x1_0000_0000
        + (*arr[1]).into() * 0x1_0000_0000_0000_0000
        + (*arr[0]).into() * 0x1_0000_0000_0000_0000_0000_0000;
    let high = high.try_into().expect('u32s_to_u2562:overflow-high');
    u256 { high, low }
}

fn u64_array_slice(src: @Array<u64>, mut begin: usize, len: usize) -> Array<u64> {
    let mut slice = array![];
    let end = begin + len;
    while begin < end && begin < src.len() {
        slice.append(*src[begin]);
        begin += 1;
    };
    slice
}

/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `len` - The length of the slice.
/// # Returns
/// * `Array<u128>` - The slice of the array.
pub fn u128_array_slice(src: @Array<u128>, mut begin: usize, len: usize) -> Array<u128> {
    let mut slice = array![];
    let end = begin + len;
    while begin < end && begin < src.len() {
        slice.append(*src[begin]);
        begin += 1;
    };
    slice
}

fn array_slice<T, +Drop<T>, +Copy<T>>(src: @Array<T>, mut begin: usize, len: usize) -> Array<T> {
    let mut slice = array![];
    let end = begin + len;
    while begin < end && begin < src.len() {
        slice.append(*src[begin]);
        begin += 1;
    };
    slice
}

/// Split a u128 into two parts, [0, left_size-1] and [left_size, end]
/// Parameters:
///  - value: data of u128
///  - value_size: the size of `value` in bytes
///  - left_size: the size of left part in bytes
/// Returns:
///  - letf: [0, left_size-1] of the origin u128
///  - right: [left_size, end] of the origin u128 which size is (value_size - left_size)
/// Examples:
/// u128_split(0x01020304, 4, 0) -> (0, 0x01020304)
/// u128_split(0x01020304, 4, 1) -> (0x01, 0x020304)
/// u128_split(0x0001020304, 5, 1) -> (0x00, 0x01020304)
pub fn u128_split(value: u128, value_size: usize, left_size: usize) -> (u128, u128) {
    assert(value_size <= 16, 'value_size can not be gt 16');
    assert(left_size <= value_size, 'size can not be gt value_size');

    if left_size == 0 {
        (0, value)
    } else {
        let power = u128_fast_pow2((value_size - left_size) * 8);
        DivRem::div_rem(value, power.try_into().expect('Division by 0'))
    }
}

/// Read sub value from u128 just like substr in other language
/// Parameters:
///  - value: data of u128
///  - value_size: the size of data in bytes
///  - offset: the offset of sub value
///  - size: the size of sub value in bytes
/// Returns:
///  - sub_value: the sub value of origin u128
/// Examples:
/// u128_sub_value(0x000001020304, 6, 1, 3) -> 0x000102
pub fn read_sub_u128(value: u128, value_size: usize, offset: usize, size: usize) -> u128 {
    assert(offset + size <= value_size, 'too long');

    if (value_size == 0) || (size == 0) {
        return 0;
    }

    if size == value_size {
        return value;
    }

    let (_, right) = u128_split(value, value_size, offset);
    let (sub_value, _) = u128_split(right, value_size - offset, size);
    sub_value
}

/// Join two u128 into one
/// Parameters:
///  - left: the left part of u128
///  - right: the right part of u128
///  - right_size: the size of right part in bytes
/// Returns:
///  - value: the joined u128
/// Examples:
/// u128_join(0x010203, 0xaabb, 2) -> 0x010203aabb
/// u128_join(0x010203, 0, 2) -> 0x0102030000
pub fn u128_join(left: u128, right: u128, right_size: usize) -> u128 {
    let left_size = u128_bytes_len(left);
    assert(left_size + right_size <= 16, 'left shift overflow');
    let shift = u128_fast_pow2(right_size * 8);
    left * shift + right
}

/// Return the bytes len represent in u128
/// Examples:
/// u128_bytes_len(0x0102) -> 2
fn u128_bytes_len(value: u128) -> usize {
    if value <= 0xff_u128 {
        1_usize
    } else if value <= 0xffff_u128 {
        2_usize
    } else if value <= 0xffffff_u128 {
        3_usize
    } else if value <= 0xffffffff_u128 {
        4_usize
    } else if value <= 0xffffffffff_u128 {
        5_usize
    } else if value <= 0xffffffffffff_u128 {
        6_usize
    } else if value <= 0xffffffffffffff_u128 {
        7_usize
    } else if value <= 0xffffffffffffffff_u128 {
        8_usize
    } else if value <= 0xffffffffffffffffff_u128 {
        9_usize
    } else if value <= 0xffffffffffffffffffff_u128 {
        10_usize
    } else if value <= 0xffffffffffffffffffffff_u128 {
        11_usize
    } else if value <= 0xffffffffffffffffffffffff_u128 {
        12_usize
    } else if value <= 0xffffffffffffffffffffffffff_u128 {
        13_usize
    } else if value <= 0xffffffffffffffffffffffffffff_u128 {
        14_usize
    } else if value <= 0xffffffffffffffffffffffffffffff_u128 {
        15_usize
    } else {
        16_usize
    }
}

/// return 2^exp where exp in [0, 127]
fn u128_fast_pow2(exp: usize) -> u128 {
    assert(exp <= 127, 'invalid exp');

    if exp == 0_usize {
        1_u128
    } else if exp == 1_usize {
        2_u128
    } else if exp == 2_usize {
        4_u128
    } else if exp == 3_usize {
        8_u128
    } else if exp == 4_usize {
        16_u128
    } else if exp == 5_usize {
        32_u128
    } else if exp == 6_usize {
        64_u128
    } else if exp == 7_usize {
        128_u128
    } else if exp == 8_usize {
        256_u128
    } else if exp == 9_usize {
        512_u128
    } else if exp == 10_usize {
        1024_u128
    } else if exp == 11_usize {
        2048_u128
    } else if exp == 12_usize {
        4096_u128
    } else if exp == 13_usize {
        8192_u128
    } else if exp == 14_usize {
        16384_u128
    } else if exp == 15_usize {
        32768_u128
    } else if exp == 16_usize {
        65536_u128
    } else if exp == 17_usize {
        131072_u128
    } else if exp == 18_usize {
        262144_u128
    } else if exp == 19_usize {
        524288_u128
    } else if exp == 20_usize {
        1048576_u128
    } else if exp == 21_usize {
        2097152_u128
    } else if exp == 22_usize {
        4194304_u128
    } else if exp == 23_usize {
        8388608_u128
    } else if exp == 24_usize {
        16777216_u128
    } else if exp == 25_usize {
        33554432_u128
    } else if exp == 26_usize {
        67108864_u128
    } else if exp == 27_usize {
        134217728_u128
    } else if exp == 28_usize {
        268435456_u128
    } else if exp == 29_usize {
        536870912_u128
    } else if exp == 30_usize {
        1073741824_u128
    } else if exp == 31_usize {
        2147483648_u128
    } else if exp == 32_usize {
        4294967296_u128
    } else if exp == 33_usize {
        8589934592_u128
    } else if exp == 34_usize {
        17179869184_u128
    } else if exp == 35_usize {
        34359738368_u128
    } else if exp == 36_usize {
        68719476736_u128
    } else if exp == 37_usize {
        137438953472_u128
    } else if exp == 38_usize {
        274877906944_u128
    } else if exp == 39_usize {
        549755813888_u128
    } else if exp == 40_usize {
        1099511627776_u128
    } else if exp == 41_usize {
        2199023255552_u128
    } else if exp == 42_usize {
        4398046511104_u128
    } else if exp == 43_usize {
        8796093022208_u128
    } else if exp == 44_usize {
        17592186044416_u128
    } else if exp == 45_usize {
        35184372088832_u128
    } else if exp == 46_usize {
        70368744177664_u128
    } else if exp == 47_usize {
        140737488355328_u128
    } else if exp == 48_usize {
        281474976710656_u128
    } else if exp == 49_usize {
        562949953421312_u128
    } else if exp == 50_usize {
        1125899906842624_u128
    } else if exp == 51_usize {
        2251799813685248_u128
    } else if exp == 52_usize {
        4503599627370496_u128
    } else if exp == 53_usize {
        9007199254740992_u128
    } else if exp == 54_usize {
        18014398509481984_u128
    } else if exp == 55_usize {
        36028797018963968_u128
    } else if exp == 56_usize {
        72057594037927936_u128
    } else if exp == 57_usize {
        144115188075855872_u128
    } else if exp == 58_usize {
        288230376151711744_u128
    } else if exp == 59_usize {
        576460752303423488_u128
    } else if exp == 60_usize {
        1152921504606846976_u128
    } else if exp == 61_usize {
        2305843009213693952_u128
    } else if exp == 62_usize {
        4611686018427387904_u128
    } else if exp == 63_usize {
        9223372036854775808_u128
    } else if exp == 64_usize {
        18446744073709551616_u128
    } else if exp == 65_usize {
        36893488147419103232_u128
    } else if exp == 66_usize {
        73786976294838206464_u128
    } else if exp == 67_usize {
        147573952589676412928_u128
    } else if exp == 68_usize {
        295147905179352825856_u128
    } else if exp == 69_usize {
        590295810358705651712_u128
    } else if exp == 70_usize {
        1180591620717411303424_u128
    } else if exp == 71_usize {
        2361183241434822606848_u128
    } else if exp == 72_usize {
        4722366482869645213696_u128
    } else if exp == 73_usize {
        9444732965739290427392_u128
    } else if exp == 74_usize {
        18889465931478580854784_u128
    } else if exp == 75_usize {
        37778931862957161709568_u128
    } else if exp == 76_usize {
        75557863725914323419136_u128
    } else if exp == 77_usize {
        151115727451828646838272_u128
    } else if exp == 78_usize {
        302231454903657293676544_u128
    } else if exp == 79_usize {
        604462909807314587353088_u128
    } else if exp == 80_usize {
        1208925819614629174706176_u128
    } else if exp == 81_usize {
        2417851639229258349412352_u128
    } else if exp == 82_usize {
        4835703278458516698824704_u128
    } else if exp == 83_usize {
        9671406556917033397649408_u128
    } else if exp == 84_usize {
        19342813113834066795298816_u128
    } else if exp == 85_usize {
        38685626227668133590597632_u128
    } else if exp == 86_usize {
        77371252455336267181195264_u128
    } else if exp == 87_usize {
        154742504910672534362390528_u128
    } else if exp == 88_usize {
        309485009821345068724781056_u128
    } else if exp == 89_usize {
        618970019642690137449562112_u128
    } else if exp == 90_usize {
        1237940039285380274899124224_u128
    } else if exp == 91_usize {
        2475880078570760549798248448_u128
    } else if exp == 92_usize {
        4951760157141521099596496896_u128
    } else if exp == 93_usize {
        9903520314283042199192993792_u128
    } else if exp == 94_usize {
        19807040628566084398385987584_u128
    } else if exp == 95_usize {
        39614081257132168796771975168_u128
    } else if exp == 96_usize {
        79228162514264337593543950336_u128
    } else if exp == 97_usize {
        158456325028528675187087900672_u128
    } else if exp == 98_usize {
        316912650057057350374175801344_u128
    } else if exp == 99_usize {
        633825300114114700748351602688_u128
    } else if exp == 100_usize {
        1267650600228229401496703205376_u128
    } else if exp == 101_usize {
        2535301200456458802993406410752_u128
    } else if exp == 102_usize {
        5070602400912917605986812821504_u128
    } else if exp == 103_usize {
        10141204801825835211973625643008_u128
    } else if exp == 104_usize {
        20282409603651670423947251286016_u128
    } else if exp == 105_usize {
        40564819207303340847894502572032_u128
    } else if exp == 106_usize {
        81129638414606681695789005144064_u128
    } else if exp == 107_usize {
        162259276829213363391578010288128_u128
    } else if exp == 108_usize {
        324518553658426726783156020576256_u128
    } else if exp == 109_usize {
        649037107316853453566312041152512_u128
    } else if exp == 110_usize {
        1298074214633706907132624082305024_u128
    } else if exp == 111_usize {
        2596148429267413814265248164610048_u128
    } else if exp == 112_usize {
        5192296858534827628530496329220096_u128
    } else if exp == 113_usize {
        10384593717069655257060992658440192_u128
    } else if exp == 114_usize {
        20769187434139310514121985316880384_u128
    } else if exp == 115_usize {
        41538374868278621028243970633760768_u128
    } else if exp == 116_usize {
        83076749736557242056487941267521536_u128
    } else if exp == 117_usize {
        166153499473114484112975882535043072_u128
    } else if exp == 118_usize {
        332306998946228968225951765070086144_u128
    } else if exp == 119_usize {
        664613997892457936451903530140172288_u128
    } else if exp == 120_usize {
        1329227995784915872903807060280344576_u128
    } else if exp == 121_usize {
        2658455991569831745807614120560689152_u128
    } else if exp == 122_usize {
        5316911983139663491615228241121378304_u128
    } else if exp == 123_usize {
        10633823966279326983230456482242756608_u128
    } else if exp == 124_usize {
        21267647932558653966460912964485513216_u128
    } else if exp == 125_usize {
        42535295865117307932921825928971026432_u128
    } else if exp == 126_usize {
        85070591730234615865843651857942052864_u128
    } else {
        170141183460469231731687303715884105728_u128
    }
}
