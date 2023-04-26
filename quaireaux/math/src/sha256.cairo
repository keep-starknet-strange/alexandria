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

const U8_MAX: u128 = 0xFF;
const U32_MAX: u128 = 0xFFFFFFFF;
const U64_MAX: u128 = 0xFFFFFFFFFFFFFFFF;

fn from_u8Array_to_felt252Array(ref data: Array<u8>, i: usize) -> Array<felt252> {
    quaireaux_utils::check_gas();
    if i <= 0 {
        return ArrayTrait::new();
    } else {
        let mut result = from_u8Array_to_felt252Array(ref data, i - 1);
        result.append((*data[i - 1]).into());
        return result;
    }
}

fn from_u32Array_to_felt252Array(ref data: Array<u32>, i: usize) -> Array<felt252> {
    quaireaux_utils::check_gas();
    if i <= 0 {
        return ArrayTrait::new();
    } else {
        let mut result = from_u32Array_to_felt252Array(ref data, i - 1);
        result.append((*data[i - 1]).into());
        return result;
    }
}

fn pow(x: u128, n: u128) -> u128 {
    quaireaux_utils::check_gas();
    if n == 0 {
        return 1;
    } else if (n & 1) == 1 {
        return x * pow(x * x, n / 2);
    } else {
        return pow(x * x, n / 2);
    }
}

fn shl(x: u128, n: u128) -> u128 {
    return x * pow(2, n);
}

fn shr(x: u128, n: u128) -> u128 {
    return x / pow(2, n);
}

fn ch(x: u32, y: u32, z: u32) -> u32 {
    let x: felt252 = x.into();
    let x: u128 = x.try_into().unwrap();

    let y: felt252 = y.into();
    let y: u128 = y.try_into().unwrap();
    
    let z: felt252 = z.into();
    let z: u128 = z.try_into().unwrap();

    let result: u128 = (x & y) ^ ((x ^ U32_MAX) & z);
    let result: felt252 = result.into();
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
    let result: felt252 = result.into();
    return result.try_into().unwrap();
}

