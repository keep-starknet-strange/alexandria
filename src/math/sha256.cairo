use core::traits::TryInto;
use array::ArrayTrait;
use clone::Clone;
use integer::{u32_wrapping_add, BoundedInt};
use option::OptionTrait;
use traits::Into;

use alexandria::math::math::BitShift;

fn ch(x: u32, y: u32, z: u32) -> u32 {
    let x: u128 = x.into();
    let y: u128 = y.into();
    let z: u128 = z.into();
    let result = (x & y) ^ ((x ^ BoundedInt::<u32>::max().into()) & z);
    result.try_into().unwrap()
}

fn maj(x: u32, y: u32, z: u32) -> u32 {
    let x: u128 = x.into();
    let y: u128 = y.into();
    let z: u128 = z.into();
    let result = (x & y) ^ (x & z) ^ (y & z);
    result.try_into().unwrap()
}

fn bsig0(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (BitShift::shr(x, 2) | BitShift::shl(x, 32 - 2)) & BoundedInt::<u32>::max().into();
    let x2 = (BitShift::shr(x, 13) | BitShift::shl(x, 32 - 13)) & BoundedInt::<u32>::max().into();
    let x3 = (BitShift::shr(x, 22) | BitShift::shl(x, 32 - 22)) & BoundedInt::<u32>::max().into();
    let result = x1 ^ x2 ^ x3;
    result.try_into().unwrap()
}

fn bsig1(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (BitShift::shr(x, 6) | BitShift::shl(x, 32 - 6)) & BoundedInt::<u32>::max().into();
    let x2 = (BitShift::shr(x, 11) | BitShift::shl(x, 32 - 11)) & BoundedInt::<u32>::max().into();
    let x3 = (BitShift::shr(x, 25) | BitShift::shl(x, 32 - 25)) & BoundedInt::<u32>::max().into();
    let result = x1 ^ x2 ^ x3;
    result.try_into().unwrap()
}

fn ssig0(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (BitShift::shr(x, 7) | BitShift::shl(x, 32 - 7)) & BoundedInt::<u32>::max().into();
    let x2 = (BitShift::shr(x, 18) | BitShift::shl(x, 32 - 18)) & BoundedInt::<u32>::max().into();
    let x3 = (BitShift::shr(x, 3)) & BoundedInt::<u32>::max().into();
    let result = x1 ^ x2 ^ x3;
    result.try_into().unwrap()
}

fn ssig1(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (BitShift::shr(x, 17) | BitShift::shl(x, 32 - 17)) & BoundedInt::<u32>::max().into();
    let x2 = (BitShift::shr(x, 19) | BitShift::shl(x, 32 - 19)) & BoundedInt::<u32>::max().into();
    let x3 = (BitShift::shr(x, 10)) & BoundedInt::<u32>::max().into();
    let result = x1 ^ x2 ^ x3;
    result.try_into().unwrap()
}

fn sha256(mut data: Array<u8>) -> Array<u8> {
    let u64_data_length: u128 = (data.len() * 8).into();
    let u64_data_length = u64_data_length & BoundedInt::<u64>::max().into();

    // add one
    data.append(0x80);

    add_padding(ref data);

    // add length to the end
    let mut res = BitShift::shr(u64_data_length, 56) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());
    res = BitShift::shr(u64_data_length, 48) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());
    res = BitShift::shr(u64_data_length, 40) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());
    res = BitShift::shr(u64_data_length, 32) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());
    res = BitShift::shr(u64_data_length, 24) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());
    res = BitShift::shr(u64_data_length, 16) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());
    res = BitShift::shr(u64_data_length, 8) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());
    res = BitShift::shr(u64_data_length, 0) & BoundedInt::<u8>::max().into();
    data.append(res.try_into().unwrap());

    let u32_data_length = 16 * ((data.len() - 1) / 64 + 1);
    let mut data = from_u8Array_to_u32Array(data, u32_data_length);
    let mut h = get_h();
    let mut k = get_k();
    h = sha256_inner(ref data, 0, ref k, h);

    from_u32Array_to_u8Array(ref h, 8)
}

fn from_u32Array_to_u8Array(ref data: Array<u32>, i: usize) -> Array<u8> {
    if i <= 0 {
        return array![];
    }
    let mut result = from_u32Array_to_u8Array(ref data, i - 1);
    let mut res: u128 = BitShift::shr((*data[i - 1]).into(), 24) & BoundedInt::<u8>::max().into();
    result.append(res.try_into().unwrap());
    res = BitShift::shr((*data[i - 1]).into(), 16) & BoundedInt::<u8>::max().into();
    result.append(res.try_into().unwrap());
    res = BitShift::shr((*data[i - 1]).into(), 8) & BoundedInt::<u8>::max().into();
    result.append(res.try_into().unwrap());
    res = BitShift::shr((*data[i - 1]).into(), 0) & BoundedInt::<u8>::max().into();
    result.append(res.try_into().unwrap());
    result
}

