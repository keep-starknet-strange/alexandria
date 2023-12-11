//! Naive implementation of `Store` trait for `ByteArray`.
//!
//! The idea in this implementation is to store the `ByteArray`
//! data by hashing a key for each element of it.
//!
//! 1. First, the `data.len()` value is stored at the given base address.
//! 2. The `pending_word` is stored computing a key with `PENDING_WORD_KEY`.
//! 3. The `pending_word_len` is stored computing a key with `PENDING_WORD_LEN_KEY`.
//! 4. For each element of data, the key is computed using the index of the element in the array.
//!
use core::ByteArray;
use core::hash::LegacyHash;
use starknet::{
    storage_read_syscall, storage_write_syscall, storage_base_address_from_felt252,
    storage_address_to_felt252, storage_address_from_base, storage_address_from_base_and_offset,
    SyscallResult, SyscallResultTrait, StorageBaseAddress, Store,
};

const ADDRESS_DOMAIN: u32 = 0;
const BYTE_ARRAY_KEY: felt252 = '__BYTE_ARRAY__';
const PENDING_WORD_KEY: felt252 = '__PENDING_WORD__';
const PENDING_WORD_LEN_KEY: felt252 = '__PENDING_WORD_LEN__';

/// Implementation of `LegacyHash` for `ByteArray`.
/// The hash is given by the poseidon hash of the `data` and `pending_word` fields.
impl LegacyHashByteArray of LegacyHash<ByteArray> {
    fn hash(state: felt252, value: ByteArray) -> felt252 {
        let mut buffer = array![value.pending_word];

        let mut index = 0;

        loop {
            if index == value.data.len() {
                break;
            }

            buffer.append((*value.data[index]).into());

            index += 1;
        };

        poseidon::poseidon_hash_span(buffer.span())
    }
}

/// Computes a storage address based on the given key.
///
/// # Arguments
///
/// * `base` - The base storage address (usually given by the name of the field in storage).
/// * `key` - The custom key to add in a pre-defined array on which poseidon hash is computed.
fn compute_storage_address(base: StorageBaseAddress, key: felt252) -> StorageBaseAddress {
    let storage_addr = storage_address_to_felt252(storage_address_from_base(base));
    let elt_keys: Array<felt252> = array![BYTE_ARRAY_KEY, storage_addr, key];

    storage_base_address_from_felt252(poseidon::poseidon_hash_span(elt_keys.span()))
}

impl StoreByteArray of Store<ByteArray> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<ByteArray> {
        StoreByteArray::read_at_offset(address_domain, base, 0)
    }

    fn write(address_domain: u32, base: StorageBaseAddress, value: ByteArray) -> SyscallResult<()> {
        StoreByteArray::write_at_offset(address_domain, base, 0, value)
    }

    fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8
    ) -> SyscallResult<ByteArray> {
        let data_len: usize = storage_read_syscall(
            address_domain, storage_address_from_base_and_offset(base, offset)
        )
            .unwrap_syscall()
            .try_into()
            .expect('data len out of range');

        let pw_base = compute_storage_address(base, PENDING_WORD_KEY);
        let pending_word = storage_read_syscall(address_domain, storage_address_from_base(pw_base))
            .unwrap_syscall();

        let pwl_base = compute_storage_address(base, PENDING_WORD_LEN_KEY);
        let pending_word_len: usize = storage_read_syscall(
            address_domain, storage_address_from_base(pwl_base)
        )
            .unwrap_syscall()
            .try_into()
            .expect('pending_word_len out of range');

        if data_len == 0 {
            return Result::Ok(ByteArray { data: array![], pending_word, pending_word_len, });
        }

        let mut data: Array<bytes31> = array![];
        let mut index = 0;

        loop {
            if index == data_len {
                break ();
            }

            let elt_base = compute_storage_address(base, index.into());

            data
                .append(
                    storage_read_syscall(ADDRESS_DOMAIN, storage_address_from_base(elt_base))
                        .unwrap_syscall()
                        .try_into()
                        .expect('invalid bytes31 data')
                );

            index += 1;
        };

        Result::Ok(ByteArray { data, pending_word, pending_word_len, })
    }

    fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8, value: ByteArray
    ) -> SyscallResult<()> {
        // data len
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, offset),
            value.data.len().into()
        )
            .unwrap_syscall();

        // pending word
        let pw_base = compute_storage_address(base, PENDING_WORD_KEY);
        storage_write_syscall(
            address_domain, storage_address_from_base(pw_base), value.pending_word
        )
            .unwrap_syscall();

        // pending word len
        let pwl_base = compute_storage_address(base, PENDING_WORD_LEN_KEY);
        storage_write_syscall(
            address_domain, storage_address_from_base(pwl_base), value.pending_word_len.into()
        )
            .unwrap_syscall();

        if value.data.len() == 0 {
            return Result::Ok(());
        }

        // For each felt in data -> re-compute a key with the base address and the index.
        let mut index = 0;

        loop {
            if index == value.data.len() {
                break;
            }

            let elt: felt252 = (*value.data[index]).into();
            let elt_base = compute_storage_address(base, index.into());

            storage_write_syscall(ADDRESS_DOMAIN, storage_address_from_base(elt_base), elt,)
                .unwrap_syscall();

            index += 1;
        };

        Result::Ok(())
    }

    #[inline(always)]
    fn size() -> u8 {
        // We consider the only data at the given offset, which
        // is 1 felt long. The other ones are retrieved by
        // hash derivation from the storage address.
        //
        // TODO: is that ok? to be checked during review.
        1_u8
    }
}
