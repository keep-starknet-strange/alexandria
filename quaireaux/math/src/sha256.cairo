use option::OptionTrait;
use array::ArrayTrait;
use debug::PrintTrait;
use integer::u32_wrapping_add;
use integer::U128BitAnd;
use integer::U128BitOr;
use integer::U128BitXor;
use traits::Div;
use traits::Into;
use traits::TryInto;
use quaireaux_utils::check_gas;

const U32_MAX: u128 = 0xFFFFFFFF;
const U64_MAX: u128 = 0xFFFFFFFFFFFFFFFF;

fn u32pow(x: u32, n: u32) -> u32 {
    quaireaux_utils::check_gas();
    let n: felt252 = n.into();
    let n: u128 = n.try_into().unwrap();

    if (n & 1) == 1 {
        let n: felt252 = n.into();
        let n: u32 = n.try_into().unwrap();
        if n / 2 == 0 {
            return 1;
        } else {
            return x * u32pow(x * x, n / 2);
        }
    }
    else {
        let n: felt252 = n.into();
        let n: u32 = n.try_into().unwrap();
        if n / 2 == 0 {
            return 1;
        } else {
            return u32pow(x * x, n / 2);
        }
    }
}

fn u64pow(x: u64, n: u64) -> u64 {
    quaireaux_utils::check_gas();
    let n: felt252 = n.into();
    let n: u128 = n.try_into().unwrap();

    if (n & 1) == 1 {
        let n: felt252 = n.into();
        let n: u128 = n.try_into().unwrap();
        let n = n & U64_MAX;
        let n: u64 = n.try_into().unwrap();
        if n / 2 == 0 {
            return 1;
        } else {
            return x * u64pow(x * x, n / 2);
        }
    }
    else {
        let n: felt252 = n.into();
        let n: u128 = n.try_into().unwrap();
        let n = n & U64_MAX;
        let n: u64 = n.try_into().unwrap();
        if n / 2 == 0 {
            return 1;
        } else {
            return u64pow(x * x, n / 2);
        }
    }
}

fn shl(x: u32, n: u32) -> u32 {
    let x: felt252 = x.into();
    let y: felt252 = u32pow(2, n).into();
    let x = x * y;
    let x: u128 = x.try_into().unwrap();
    let x = x & U32_MAX;
    let x: felt252 = x.into();
    return x.try_into().unwrap();
}

fn u32shr(x: u32, n: u32) -> u32 {
    return x / u32pow(2, n);
}

fn u64shr(x: u64, n: u64) -> u64 {
    return x / u64pow(2, n);
}

fn rotl(x: u32, n: u32) -> u32 {
    let x1: felt252 = shl(x, n).into();
    let x1: u128 = x1.try_into().unwrap();
    let x2: felt252 = u32shr(x, 32 - n).into();
    let x2: u128 = x2.try_into().unwrap();
    let result = x1 | x2;
    let result: felt252 = result.into();
    return result.try_into().unwrap();
}

fn rotr(x: u32, n: u32) -> u32 {
    let x1: felt252 = u32shr(x, n).into();
    let x1: u128 = x1.try_into().unwrap();
    let x2: felt252 = shl(x, 32 - n).into();
    let x2: u128 = x2.try_into().unwrap();
    let result = x1 | x2;
    let result: felt252 = result.into();
    return result.try_into().unwrap();
}

fn ch(x: u32, y: u32, z: u32) -> u32 {
    // x ^ U32_MAX is a bitwise NOT
    let x: felt252 = x.into();
    let x: u128 = x.try_into().unwrap();
    let y: felt252 = y.into();
    let y: u128 = y.try_into().unwrap();
    let z: felt252 = z.into();
    let z: u128 = z.try_into().unwrap();
    let result = (x & y) ^ ((x ^ U32_MAX) & z);
    let result: u64 = result.try_into().unwrap();
    return result.try_into().unwrap();
}

fn maj(x: u32, y: u32, z: u32) -> u32 {
    let x: felt252 = x.into();
    let x: u128 = x.try_into().unwrap();

    let y: felt252 = y.into();
    let y: u128 = y.try_into().unwrap();

    let z: felt252 = z.into();
    let z: u128 = z.try_into().unwrap();

    let result = (x & y) ^ (x & z) ^ (y & z);
    let result: u64 = result.try_into().unwrap();
    return result.try_into().unwrap();
}

