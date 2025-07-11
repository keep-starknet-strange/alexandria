use alexandria_bytes::bit_array::one_shift_left_bytes_u128;
/// Bitcoin transaction decoder module
/// Provides functionality to decode raw Bitcoin transaction data

use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use crate::types::{
    BTCDecoder, BitcoinTransaction, TransactionInput, TransactionOutput, TransactionWitness,
};

/// Bitcoin transaction decoder trait providing methods to decode raw Bitcoin transaction data.
///
/// This trait implements the complete Bitcoin transaction format decoder, supporting both
/// legacy and SegWit transaction formats according to BIP 141. It handles variable-length
/// encoding (compact size), little-endian integer decoding, and proper transaction structure
/// parsing.
pub trait TransactionDecoderTrait {
    /// Creates a new Bitcoin transaction decoder from raw transaction data.
    ///
    /// #### Arguments
    /// * `data` - Raw Bitcoin transaction data as a ByteArray
    ///
    /// #### Returns
    /// * `BTCDecoder` - Initialized decoder context with offset set to 0
    fn new(data: ByteArray) -> BTCDecoder;

    /// Decodes a complete Bitcoin transaction from the current decoder context.
    ///
    /// Parses the entire transaction structure including version, inputs, outputs,
    /// witness data (if SegWit), and locktime. Automatically detects SegWit
    /// transactions by checking for the marker (0x00) and flag (0x01) bytes.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// #### Returns
    /// * `BitcoinTransaction` - Complete decoded transaction structure
    fn decode_transaction(ref self: BTCDecoder) -> BitcoinTransaction;

    /// Decodes a single Bitcoin transaction input from the current position.
    ///
    /// Parses input structure: previous TXID (32 bytes), previous output index,
    /// script signature with compact size length prefix, and sequence number.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// #### Returns
    /// * `TransactionInput` - Decoded input with all fields populated
    fn decode_input(ref self: BTCDecoder) -> TransactionInput;

    /// Decodes a single Bitcoin transaction output from the current position.
    ///
    /// Parses output structure: value (8 bytes, little-endian) and script public key
    /// with compact size length prefix.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// #### Returns
    /// * `TransactionOutput` - Decoded output with value and script
    fn decode_output(ref self: BTCDecoder) -> TransactionOutput;

    /// Decodes SegWit witness data for a single input.
    ///
    /// Parses witness stack structure: witness item count (compact size) followed
    /// by each witness item with its length prefix and data.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// #### Returns
    /// * `TransactionWitness` - Decoded witness data with all stack items
    fn decode_witness(ref self: BTCDecoder) -> TransactionWitness;

    /// Reads a Bitcoin compact size integer (variable-length encoding).
    ///
    /// Implements Bitcoin's compact size encoding:
    /// - < 0xfd: 1 byte value
    /// - 0xfd: 3 bytes (1 + 2 little-endian)
    /// - 0xfe: 5 bytes (1 + 4 little-endian)
    /// - 0xff: 9 bytes (1 + 8 little-endian)
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// #### Returns
    /// * `u64` - The decoded integer value
    fn read_compact_size(ref self: BTCDecoder) -> u64;

    /// Reads a single byte from the current position.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// #### Returns
    /// * `u8` - The byte value at the current position
    fn read_u8(ref self: BTCDecoder) -> u8;

    /// Reads 4 bytes as a little-endian unsigned 32-bit integer.
    ///
    /// ####### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// ####### Returns
    /// * `u32` - The decoded little-endian u32 value
    ///
    /// #### Panics
    /// Panics with 'Not enough bytes for u32' if fewer than 4 bytes remain.
    fn read_u32_le(ref self: BTCDecoder) -> u32;

    /// Reads 8 bytes as a little-endian unsigned 64-bit integer.
    ///
    /// ####### Arguments
    /// * `self` - Mutable reference to the decoder context
    ///
    /// ####### Returns
    /// * `u64` - The decoded little-endian u64 value
    ///
    /// ##### Panics
    /// Panics with 'Not enough bytes for u64' if fewer than 8 bytes remain.
    fn read_u64_le(ref self: BTCDecoder) -> u64;

