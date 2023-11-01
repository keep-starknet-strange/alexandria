use alexandria_data_structures::byte_appender::ByteAppender;
use alexandria_data_structures::byte_reader::{ByteReader, ByteReaderState};
use integer::{u32_wrapping_add, BoundedInt};
use traits::DivRem;
use traits::Into;

#[inline]
fn sha256<T, +Drop<T>, +ByteReader<T>, +IndexView<T, usize, @u8>>(data: T) -> Array<u8> {
    let mut reader = data.reader();
    let result = reader.sha256();
    result.bytes()
}

#[generate_trait]
impl Sha256Impl<T, +Drop<T>, +ByteReader<T>, +IndexView<T, usize, @u8>> of Sha256Trait<T> {
    #[inline]
    fn sha256(self: @T) -> Sha256 {
        let mut reader = self.reader();
        reader.sha256()
    }
}

#[derive(Drop)]
enum Sha256Block {
    Block: Array<u32>,
    Fin: Array<u32>,
    BlockAndFin: (Array<u32>, Array<u32>),
}

#[generate_trait]
impl Sha256ByteReaderImpl<
    T, +Drop<T>, +ByteReader<T>, +IndexView<T, usize, @u8>
> of Sha256ByteReaderTrait<T> {
    fn sha256(ref self: ByteReaderState<T>) -> Sha256 {
        let length = self.len();
        let k = get_k().span();
        let mut state = Sha256StateTrait::init();
        loop {
            match self.sha256_block() {
                Sha256Block::Block(mut block) => {
                    block.extend();
                    state.compress_and_mix(block.span(), k);
                },
                Sha256Block::Fin(mut fin) => {
                    fin.append_length(length);
                    fin.extend();
                    state.compress_and_mix(fin.span(), k);
                    break state;
                },
                Sha256Block::BlockAndFin((
                    mut block, mut fin
                )) => {
                    block.extend();
                    state.compress_and_mix(block.span(), k);
                    fin.append_length(length);
                    fin.extend();
                    state.compress_and_mix(fin.span(), k);
                    break state;
                },
            }
        }
    }

    #[inline]
    fn sha256_block(ref self: ByteReaderState<T>) -> Sha256Block {
        let mut result: Array<u32> = array![];
        let bytes_remaining: usize = self.len();
        if bytes_remaining > 64 { // happy path :)
            self.read_full_words(16, ref result);
            Sha256Block::Block(result)
        } else { // bytes_remaining 0...64
            let (q, r) = DivRem::div_rem(bytes_remaining, 4_usize.try_into().unwrap());
            self.read_full_words(q, ref result);
            if result.len() == 16 { // bytes_remaining == 64
                let mut padded: Array<u32> = array![];
                padded_block(ref padded, terminate: true);
                Sha256Block::BlockAndFin((result, padded))
            } else {
                let last = self.final_sha256_word(r);
                result.append(last);
                if result.len() < 15 {
                    let mut i = result.len();
                    loop {
                        if i == 14 {
                            break;
                        }
                        result.append(0);
                        i += 1;
                    };
                    Sha256Block::Fin(result)
                } else { // result.len() == 15
                    result.append(0);
                    let mut padded: Array<u32> = array![];
                    padded_block(ref padded, terminate: false);
                    Sha256Block::BlockAndFin((result, padded))
                }
            }
        }
    }

    #[inline(always)]
    fn sha256_word(ref self: ByteReaderState<T>) -> u32 {
        let result: u32 = (*self.data[self.index]).into() * 0x1000000
            + (*self.data[self.index + 1]).into() * 0x10000
            + (*self.data[self.index + 2]).into() * 0x100
            + (*self.data[self.index + 3]).into();
        self.index += 4;
        result
    }

    #[inline]
    fn final_sha256_word(ref self: ByteReaderState<T>, remains: usize) -> u32 {
        assert(remains < 4, 'should be remainder');
        if remains > 1 {
            if remains == 3 {
                let result: u32 = (*self.data[self.index]).into() * 0x1000000
                    + (*self.data[self.index + 1]).into() * 0x10000
                    + (*self.data[self.index + 2]).into() * 0x100;
                self.index += 3;
                result + 0x80
            } else { // remains == 2
                let result: u32 = (*self.data[self.index]).into() * 0x1000000
                    + (*self.data[self.index + 1]).into() * 0x10000;
                self.index += 2;
                result + 0x8000
            }
        } else {
            if remains == 1 {
                let result: u32 = (*self.data[self.index]).into() * 0x1000000;
                self.index += 1;
                result + 0x800000
            } else { // remains == 0
                0x80000000
            }
        }
    }

    #[inline]
    fn read_full_words(ref self: ByteReaderState<T>, count: usize, ref result: Array<u32>) {
        let stop = self.index + count * 4;
        loop {
            if self.index == stop {
                break;
            }
            result.append(self.sha256_word());
        }
    }
}

