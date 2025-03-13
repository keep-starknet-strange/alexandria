use alexandria_bytes::bytes::{BYTES_PER_ELEMENT, Bytes, BytesTrait};
use core::num::traits::CheckedAdd;
use starknet::SyscallResult;
use starknet::storage_access::{
    StorageAddress, StorageBaseAddress, Store, storage_address_from_base,
    storage_address_from_base_and_offset, storage_base_address_from_felt252,
};

/// Store for a `Bytes` object.
///
/// The layout of a `Bytes` object in storage is as follows:
/// * Only the size in bytes is stored in the original address where the
///   bytes object is stored.
/// * The actual data is stored in chunks of 256 `u128` values in another location
///   in storage determined by the hash of:
///   - The address storing the size of the bytes object.
///   - The chunk index.
///   - The short string `Bytes`.
pub impl BytesStore of Store<Bytes> {
    #[inline(always)]
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<Bytes> {
        inner_read_bytes(address_domain, storage_address_from_base(base))
    }
    #[inline(always)]
    fn write(address_domain: u32, base: StorageBaseAddress, value: Bytes) -> SyscallResult<()> {
        inner_write_bytes(address_domain, storage_address_from_base(base), value)
    }
    #[inline(always)]
    fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8,
    ) -> SyscallResult<Bytes> {
        inner_read_bytes(address_domain, storage_address_from_base_and_offset(base, offset))
    }
    #[inline(always)]
    fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8, value: Bytes,
    ) -> SyscallResult<()> {
        inner_write_bytes(address_domain, storage_address_from_base_and_offset(base, offset), value)
    }
    #[inline(always)]
    fn size() -> u8 {
        1
    }
}

/// Returns a pointer to the `chunk`'th of the Bytes object at `address`.
/// The pointer is the `Poseidon` hash of:
/// * `address` - The address of the Bytes object (where the size is stored).
/// * `chunk` - The index of the chunk.
/// * The short string `Bytes` is used as the capacity argument of the sponge
///   construction (domain separation).
fn inner_bytes_pointer(address: StorageAddress, chunk: felt252) -> StorageBaseAddress {
    let (r, _, _) = core::poseidon::hades_permutation(address.into(), chunk, 'Bytes');
    storage_base_address_from_felt252(r)
}

/// Reads a bytes from storage from domain `address_domain` and address `address`.
/// The length of the bytes is read from `address` at domain `address_domain`.
/// For more info read the documentation of `BytesStore`.
fn inner_read_bytes(address_domain: u32, address: StorageAddress) -> SyscallResult<Bytes> {
    let size: usize =
        match starknet::syscalls::storage_read_syscall(address_domain, address)?.try_into() {
        Option::Some(x) => x,
        Option::None => { return SyscallResult::Err(array!['Invalid Bytes size']); },
    };
    let (mut remaining_full_words, last_word_len) = DivRem::div_rem(
        size, BYTES_PER_ELEMENT.try_into().unwrap(),
    );
    let mut chunk = 0;
    let mut chunk_base = inner_bytes_pointer(address, chunk);
    let mut index_in_chunk = 0_u8;
    let mut data: Array<u128> = array![];
    loop {
        if remaining_full_words == 0 {
            break Result::Ok(());
        }
        let value =
            match starknet::syscalls::storage_read_syscall(
                address_domain, storage_address_from_base_and_offset(chunk_base, index_in_chunk),
            ) {
            Result::Ok(value) => value,
            Result::Err(err) => { break Result::Err(err); },
        };
        let value: u128 = match value.try_into() {
            Option::Some(x) => x,
            Option::None => { break Result::Err(array!['Invalid inner value']); },
        };
        data.append(value);
        remaining_full_words -= 1;

        match index_in_chunk.checked_add(1) {
            Option::Some(x) => { index_in_chunk = x; },
            Option::None => {
                chunk += 1;
                chunk_base = inner_bytes_pointer(address, chunk);
                index_in_chunk = 0;
            },
        }
    }?;
    if last_word_len != 0 {
        let last_word = starknet::syscalls::storage_read_syscall(
            address_domain, storage_address_from_base_and_offset(chunk_base, index_in_chunk),
        )?;
        data.append(last_word.try_into().expect('Invalid last word'));
    }
    Result::Ok(BytesTrait::new(size, data))
}

/// Writes a bytes to storage at domain `address_domain` and address `address`.
/// The length of the bytes is written to `address` at domain `address_domain`.
/// For more info read the documentation of `BytesStore`.
fn inner_write_bytes(
    address_domain: u32, address: StorageAddress, value: Bytes,
) -> SyscallResult<()> {
    let size = value.size();
    starknet::syscalls::storage_write_syscall(address_domain, address, size.into())?;
    let mut words = value.data().span();
    let mut chunk = 0;
    let mut chunk_base = inner_bytes_pointer(address, chunk);
    let mut index_in_chunk = 0_u8;
    loop {
        let curr_value = match words.pop_front() {
            Option::Some(x) => x,
            Option::None => { break Result::Ok(()); },
        };
        match starknet::syscalls::storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(chunk_base, index_in_chunk),
            (*curr_value).into(),
        ) {
            Result::Ok(_) => {},
            Result::Err(err) => { break Result::Err(err); },
        }

        match index_in_chunk.checked_add(1) {
            Option::Some(x) => { index_in_chunk = x; },
            Option::None => {
                chunk += 1;
                chunk_base = inner_bytes_pointer(address, chunk);
                index_in_chunk = 0;
            },
        }
    }?;
    Result::Ok(())
}