fn bsig0(x: u32) -> u32 {
    // x.rotate_right(2) ^ x.rotate_right(13) ^ x.rotate_right(22)
    let x1: felt252 = rotr(x, 2).into();
    let x1: u128 = x1.try_into().unwrap();

    let x2: felt252 = rotr(x, 13).into();
    let x2: u128 = x2.try_into().unwrap();

    let x3: felt252 = rotr(x, 22).into();
    let x3: u128 = x3.try_into().unwrap();

    let result = x1 ^ x2 ^ x3;
    let result: u64 = result.try_into().unwrap();
    return result.try_into().unwrap();
}

fn bsig1(x: u32) -> u32 {
    // x.rotate_right(6) ^ x.rotate_right(11) ^ x.rotate_right(25)
    let x1: felt252 = rotr(x, 6).into();
    let x1: u128 = x1.try_into().unwrap();

    let x2: felt252 = rotr(x, 11).into();
    let x2: u128 = x2.try_into().unwrap();

    let x3: felt252 = rotr(x, 25).into();
    let x3: u128 = x3.try_into().unwrap();

    let result = x1 ^ x2 ^ x3;
    let result: u64 = result.try_into().unwrap();
    return result.try_into().unwrap();
}

fn ssig0(x: u32) -> u32 {
    // x.rotate_right(7) ^ x.rotate_right(18) ^ (x >> 3)
    let x1: felt252 = rotr(x, 7).into();
    let x1: u128 = x1.try_into().unwrap();

    let x2: felt252 = rotr(x, 18).into();
    let x2: u128 = x2.try_into().unwrap();

    let x3: felt252 = u32shr(x, 3).into();
    let x3: u128 = x3.try_into().unwrap();

    let result = x1 ^ x2 ^ x3;
    let result: u64 = result.try_into().unwrap();
    return result.try_into().unwrap();
}

fn ssig1(x: u32) -> u32 {
    // x.rotate_right(17) ^ x.rotate_right(19) ^ (x >> 10)
    let x1: felt252 = rotr(x, 17).into();
    let x1: u128 = x1.try_into().unwrap();

    let x2: felt252 = rotr(x, 19).into();
    let x2: u128 = x2.try_into().unwrap();

    let x3: felt252 = u32shr(x, 10).into();
    let x3: u128 = x3.try_into().unwrap();

    let result = x1 ^ x2 ^ x3;
    let result: u64 = result.try_into().unwrap();
    return result.try_into().unwrap();
}


fn sha256(mut data: Array<u8>) -> Array<u8> {
    let u64_data_length: felt252 = (data.len() * 8).into();
    let u64_data_length: u128 = u64_data_length.try_into().unwrap();
    let u64_data_length = u64_data_length & U64_MAX;
    let u64_data_length: u64 = u64_data_length.try_into().unwrap();

    // add one
    data.append(0x80);

    add_padding(ref data);

    // add length to the end
    let result: felt252 = u64shr(u64_data_length, 56).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result: felt252 = u64shr(u64_data_length, 48).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result: felt252 = u64shr(u64_data_length, 40).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result: felt252 = u64shr(u64_data_length, 32).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result: felt252 = u64shr(u64_data_length, 24).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result: felt252 = u64shr(u64_data_length, 16).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result: felt252 = u64shr(u64_data_length, 8).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result: felt252 = u64shr(u64_data_length, 0).into();
    let result: u128 = result.try_into().unwrap();
    let result: u128 = result & 0xFF;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let u32_data_length = 16 * ((data.len() - 1) / 64 + 1);
    let mut data = from_u8vec_to_u32vec(ref data, u32_data_length);

    let mut h = get_h();
    let mut k = get_k();
    sha256_inner(ref data, 0, ref k, ref h);

    let result = from_u32vec_to_u8vec(ref h, 8);
    return result;
}