fn sha256_inner(
    ref data: Array<u32>, i: usize, ref k: Array<u32>, mut h: Array<u32>
) -> Array<u32> {
    if 16 * i >= data.len() {
        return h;
    }
    let mut w = create_w(ref data, i, 16);
    create_message_schedule(ref w, 16);
    let mut h2 = h.clone();
    let mut h2 = compression(w, 0, ref k, h2);
    let mut t = array![];
    t.append(u32_wrapping_add(*h[0], *h2[0]));
    t.append(u32_wrapping_add(*h[1], *h2[1]));
    t.append(u32_wrapping_add(*h[2], *h2[2]));
    t.append(u32_wrapping_add(*h[3], *h2[3]));
    t.append(u32_wrapping_add(*h[4], *h2[4]));
    t.append(u32_wrapping_add(*h[5], *h2[5]));
    t.append(u32_wrapping_add(*h[6], *h2[6]));
    t.append(u32_wrapping_add(*h[7], *h2[7]));
    h = t;
    sha256_inner(ref data, i + 1, ref k, h)
}

fn compression(w: Array<u32>, i: usize, ref k: Array<u32>, mut h: Array<u32>) -> Array<u32> {
    if i >= 64 {
        return h;
    }
    let s1 = bsig1(*h[4]);
    let ch = ch(*h[4], *h[5], *h[6]);
    let temp1 = u32_wrapping_add(
        u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(*h[7], s1), ch), *k[i]), *w[i]
    );
    let s0 = bsig0(*h[0]);
    let maj = maj(*h[0], *h[1], *h[2]);
    let temp2 = u32_wrapping_add(s0, maj);
    let mut t = array![];
    t.append(u32_wrapping_add(temp1, temp2));
    t.append(*h[0]);
    t.append(*h[1]);
    t.append(*h[2]);
    t.append(u32_wrapping_add(*h[3], temp1));
    t.append(*h[4]);
    t.append(*h[5]);
    t.append(*h[6]);
    h = t;
    compression(w, i + 1, ref k, h)
}

fn create_message_schedule(ref w: Array<u32>, i: usize) {
    if i >= 64 {
        return;
    }
    let s0 = ssig0(*w[i - 15]);
    let s1 = ssig1(*w[i - 2]);
    w.append(u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(*w[i - 16], s0), *w[i - 7]), s1));
    create_message_schedule(ref w, i + 1)
}

fn create_w(ref data: Array<u32>, i: usize, j: usize) -> Array<u32> {
    if j <= 0 {
        return array![];
    }
    let mut result = create_w(ref data, i, j - 1);
    result.append(*data[i * 16 + j - 1]);
    result
}

fn from_u8Array_to_u32Array(data: Array<u8>, i: usize) -> Array<u32> {
    if i <= 0 {
        return array![];
    }
    let mut value = 0_u128;

    value = value
        | (BitShift::shl((*data[4 * (i - 1) + 0]).into(), 24) & BoundedInt::<u32>::max().into());
    value = value
        | (BitShift::shl((*data[4 * (i - 1) + 1]).into(), 16) & BoundedInt::<u32>::max().into());
    value = value
        | (BitShift::shl((*data[4 * (i - 1) + 2]).into(), 8) & BoundedInt::<u32>::max().into());
    value = value
        | (BitShift::shl((*data[4 * (i - 1) + 3]).into(), 0) & BoundedInt::<u32>::max().into());

    let mut result = from_u8Array_to_u32Array(data, i - 1);
    result.append(value.try_into().unwrap());
    result
}

fn add_padding(ref data: Array<u8>) {
    if (64 * ((data.len() - 1) / 64 + 1)) - 8 != data.len() {
        data.append(0);
        add_padding(ref data);
    }
}

fn get_h() -> Array<u32> {
    let mut h = array![];
    h.append(0x6a09e667);
    h.append(0xbb67ae85);
    h.append(0x3c6ef372);
    h.append(0xa54ff53a);
    h.append(0x510e527f);
    h.append(0x9b05688c);
    h.append(0x1f83d9ab);
    h.append(0x5be0cd19);
    h
}

fn get_k() -> Array<u32> {
    let mut k = array![];
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
    k
}
