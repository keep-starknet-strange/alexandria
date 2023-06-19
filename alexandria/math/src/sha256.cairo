use array::{ArrayTrait, ArrayTCloneImpl};
use clone::Clone;
use integer::{u32_wrapping_add, U128BitAnd, U128BitOr, U128BitXor, upcast, downcast};
use option::OptionTrait;
use traits::{Div, Into, TryInto};
use alexandria_math::math::{shl, shr, U64_MAX, U32_MAX, U8_MAX};

fn ch(x: u32, y: u32, z: u32) -> u32 {
    let x: u128 = upcast(x);
    let y: u128 = upcast(y);
    let z: u128 = upcast(z);
    let result = (x & y) ^ ((x ^ U32_MAX) & z);
    downcast(result).unwrap()
}

fn maj(x: u32, y: u32, z: u32) -> u32 {
    let x: u128 = upcast(x);
    let y: u128 = upcast(y);
    let z: u128 = upcast(z);
    let result = (x & y) ^ (x & z) ^ (y & z);
    downcast(result).unwrap()
}

fn bsig0(x: u32) -> u32 {
    let x: u128 = upcast(x);
    let x1 = (shr(x, 2) | shl(x, 32 - 2)) & U32_MAX;
    let x2 = (shr(x, 13) | shl(x, 32 - 13)) & U32_MAX;
    let x3 = (shr(x, 22) | shl(x, 32 - 22)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    downcast(result).unwrap()
}

fn bsig1(x: u32) -> u32 {
    let x: u128 = upcast(x);
    let x1 = (shr(x, 6) | shl(x, 32 - 6)) & U32_MAX;
    let x2 = (shr(x, 11) | shl(x, 32 - 11)) & U32_MAX;
    let x3 = (shr(x, 25) | shl(x, 32 - 25)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    downcast(result).unwrap()
}

fn ssig0(x: u32) -> u32 {
    let x: u128 = upcast(x);
    let x1 = (shr(x, 7) | shl(x, 32 - 7)) & U32_MAX;
    let x2 = (shr(x, 18) | shl(x, 32 - 18)) & U32_MAX;
    let x3 = (shr(x, 3)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    downcast(result).unwrap()
}

fn ssig1(x: u32) -> u32 {
    let x: u128 = upcast(x);
    let x1 = (shr(x, 17) | shl(x, 32 - 17)) & U32_MAX;
    let x2 = (shr(x, 19) | shl(x, 32 - 19)) & U32_MAX;
    let x3 = (shr(x, 10)) & U32_MAX;
    let result = x1 ^ x2 ^ x3;
    downcast(result).unwrap()
}

fn sha256(mut data: Array<u8>) -> Array<u8> {
    let u64_data_length: u128 = upcast(data.len() * 8);
    let u64_data_length = u64_data_length & U64_MAX;

    // add one
    data.append(0x80);

    add_padding(ref data);

    // add length to the end
    data.append(downcast(shr(u64_data_length, 56) & U8_MAX).unwrap());
    data.append(downcast(shr(u64_data_length, 48) & U8_MAX).unwrap());
    data.append(downcast(shr(u64_data_length, 40) & U8_MAX).unwrap());
    data.append(downcast(shr(u64_data_length, 32) & U8_MAX).unwrap());
    data.append(downcast(shr(u64_data_length, 24) & U8_MAX).unwrap());
    data.append(downcast(shr(u64_data_length, 16) & U8_MAX).unwrap());
    data.append(downcast(shr(u64_data_length, 8) & U8_MAX).unwrap());
    data.append(downcast(shr(u64_data_length, 0) & U8_MAX).unwrap());

    let u32_data_length = 16 * ((data.len() - 1) / 64 + 1);
    let mut data = from_u8Array_to_u32Array(data, u32_data_length);
    let mut h = get_h();
    let mut k = get_k();
    h = sha256_inner(ref data, 0, ref k, h);

    from_u32Array_to_u8Array(ref h, 8)
}

fn from_u32Array_to_u8Array(ref data: Array<u32>, i: usize) -> Array<u8> {
    if i <= 0 {
        return ArrayTrait::new();
    }
    let mut result = from_u32Array_to_u8Array(ref data, i - 1);
    result.append(downcast(shr(upcast(*data[i - 1]), 24) & U8_MAX).unwrap());
    result.append(downcast(shr(upcast(*data[i - 1]), 16) & U8_MAX).unwrap());
    result.append(downcast(shr(upcast(*data[i - 1]), 8) & U8_MAX).unwrap());
    result.append(downcast(shr(upcast(*data[i - 1]), 0) & U8_MAX).unwrap());
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
    compression(w, i + 1, ref k, h)
}

fn create_message_schedule(ref w: Array<u32>, i: usize) {
    if i >= 64 {
        return ();
    }
    let s0 = ssig0(*w[i - 15]);
    let s1 = ssig1(*w[i - 2]);
    w.append(u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(*w[i - 16], s0), *w[i - 7]), s1));
    create_message_schedule(ref w, i + 1)
}

fn create_w(ref data: Array<u32>, i: usize, j: usize) -> Array<u32> {
    if j <= 0 {
        return ArrayTrait::new();
    }
    let mut result = create_w(ref data, i, j - 1);
    result.append(*data[i * 16 + j - 1]);
    result
}

fn from_u8Array_to_u32Array(data: Array<u8>, i: usize) -> Array<u32> {
    if i <= 0 {
        return ArrayTrait::new();
    }
    let mut value = 0_u128;

    value = value | (shl(upcast(*data[4 * (i - 1) + 0]), 24) & U32_MAX);
    value = value | (shl(upcast(*data[4 * (i - 1) + 1]), 16) & U32_MAX);
    value = value | (shl(upcast(*data[4 * (i - 1) + 2]), 8) & U32_MAX);
    value = value | (shl(upcast(*data[4 * (i - 1) + 3]), 0) & U32_MAX);

    let mut result = from_u8Array_to_u32Array(data, i - 1);
    result.append(downcast(value).unwrap());
    result
}

fn add_padding(ref data: Array<u8>) {
    if (64 * ((data.len() - 1) / 64 + 1))
        - 8 != data.len() {
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
    h
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
    k
}