fn from_u32vec_to_u8vec(ref data: Array<u32>, i: usize) -> Array<u8> {
    quaireaux_utils::check_gas();
    if i <= 0 {
        return ArrayTrait::new();
    } else {
        let mut result = from_u32vec_to_u8vec(ref data, i - 1);

        let x: felt252 = u32shr(*data[i - 1], 24).into();
        let x: u128 = x.try_into().unwrap();
        let x: u128 = x & 0xFF;
        let x: felt252 = x.into();
        let x: u8 = x.try_into().unwrap();
        result.append(x);

        let x: felt252 = u32shr(*data[i - 1], 16).into();
        let x: u128 = x.try_into().unwrap();
        let x: u128 = x & 0xFF;
        let x: felt252 = x.into();
        let x: u8 = x.try_into().unwrap();
        result.append(x);

        let x: felt252 = u32shr(*data[i - 1], 8).into();
        let x: u128 = x.try_into().unwrap();
        let x: u128 = x & 0xFF;
        let x: felt252 = x.into();
        let x: u8 = x.try_into().unwrap();
        result.append(x);

        let x: felt252 = u32shr(*data[i - 1], 0).into();
        let x: u128 = x.try_into().unwrap();
        let x: u128 = x & 0xFF;
        let x: felt252 = x.into();
        let x: u8 = x.try_into().unwrap();
        result.append(x);

        return result;
    }
}

fn copy_array(ref from: Array<u32>, i: usize) -> Array<u32> {
    quaireaux_utils::check_gas();
    if i > 0 {
        let mut result = copy_array(ref from, i - 1);
        result.append(*from[i - 1]);
        return result;
    } else {
        return ArrayTrait::new();
    }
}

fn sha256_inner(ref data: Array<u32>, i: usize, ref k: Array<u32>, ref h: Array<u32>) {
    quaireaux_utils::check_gas();
    if 16 * i < data.len() {
        let mut w = create_w(ref data, i, 16);

        create_message_schedule(ref w, 16);

        let h2 = copy_array(ref h, h.len());
        let h2 = compression(ref w, 0, ref k, h2);

        let mut t = ArrayTrait::<u32>::new();
        t.append(u32_wrapping_add(*h[0], *h2[0]));
        t.append(u32_wrapping_add(*h[1], *h2[1]));
        t.append(u32_wrapping_add(*h[2], *h2[2]));
        t.append(u32_wrapping_add(*h[3], *h2[3]));
        t.append(u32_wrapping_add(*h[4], *h2[4]));
        t.append(u32_wrapping_add(*h[5], *h2[5]));
        t.append(u32_wrapping_add(*h[6], *h2[6]));
        t.append(u32_wrapping_add(*h[7], *h2[7]));
        h = t;

        sha256_inner(ref data, i + 1, ref k, ref h);
    }
}

fn compression(ref w: Array<u32>, i: usize, ref k: Array<u32>, mut h: Array<u32>) -> Array<u32> {
    quaireaux_utils::check_gas();
    if i < 64 {
        let s1 = bsig1(*h[4]);
        let ch = ch(*h[4], *h[5], *h[6]);
        let temp1 = u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(*h[7], s1), ch), *k[1]), *w[i]);
        let s0 = bsig0(*h[0]);
        let maj = maj(*h[0], *h[1], *h[2]);
        let temp2 = u32_wrapping_add(s0, maj);

        let mut t = ArrayTrait::<u32>::new();
        t.append(u32_wrapping_add(temp1, temp2));
        t.append(*h[0]);
        t.append(*h[1]);
        t.append(*h[2]);
        t.append(u32_wrapping_add(*h[3], temp1));
        t.append(*h[4]);
        t.append(*h[5]);
        t.append(*h[6]);
        let h = t;
        let h = compression(ref w, i + 1, ref k, h);
    }
    return h;
}

fn create_message_schedule(ref w: Array<u32>, i: usize) {
    quaireaux_utils::check_gas();
    if i < 64 {
        let s0 = ssig0(*w[i - 15]);
        let s1 = ssig1(*w[i - 2]);
        w.append( u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(*w[i - 16], s0), *w[i - 7]), s1) );
        create_message_schedule(ref w, i + 1);
    }
}

fn create_w(ref data: Array<u32>, i: usize, j: usize) -> Array<u32> {
    quaireaux_utils::check_gas();
    if j <= 0 {
        return ArrayTrait::new();
    } else {
        let mut result = create_w(ref data, i, j - 1);
        result.append(*data[i * 16 + j - 1]);
        return result;
    }
}

