use alexandria_bytes::utils::u256_reverse_endian;
use alexandria_math::U256BitShift;
use core::keccak::compute_keccak_byte_array;

#[generate_trait]
pub impl SelectorImpl of SelectorTrait {
    /// Computes the EVM function selector (first 4 bytes of the Keccak-256 hash of a function
    /// signature).
    ///
    /// #### Arguments
    /// * `self` - A `ByteArray` containing the UTF-8 string of the function signature, e.g.,
    /// `"transfer(address,uint256)"`.
    ///
    /// #### Returns
    /// * `felt252` - The 4-byte (32-bit) selector represented as a `felt252` value.
    fn compute_selector(self: ByteArray) -> felt252 {
        let cairo_hash = compute_keccak_byte_array(@self);
        // Reconstruct the u256 in EVM's big-endian layout
        let evm_hash = u256_reverse_endian(cairo_hash);
        let selector = U256BitShift::shr(evm_hash, 224);
        selector.try_into().expect('Couldn\'t convert to felt252')
    }
}