#[derive(Copy, Drop)]
struct Sha256 {
    h0: u32,
    h1: u32,
    h2: u32,
    h3: u32,
    h4: u32,
    h5: u32,
    h6: u32,
    h7: u32,
}

#[generate_trait]
impl Sha256StateImpl of Sha256StateTrait {
    #[inline]
    fn init() -> Sha256 {
        Sha256 {
            h0: 0x6a09e667,
            h1: 0xbb67ae85,
            h2: 0x3c6ef372,
            h3: 0xa54ff53a,
            h4: 0x510e527f,
            h5: 0x9b05688c,
            h6: 0x1f83d9ab,
            h7: 0x5be0cd19,
        }
    }

    #[inline]
    fn extend(ref self: Array<u32>) {
        let mut i = 16;
        loop {
            if i >= 64 {
                break;
            }
            let s0 = ssig0(*self[i - 15]);
            let s1 = ssig1(*self[i - 2]);
            let res = u32_wrapping_add(
                u32_wrapping_add(u32_wrapping_add(*self[i - 16], s0), *self[i - 7]), s1
            );
            self.append(res);
            i += 1;
        };
    }

    #[inline(always)]
    fn compress_and_mix(ref self: Sha256, schedule: Span<u32>, k: Span<u32>) {
        let prev = @self;
        self.compress(schedule, k);
        self.mix(prev);
    }

    #[inline]
    fn compress(ref self: Sha256, schedule: Span<u32>, k: Span<u32>) {
        let mut i: usize = 0;
        loop {
            if i == 64 {
                break;
            }
            let s1 = bsig1(self.h4);
            let ch = ch(self.h4, self.h5, self.h6);
            let temp1 = u32_wrapping_add(
                u32_wrapping_add(u32_wrapping_add(u32_wrapping_add(self.h7, s1), ch), *k[i]),
                *schedule[i]
            );
            let s0 = bsig0(self.h0);
            let maj = maj(self.h0, self.h1, self.h2);
            let temp2 = u32_wrapping_add(s0, maj);
            self.h7 = self.h6;
            self.h6 = self.h5;
            self.h5 = self.h4;
            self.h4 = u32_wrapping_add(self.h3, temp1);
            self.h3 = self.h2;
            self.h2 = self.h1;
            self.h1 = self.h0;
            self.h0 = u32_wrapping_add(temp1, temp2);
            i += 1;
        };
    }

    #[inline(always)]
    fn mix(ref self: Sha256, with: @Sha256) {
        self.h0 = u32_wrapping_add(self.h0, *with.h0);
        self.h1 = u32_wrapping_add(self.h1, *with.h1);
        self.h2 = u32_wrapping_add(self.h2, *with.h2);
        self.h3 = u32_wrapping_add(self.h3, *with.h3);
        self.h4 = u32_wrapping_add(self.h4, *with.h4);
        self.h5 = u32_wrapping_add(self.h5, *with.h5);
        self.h6 = u32_wrapping_add(self.h6, *with.h6);
        self.h7 = u32_wrapping_add(self.h7, *with.h7);
    }

    #[inline(always)]
    fn append_length(ref self: Array<u32>, bytes: usize) {
        let (first, second) = sha256_length(bytes);
        self.append(first);
        self.append(second);
    }

    #[inline(always)]
    fn bytes(self: @Sha256) -> Array<u8> {
        let mut array = array![];
        self._bytes(ref array);
        array
    }

    #[inline(always)]
    fn _bytes(self: @Sha256, ref into: Array<u8>) {
        bytes_from_u32(self.h0, ref into);
        bytes_from_u32(self.h1, ref into);
        bytes_from_u32(self.h2, ref into);
        bytes_from_u32(self.h3, ref into);
        bytes_from_u32(self.h4, ref into);
        bytes_from_u32(self.h5, ref into);
        bytes_from_u32(self.h6, ref into);
        bytes_from_u32(self.h7, ref into);
    }

    #[inline(always)]
    fn u256(self: @Sha256) -> u256 {
        let high = (*self.h0).into() * 0x1000000000000000000000000_u128
            + (*self.h1).into() * 0x10000000000000000_u128
            + (*self.h2).into() * 0x100000000_u128
            + (*self.h3).into();
        let low = (*self.h4).into() * 0x1000000000000000000000000_u128
            + (*self.h5).into() * 0x10000000000000000_u128
            + (*self.h6).into() * 0x100000000_u128
            + (*self.h7).into();
        u256 { low, high }
    }
}