fn from_u8vec_to_u32vec(ref data: Array<u8>, i: usize) -> Array<u32> {
    quaireaux_utils::check_gas();
    if i <= 0 {
        return ArrayTrait::new();
    } else {
        let mut value = 0_u128;

        let x: felt252 = (*data[4 * (i - 1) + 0]).into();
        let x: u32 = x.try_into().unwrap();
        let x = shl(x, 24);
        let x: felt252 = x.into();
        let x: u128 = x.try_into().unwrap();
        value = value | x;

        let x: felt252 = (*data[4 * (i - 1) + 0]).into();
        let x: u32 = x.try_into().unwrap();
        let x = shl(x, 24);
        let x: felt252 = x.into();
        let x: u128 = x.try_into().unwrap();
        value = value | x;

        let x: felt252 = (*data[4 * (i - 1) + 0]).into();
        let x: u32 = x.try_into().unwrap();
        let x = shl(x, 8);
        let x: felt252 = x.into();
        let x: u128 = x.try_into().unwrap();
        value = value | x;

        let x: felt252 = (*data[4 * (i - 1) + 0]).into();
        let x: u32 = x.try_into().unwrap();
        let x = shl(x, 0);
        let x: felt252 = x.into();
        let x: u128 = x.try_into().unwrap();
        value = value | x;

        let mut result = from_u8vec_to_u32vec(ref data, i - 1);
        let value: felt252 = x.into();
        let value: u32 = value.try_into().unwrap();
        result.append(value);
        return result;
    }
}

fn add_padding(ref data: Array<u8>) {
    quaireaux_utils::check_gas();
    if (64 * ((data.len() - 1) / 64 + 1)) - 8 != data.len() {
        data.append(0);
        add_padding(ref data);
    }
}

fn get_h() -> Array<u32> {
    let mut h = ArrayTrait::new();
    h.append(0x6a09e667);
    h.append(0xbb67ae85);
    h.append(0x3c6ef372);
    h.append(0xa54ff53a);
    h.append(0x510e527f);
    h.append(0x9b05688c);
    h.append(0x1f83d9ab);
    h.append(0x5be0cd19);
    return h;
}

fn get_k() -> Array<u32> {
    let mut k = ArrayTrait::new();
    k.append(0x428a2f98);
    k.append(0x71374491);
    k.append(0xb5c0fbcf);
    k.append(0xe9b5dba5);
    k.append(0x3956c25b);
    k.append(0x59f111f1);
    k.append(0x923f82a4);
    k.append(0xab1c5ed5);
    k.append(0xd807aa98);
    k.append(0x12835b01);
    k.append(0x243185be);
    k.append(0x550c7dc3);
    k.append(0x72be5d74);
    k.append(0x80deb1fe);
    k.append(0x9bdc06a7);
    k.append(0xc19bf174);
    k.append(0xe49b69c1);
    k.append(0xefbe4786);
    k.append(0x0fc19dc6);
    k.append(0x240ca1cc);
    k.append(0x2de92c6f);
    k.append(0x4a7484aa);
    k.append(0x5cb0a9dc);
    k.append(0x76f988da);
    k.append(0x983e5152);
    k.append(0xa831c66d);
    k.append(0xb00327c8);
    k.append(0xbf597fc7);
    k.append(0xc6e00bf3);
    k.append(0xd5a79147);
    k.append(0x06ca6351);
    k.append(0x14292967);
    k.append(0x27b70a85);
    k.append(0x2e1b2138);
    k.append(0x4d2c6dfc);
    k.append(0x53380d13);
    k.append(0x650a7354);
    k.append(0x766a0abb);
    k.append(0x81c2c92e);
    k.append(0x92722c85);
    k.append(0xa2bfe8a1);
    k.append(0xa81a664b);
    k.append(0xc24b8b70);
    k.append(0xc76c51a3);
    k.append(0xd192e819);
    k.append(0xd6990624);
    k.append(0xf40e3585);
    k.append(0x106aa070);
    k.append(0x19a4c116);
    k.append(0x1e376c08);
    k.append(0x2748774c);
    k.append(0x34b0bcb5);
    k.append(0x391c0cb3);
    k.append(0x4ed8aa4a);
    k.append(0x5b9cca4f);
    k.append(0x682e6ff3);
    k.append(0x748f82ee);
    k.append(0x78a5636f);
    k.append(0x84c87814);
    k.append(0x8cc70208);
    k.append(0x90befffa);
    k.append(0xa4506ceb);
    k.append(0xbef9a3f7);
    k.append(0xc67178f2);
    return k;
}