fn bsig0(x: u32) -> u32 {
    // x.rotate_right(2) ^ x.rotate_right(13) ^ x.rotate_right(22)
    let x: felt252 = x.into();
    let x: u128 = x.try_into().unwrap();

    let y: felt252 = x.into();
    let y: u128 = y.try_into().unwrap();
    
    let z: felt252 = x.into();
    let z: u128 = z.try_into().unwrap();

    let x1 = (shr(x, 2) | shl(x, 32 - 2)) & U32_MAX;
    let x2 = (shr(x, 13) | shl(x, 32 - 13)) & U32_MAX;
    let x3 = (shr(x, 22) | shl(x, 32 - 22)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    let result: felt252 = result.into();
    return result.try_into().unwrap();
}

fn bsig1(x: u32) -> u32 {
    // x.rotate_right(6) ^ x.rotate_right(11) ^ x.rotate_right(25)
    let x: felt252 = x.into();
    let x: u128 = x.try_into().unwrap();

    let y: felt252 = x.into();
    let y: u128 = y.try_into().unwrap();
    
    let z: felt252 = x.into();
    let z: u128 = z.try_into().unwrap();

    let x1 = (shr(x, 6) | shl(x, 32 - 6)) & U32_MAX;
    let x2 = (shr(x, 11) | shl(x, 32 - 11)) & U32_MAX;
    let x3 = (shr(x, 25) | shl(x, 32 - 25)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    let result: felt252 = result.into();
    return result.try_into().unwrap();
}

fn ssig0(x: u32) -> u32 {
    // x.rotate_right(7) ^ x.rotate_right(18) ^ (x >> 3)
    let x: felt252 = x.into();
    let x: u128 = x.try_into().unwrap();

    let y: felt252 = x.into();
    let y: u128 = y.try_into().unwrap();
    
    let z: felt252 = x.into();
    let z: u128 = z.try_into().unwrap();

    let x1 = (shr(x, 7) | shl(x, 32 - 7)) & U32_MAX;
    let x2 = (shr(x, 18) | shl(x, 32 - 18)) & U32_MAX;
    let x3 = (shr(x, 3)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    let result: felt252 = result.into();
    return result.try_into().unwrap();
}

fn ssig1(x: u32) -> u32 {
    // x.rotate_right(17) ^ x.rotate_right(19) ^ (x >> 10)
    let x: felt252 = x.into();
    let x: u128 = x.try_into().unwrap();

    let y: felt252 = x.into();
    let y: u128 = y.try_into().unwrap();
    
    let z: felt252 = x.into();
    let z: u128 = z.try_into().unwrap();

    let x1 = (shr(x, 17) | shl(x, 32 - 17)) & U32_MAX;
    let x2 = (shr(x, 19) | shl(x, 32 - 19)) & U32_MAX;
    let x3 = (shr(x, 10)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    let result: felt252 = result.into();
    return result.try_into().unwrap();
}

fn sha256(mut data: Array<u8>) -> Array<u8> {
    let u64_data_length: felt252 = (data.len() * 8).into();
    let u64_data_length: u128 = u64_data_length.try_into().unwrap();
    let u64_data_length = u64_data_length & U64_MAX;

    // add one
    data.append(0x80);

    add_padding(ref data);

    // add length to the end

    let result = shr(u64_data_length, 56);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result = shr(u64_data_length, 48);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result = shr(u64_data_length, 40);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result = shr(u64_data_length, 32);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result = shr(u64_data_length, 24);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result = shr(u64_data_length, 16);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result = shr(u64_data_length, 8);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let result = shr(u64_data_length, 0);
    let result = result & U8_MAX;
    let result: felt252 = result.into();
    let result: u8 = result.try_into().unwrap();
    data.append(result);

    let datap = from_u8Array_to_felt252Array(ref data, data.len());
    datap.print();

    let u32_data_length = 16 * ((data.len() - 1) / 64 + 1);
    let mut data = from_u8Array_to_u32Array(ref data, u32_data_length);

    let mut h = get_h();
    let mut k = get_k();
    h = sha256_inner(ref data, 0, ref k, h);

    let result = from_u32Array_to_u8Array(ref h, 8);
    return result;
}

fn from_u32Array_to_u8Array(ref data: Array<u32>, i: usize) -> Array<u8> {
    quaireaux_utils::check_gas();
    if i <= 0 {
        return ArrayTrait::new();
    } else {
        let mut result = from_u32Array_to_u8Array(ref data, i - 1);

        let x: felt252 = (*data[i - 1]).into();
        let x = shr(x.try_into().unwrap(), 24);
        let x = x & 0xFF;
        let x: felt252 = x.into();
        let x: u8 = x.try_into().unwrap();
        result.append(x);

        let x: felt252 = (*data[i - 1]).into();
        let x = shr(x.try_into().unwrap(), 16);
        let x = x & 0xFF;
        let x: felt252 = x.into();
        let x: u8 = x.try_into().unwrap();
        result.append(x);

        let x: felt252 = (*data[i - 1]).into();
        let x = shr(x.try_into().unwrap(), 8);
        let x = x & 0xFF;
        let x: felt252 = x.into();
        let x: u8 = x.try_into().unwrap();
        result.append(x);

        let x: felt252 = (*data[i - 1]).into();
        let x = shr(x.try_into().unwrap(), 0);
        let x = x & 0xFF;
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

fn sha256_inner(ref data: Array<u32>, i: usize, ref k: Array<u32>, mut h: Array<u32>) -> Array<u32> {
    quaireaux_utils::check_gas();
    if 16 * i < data.len() {
        let mut w = create_w(ref data, i, 16);

        create_message_schedule(ref w, 16);

        let mut h2 = copy_array(ref h, h.len());
        let mut h2 = compression(ref w, 0, ref k, h2);

        let mut t = ArrayTrait::new();
        t.append(u32_wrapping_add(*h[0], *h2[0]));
        t.append(u32_wrapping_add(*h[1], *h2[1]));
        t.append(u32_wrapping_add(*h[2], *h2[2]));
        t.append(u32_wrapping_add(*h[3], *h2[3]));
        t.append(u32_wrapping_add(*h[4], *h2[4]));
        t.append(u32_wrapping_add(*h[5], *h2[5]));
        t.append(u32_wrapping_add(*h[6], *h2[6]));
        t.append(u32_wrapping_add(*h[7], *h2[7]));
        h = t;

        return sha256_inner(ref data, i + 1, ref k, h);
    } else {
        return h;
    }
}

fn compression(ref w: Array<u32>, i: usize, ref k: Array<u32>, mut h: Array<u32>) -> Array<u32> {
    quaireaux_utils::check_gas();
    if i < 64 {
        let s1 = bsig1(*h[4]);
        let ch = ch(*h[4], *h[5], *h[6]);
        let temp1 = u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(*h[7], s1), ch), *k[i]), *w[i]);
        let s0 = bsig0(*h[0]);
        let maj = maj(*h[0], *h[1], *h[2]);
        let temp2 = u32_wrapping_add(s0, maj);

        let mut t = ArrayTrait::new();
        t.append(u32_wrapping_add(temp1, temp2));
        t.append(*h[0]);
        t.append(*h[1]);
        t.append(*h[2]);
        t.append(u32_wrapping_add(*h[3], temp1));
        t.append(*h[4]);
        t.append(*h[5]);
        t.append(*h[6]);
        h = t;
        h = compression(ref w, i + 1, ref k, h);
        return h;
    } else {
        return h;
    }
}

fn create_message_schedule(ref w: Array<u32>, i: usize) {
    quaireaux_utils::check_gas();
    if i < 64 {
        let s0 = ssig0(*w[i - 15]);
        let s1 = ssig1(*w[i - 2]);
        w.append(u32_wrapping_add(u32_wrapping_add(*w[i - 16], s0), u32_wrapping_add(*w[i - 7], s1)));
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

fn from_u8Array_to_u32Array(ref data: Array<u8>, i: usize) -> Array<u32> {
    quaireaux_utils::check_gas();
    if i <= 0 {
        return ArrayTrait::new();
    } else {
        let mut value = 0_u128;

        let d: felt252 = (*data[4 * (i - 1) + 0]).into();
        let x = shl(d.try_into().unwrap(), 24) & U32_MAX;
        value = value | x;

        let d: felt252 = (*data[4 * (i - 1) + 1]).into();
        let x = shl(d.try_into().unwrap(), 16) & U32_MAX;
        value = value | x;

        let d: felt252 = (*data[4 * (i - 1) + 2]).into();
        let x = shl(d.try_into().unwrap(), 8) & U32_MAX;
        value = value | x;

        let d: felt252 = (*data[4 * (i - 1) + 3]).into();
        let x = shl(d.try_into().unwrap(), 0) & U32_MAX;
        value = value | x;
        let value: felt252 = value.into();

        let mut result = from_u8Array_to_u32Array(ref data, i - 1);
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