// sha256 functions
#[inline(always)]
fn ch(x: u32, y: u32, z: u32) -> u32 {
    (x & y) ^ ((x ^ BoundedInt::<u32>::max().into()) & z)
}

#[inline(always)]
fn maj(x: u32, y: u32, z: u32) -> u32 {
    (x & y) ^ (x & z) ^ (y & z)
}

#[inline(always)]
fn bsig0(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x4) | (x * 0x40000000);
    let x2 = (x / 0x2000) | (x * 0x80000);
    let x3 = (x / 0x400000) | (x * 0x400);
    let result = (x1 ^ x2 ^ x3) & BoundedInt::<u32>::max().into();
    result.try_into().unwrap()
}

#[inline(always)]
fn bsig1(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x40) | (x * 0x4000000);
    let x2 = (x / 0x800) | (x * 0x200000);
    let x3 = (x / 0x2000000) | (x * 0x80);
    let result = (x1 ^ x2 ^ x3) & BoundedInt::<u32>::max().into();
    result.try_into().unwrap()
}

#[inline(always)]
fn ssig0(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x80) | (x * 0x2000000);
    let x2 = (x / 0x40000) | (x * 0x4000);
    let x3 = (x / 0x8);
    let result = (x1 ^ x2 ^ x3) & BoundedInt::<u32>::max().into();
    result.try_into().unwrap()
}

#[inline(always)]
fn ssig1(x: u32) -> u32 {
    let x: u128 = x.into();
    let x1 = (x / 0x20000) | (x * 0x8000);
    let x2 = (x / 0x80000) | (x * 0x2000);
    let x3 = (x / 0x400);
    let result = (x1 ^ x2 ^ x3) & BoundedInt::<u32>::max().into();
    result.try_into().unwrap()
}

// helper functions
#[inline(always)]
fn bytes_from_u32(word: @u32, ref into: Array<u8>) {
    let (q, r) = DivRem::div_rem(*word, 0x1000000_u32.try_into().unwrap());
    into.append(q.try_into().unwrap());
    let (q, r) = DivRem::div_rem(r, 0x10000_u32.try_into().unwrap());
    into.append(q.try_into().unwrap());
    let (q, r) = DivRem::div_rem(r, 0x100_u32.try_into().unwrap());
    into.append(q.try_into().unwrap());
    into.append(r.try_into().unwrap());
}

#[inline]
fn padded_block(ref empty: Array<u32>, terminate: bool) {
    let count = if terminate {
        empty.append(0x80);
        13
    } else {
        14
    };
    let mut i = 0;
    loop {
        if i == count {
            assert(empty.len() == 14, 'should be 14');
            break;
        }
        empty.append(0);
        i += 1;
    }
}

#[inline(always)]
fn sha256_length(bytes: usize) -> (u32, u32) {
    let bit_length = bytes.into() * 8;
    let (q, r) = DivRem::div_rem(bit_length, 0x100000000_u64.try_into().unwrap());
    let first_big_endian = q.try_into().unwrap();
    let second_big_endian = r.try_into().unwrap();
    (first_big_endian, second_big_endian)
}

fn get_k() -> Array<u32> {
    array![
        0x428a2f98,
        0x71374491,
        0xb5c0fbcf,
        0xe9b5dba5,
        0x3956c25b,
        0x59f111f1,
        0x923f82a4,
        0xab1c5ed5,
        0xd807aa98,
        0x12835b01,
        0x243185be,
        0x550c7dc3,
        0x72be5d74,
        0x80deb1fe,
        0x9bdc06a7,
        0xc19bf174,
        0xe49b69c1,
        0xefbe4786,
        0x0fc19dc6,
        0x240ca1cc,
        0x2de92c6f,
        0x4a7484aa,
        0x5cb0a9dc,
        0x76f988da,
        0x983e5152,
        0xa831c66d,
        0xb00327c8,
        0xbf597fc7,
        0xc6e00bf3,
        0xd5a79147,
        0x06ca6351,
        0x14292967,
        0x27b70a85,
        0x2e1b2138,
        0x4d2c6dfc,
        0x53380d13,
        0x650a7354,
        0x766a0abb,
        0x81c2c92e,
        0x92722c85,
        0xa2bfe8a1,
        0xa81a664b,
        0xc24b8b70,
        0xc76c51a3,
        0xd192e819,
        0xd6990624,
        0xf40e3585,
        0x106aa070,
        0x19a4c116,
        0x1e376c08,
        0x2748774c,
        0x34b0bcb5,
        0x391c0cb3,
        0x4ed8aa4a,
        0x5b9cca4f,
        0x682e6ff3,
        0x748f82ee,
        0x78a5636f,
        0x84c87814,
        0x8cc70208,
        0x90befffa,
        0xa4506ceb,
        0xbef9a3f7,
        0xc67178f2
    ]
}