    /// Checks if there are sufficient bytes remaining to read from the specified offset.
    ///
    /// ####### Arguments
    /// * `self` - Reference to the decoder context
    /// * `offset` - The offset position to check from
    /// * `count` - Number of bytes needed
    ///
    /// ####### Returns
    /// * `bool` - True if sufficient bytes remain, false otherwise
    fn remaining(self: @BTCDecoder, offset: usize, count: usize) -> bool;
}

/// Implementation of the Bitcoin transaction decoder trait.
///
/// Provides concrete implementations for all Bitcoin transaction decoding operations,
/// including support for both legacy and SegWit transaction formats.
pub impl TransactionDecoderImpl of TransactionDecoderTrait {
    fn new(data: ByteArray) -> BTCDecoder {
        BTCDecoder { data, offset: 0 }
    }

    fn decode_transaction(ref self: BTCDecoder) -> BitcoinTransaction {
        // Read version (4 bytes, little-endian)
        let version = self.read_u32_le();

        // Check for SegWit marker and flag
        let mut is_segwit = false;
        if self.offset < self.data.len() {
            let (_, marker) = self.data.read_u8(self.offset);
            if marker == 0x00 && self.offset + 1 < self.data.len() {
                let (_, flag) = self.data.read_u8(self.offset + 1);
                if flag == 0x01 {
                    // This is a SegWit transaction
                    is_segwit = true;
                    self.offset += 2; // Skip marker and flag
                }
            }
        }

        // Read input count (compact size)
        let input_count = self.read_compact_size();

        // Decode inputs
        let mut inputs = array![];
        let mut i = 0_u64;
        while i < input_count {
            inputs.append(self.decode_input());
            i += 1;
        }

        // Read output count (compact size)
        let output_count = self.read_compact_size();

        // Decode outputs
        let mut outputs = array![];
        let mut i = 0_u64;
        while i < output_count {
            outputs.append(self.decode_output());
            i += 1;
        }

        // Decode witness data if SegWit
        let mut witness = array![];
        if is_segwit {
            let mut i = 0_u32;
            while i < inputs.len() {
                witness.append(self.decode_witness());
                i += 1;
            }
        }

        // Read locktime (4 bytes, little-endian)
        let locktime = self.read_u32_le();

        BitcoinTransaction { version, inputs, outputs, locktime, witness, is_segwit }
    }

    fn decode_input(ref self: BTCDecoder) -> TransactionInput {
        // Read previous transaction hash (32 bytes, reversed)
        let (new_offset, previous_txid) = self.data.read_bytes(self.offset, 32);
        self.offset = new_offset;

        // Read previous output index (4 bytes, little-endian)
        let previous_vout = self.read_u32_le();

        // Read script signature length (compact size)
        let script_sig_len = self.read_compact_size();

        // Read script signature
        let (new_offset, script_sig) = self
            .data
            .read_bytes(self.offset, script_sig_len.try_into().unwrap());
        self.offset = new_offset;

        // Read sequence (4 bytes, little-endian)
        let sequence = self.read_u32_le();

        TransactionInput { previous_txid, previous_vout, script_sig, sequence }
    }

    fn decode_output(ref self: BTCDecoder) -> TransactionOutput {
        // Read value (8 bytes, little-endian)
        let value = self.read_u64_le();

        // Read script public key length (compact size)
        let script_pubkey_len = self.read_compact_size();

        // Read script public key
        let (new_offset, script_pubkey) = self
            .data
            .read_bytes(self.offset, script_pubkey_len.try_into().unwrap());
        self.offset = new_offset;

        TransactionOutput { value, script_pubkey }
    }

