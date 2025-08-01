use core::num::traits::{Bounded, OverflowingAdd};

/// SHA-256 choice function: x chooses between y and z
/// #### Arguments
/// * `x` - Control value for choosing between y and z
/// * `y` - First choice value
/// * `z` - Second choice value
/// #### Returns
/// * `u32` - Result of (x & y) ^ (~x & z)
fn ch(x: u32, y: u32, z: u32) -> u32 {
    (x & y) ^ ((x ^ Bounded::<u32>::MAX.into()) & z)
}

/// SHA-256 majority function: returns majority bit of three inputs
/// #### Arguments
/// * `x` - First input value
/// * `y` - Second input value
/// * `z` - Third input value
/// #### Returns
/// * `u32` - Result of (x & y) ^ (x & z) ^ (y & z)
fn maj(x: u32, y: u32, z: u32) -> u32 {
    (x & y) ^ (x & z) ^ (y & z)
}

/// SHA-256 big sigma 0 function: performs specific rotations and XOR
/// #### Arguments
/// * `x` - Input value to transform
/// #### Returns
/// * `u32` - Result of ROTR(x,2) ^ ROTR(x,13) ^ ROTR(x,22)
fn bsig0(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x4) | (x * 0x40000000);
    let x2 = (x / 0x2000) | (x * 0x80000);
    let x3 = (x / 0x400000) | (x * 0x400);
    let result = (x1 ^ x2 ^ x3) & Bounded::<u32>::MAX.into();
    result.try_into().unwrap()
}

/// SHA-256 big sigma 1 function: performs specific rotations and XOR
/// #### Arguments
/// * `x` - Input value to transform
/// #### Returns
/// * `u32` - Result of ROTR(x,6) ^ ROTR(x,11) ^ ROTR(x,25)
fn bsig1(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x40) | (x * 0x4000000);
    let x2 = (x / 0x800) | (x * 0x200000);
    let x3 = (x / 0x2000000) | (x * 0x80);
    let result = (x1 ^ x2 ^ x3) & Bounded::<u32>::MAX.into();
    result.try_into().unwrap()
}

/// SHA-256 small sigma 0 function: performs rotations and shift with XOR
/// #### Arguments
/// * `x` - Input value to transform
/// #### Returns
/// * `u32` - Result of ROTR(x,7) ^ ROTR(x,18) ^ SHR(x,3)
fn ssig0(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x80) | (x * 0x2000000);
    let x2 = (x / 0x40000) | (x * 0x4000);
    let x3 = (x / 0x8);
    let result = (x1 ^ x2 ^ x3) & Bounded::<u32>::MAX.into();
    result.try_into().unwrap()
}

/// SHA-256 small sigma 1 function: performs rotations and shift with XOR
/// #### Arguments
/// * `x` - Input value to transform
/// #### Returns
/// * `u32` - Result of ROTR(x,17) ^ ROTR(x,19) ^ SHR(x,10)
fn ssig1(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x20000) | (x * 0x8000);
    let x2 = (x / 0x80000) | (x * 0x2000);
    let x3 = (x / 0x400);
    let result = (x1 ^ x2 ^ x3) & Bounded::<u32>::MAX.into();
    result.try_into().unwrap()
}

/// Computes SHA-256 hash of the input data
///
/// This function implements the SHA-256 cryptographic hash algorithm following RFC 6234.
/// It processes the input by padding it appropriately, then processing in 512-bit blocks
/// through 64 rounds of operations using the SHA-256 compression function.
///
/// #### Arguments
/// * `data` - Array of bytes to be hashed
///
/// #### Returns
/// * `Array<u8>` - The 32-byte SHA-256 hash digest as an array of bytes
#[deprecated(
    feature: "deprecated-sha256",
    note: "Use `core::sha256::compute_sha256_byte_array`.",
    since: "2.7.0",
)]
pub fn sha256(mut data: Array<u8>) -> Array<u8> {
    let data_len: u64 = (data.len() * 8).into();

    // add one
    data.append(0x80);
    // add padding
    while ((64 * ((data.len() - 1) / 64 + 1)) - 8 != data.len()) {
        data.append(0);
    }

    // add length to the end
    let mut res = (data_len & 0xff00000000000000) / 0x100000000000000;
    data.append(res.try_into().unwrap());
    res = (data_len.into() & 0xff000000000000) / 0x1000000000000;
    data.append(res.try_into().unwrap());
    res = (data_len.into() & 0xff0000000000) / 0x10000000000;
    data.append(res.try_into().unwrap());
    res = (data_len.into() & 0xff00000000) / 0x100000000;
    data.append(res.try_into().unwrap());
    res = (data_len.into() & 0xff000000) / 0x1000000;
    data.append(res.try_into().unwrap());
    res = (data_len.into() & 0xff0000) / 0x10000;
    data.append(res.try_into().unwrap());
    res = (data_len.into() & 0xff00) / 0x100;
    data.append(res.try_into().unwrap());
    res = data_len.into() & 0xff;
    data.append(res.try_into().unwrap());

    let data = from_u8Array_to_u32Array(data.span());
    let res = sha256_inner(data.span(), 0, k.span(), h.span());

    from_u32Array_to_u8Array(res)
}