    fn decode_witness(ref self: BTCDecoder) -> TransactionWitness {
        // Read witness stack item count (compact size)
        let witness_count = self.read_compact_size();

        let mut witness_stack = array![];
        let mut i = 0_u64;
        while i < witness_count {
            // Read witness item length (compact size)
            let item_len = self.read_compact_size();

            // Read witness item data
            let (new_offset, item_data) = self
                .data
                .read_bytes(self.offset, item_len.try_into().unwrap());
            self.offset = new_offset;
            witness_stack.append(item_data);

            i += 1;
        }

        TransactionWitness { witness_stack }
    }

    /// Read Bitcoin compact size (variable length integer)
    fn read_compact_size(ref self: BTCDecoder) -> u64 {
        let first_byte = self.read_u8();

        if first_byte < 0xfd {
            // 1 byte
            first_byte.into()
        } else if first_byte == 0xfd {
            // 3 bytes total (1 + 2) - read as little-endian u16
            let b0: u64 = self.read_u8().into();
            let b1: u64 = self.read_u8().into();
            b0 + (b1 * 256)
        } else if first_byte == 0xfe {
            // 5 bytes total (1 + 4) - read as little-endian u32
            self.read_u32_le().into()
        } else {
            // 9 bytes total (1 + 8) - read as little-endian u64
            self.read_u64_le()
        }
    }

    /// Read a single byte
    fn read_u8(ref self: BTCDecoder) -> u8 {
        let (new_offset, byte) = self.data.read_u8(self.offset);
        self.offset = new_offset;
        byte
    }

    /// Read 4 bytes as little-endian u32
    #[inline]
    fn read_u32_le(ref self: BTCDecoder) -> u32 {
        assert(self.remaining(self.offset, 4), 'Not enough bytes for u32');

        let b0: u32 = self.data.at(self.offset).unwrap().into();
        let b1: u32 = self.data.at(self.offset + 1).unwrap().into();
        let b2: u32 = self.data.at(self.offset + 2).unwrap().into();
        let b3: u32 = self.data.at(self.offset + 3).unwrap().into();
        self.offset += 4;

        b0
            + (b1 * one_shift_left_bytes_u128(1).try_into().unwrap())
            + (b2 * one_shift_left_bytes_u128(2).try_into().unwrap())
            + (b3 * one_shift_left_bytes_u128(3).try_into().unwrap())
    }

    /// Read 8 bytes as little-endian u64
    #[inline]
    fn read_u64_le(ref self: BTCDecoder) -> u64 {
        assert(self.remaining(self.offset, 8), 'Not enough bytes for u64');

        let b0: u64 = self.data.at(self.offset).unwrap().into();
        let b1: u64 = self.data.at(self.offset + 1).unwrap().into();
        let b2: u64 = self.data.at(self.offset + 2).unwrap().into();
        let b3: u64 = self.data.at(self.offset + 3).unwrap().into();
        let b4: u64 = self.data.at(self.offset + 4).unwrap().into();
        let b5: u64 = self.data.at(self.offset + 5).unwrap().into();
        let b6: u64 = self.data.at(self.offset + 6).unwrap().into();
        let b7: u64 = self.data.at(self.offset + 7).unwrap().into();
        self.offset += 8;

        b0
            + (b1 * one_shift_left_bytes_u128(1).try_into().unwrap())
            + (b2 * one_shift_left_bytes_u128(2).try_into().unwrap())
            + (b3 * one_shift_left_bytes_u128(3).try_into().unwrap())
            + (b4 * one_shift_left_bytes_u128(4).try_into().unwrap())
            + (b5 * one_shift_left_bytes_u128(5).try_into().unwrap())
            + (b6 * one_shift_left_bytes_u128(6).try_into().unwrap())
            + (b7 * one_shift_left_bytes_u128(7).try_into().unwrap())
    }

    /// Check if there are enough remaining bytes to read
    #[inline]
    fn remaining(self: @BTCDecoder, offset: usize, count: usize) -> bool {
        offset + count <= self.data.len()
    }
}