/// Converts an array of u32 values to an array of u8 bytes in big-endian format
/// #### Arguments
/// * `data` - Span of u32 values to convert
/// #### Returns
/// * `Array<u8>` - Array of bytes in big-endian order
fn from_u32Array_to_u8Array(mut data: Span<u32>) -> Array<u8> {
    let mut result = array![];
    for val in data {
        let mut res = (*val & 0xff000000) / 0x1000000;
        result.append(res.try_into().unwrap());
        res = (*val & 0xff0000) / 0x10000;
        result.append(res.try_into().unwrap());
        res = (*val & 0xff00) / 0x100;
        result.append(res.try_into().unwrap());
        res = *val & 0xff;
        result.append(res.try_into().unwrap());
    }
    result
}

/// Internal SHA-256 processing function that processes data in 512-bit blocks
/// #### Arguments
/// * `data` - Input data as u32 array
/// * `i` - Current block index
/// * `k` - SHA-256 round constants
/// * `h` - Current hash state
/// #### Returns
/// * `Span<u32>` - Updated hash state after processing
fn sha256_inner(mut data: Span<u32>, i: usize, k: Span<u32>, mut h: Span<u32>) -> Span<u32> {
    if 16 * i >= data.len() {
        return h;
    }
    let w = create_message_schedule(data, i);
    let h2 = compression(w, 0, k, h);

    let mut t = array![];
    let (tmp, _) = (*h[0]).overflowing_add(*h2[0]);
    t.append(tmp);
    let (tmp, _) = (*h[1]).overflowing_add(*h2[1]);
    t.append(tmp);
    let (tmp, _) = (*h[2]).overflowing_add(*h2[2]);
    t.append(tmp);
    let (tmp, _) = (*h[3]).overflowing_add(*h2[3]);
    t.append(tmp);
    let (tmp, _) = (*h[4]).overflowing_add(*h2[4]);
    t.append(tmp);
    let (tmp, _) = (*h[5]).overflowing_add(*h2[5]);
    t.append(tmp);
    let (tmp, _) = (*h[6]).overflowing_add(*h2[6]);
    t.append(tmp);
    let (tmp, _) = (*h[7]).overflowing_add(*h2[7]);
    t.append(tmp);
    h = t.span();
    sha256_inner(data, i + 1, k, h)
}

/// SHA-256 compression function that performs 64 rounds of operations
/// #### Arguments
/// * `w` - Message schedule (expanded message block)
/// * `i` - Current round index
/// * `k` - SHA-256 round constants
/// * `h` - Current hash state
/// #### Returns
/// * `Span<u32>` - Updated hash state after compression
fn compression(w: Span<u32>, i: usize, k: Span<u32>, mut h: Span<u32>) -> Span<u32> {
    if i >= 64 {
        return h;
    }
    let s1 = bsig1(*h[4]);
    let ch = ch(*h[4], *h[5], *h[6]);
    let (tmp, _) = (*h[7]).overflowing_add(s1);
    let (tmp, _) = tmp.overflowing_add(ch);
    let (tmp, _) = tmp.overflowing_add(*k[i]);
    let (temp1, _) = tmp.overflowing_add(*w[i]);
    let s0 = bsig0(*h[0]);
    let maj = maj(*h[0], *h[1], *h[2]);
    let (temp2, _) = s0.overflowing_add(maj);
    let mut t = array![];
    let (temp3, _) = temp1.overflowing_add(temp2);
    t.append(temp3);
    t.append(*h[0]);
    t.append(*h[1]);
    t.append(*h[2]);
    let (temp3, _) = (*h[3]).overflowing_add(temp1);
    t.append(temp3);
    t.append(*h[4]);
    t.append(*h[5]);
    t.append(*h[6]);
    h = t.span();
    compression(w, i + 1, k, h)
}

/// Creates the 64-word message schedule from a 16-word input block
/// #### Arguments
/// * `data` - Input data as u32 array
/// * `i` - Current block index
/// #### Returns
/// * `Span<u32>` - 64-word message schedule for compression
fn create_message_schedule(data: Span<u32>, i: usize) -> Span<u32> {
    let mut j = 0;
    let mut result = array![];
    while (j < 16) {
        result.append(*data[i * 16 + j]);
        j += 1;
    }
    let mut i = 16;
    while (i < 64) {
        let s0 = ssig0(*result[i - 15]);
        let s1 = ssig1(*result[i - 2]);

        let (tmp, _) = (*result[i - 16]).overflowing_add(s0);
        let (tmp, _) = tmp.overflowing_add(*result[i - 7]);
        let (res, _) = tmp.overflowing_add(s1);
        result.append(res);
        i += 1;
    }
    result.span()
}

/// Converts an array of u8 bytes to u32 values in big-endian format
/// #### Arguments
/// * `data` - Span of u8 bytes to convert
/// #### Returns
/// * `Array<u32>` - Array of u32 values in big-endian order
fn from_u8Array_to_u32Array(mut data: Span<u8>) -> Array<u32> {
    let mut result = array![];
    while let Option::Some(val1) = data.pop_front() {
        let val2 = data.pop_front().unwrap();
        let val3 = data.pop_front().unwrap();
        let val4 = data.pop_front().unwrap();
        let mut value = (*val1).into() * 0x1000000;
        value = value + (*val2).into() * 0x10000;
        value = value + (*val3).into() * 0x100;
        value = value + (*val4).into();
        result.append(value);
    }
    result
}

const h: [u32; 8] = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
];

const k: [u32; 64] = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
];
