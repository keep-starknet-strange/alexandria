/// Bitcoin transaction encoder module
/// Provides functionality to encode structured Bitcoin transaction data into raw bytes

use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use crate::types::{
    BTCEncoder, BitcoinTransaction, TransactionInput, TransactionOutput, TransactionWitness,
};

/// Bitcoin transaction encoder trait providing methods to encode transaction data to raw bytes.
///
/// This trait implements the complete Bitcoin transaction format encoder, supporting both
/// legacy and SegWit transaction formats according to BIP 141. It handles variable-length
/// encoding (compact size), little-endian integer encoding, and proper transaction structure
/// serialization.
pub trait TransactionEncoderTrait {
    /// Creates a new Bitcoin transaction encoder with an empty ByteArray.
    ///
    /// #### Returns
    /// * `BTCEncoder` - Initialized encoder context with empty data buffer
    fn new() -> BTCEncoder;

    /// Encodes a complete Bitcoin transaction to raw bytes.
    ///
    /// Serializes the entire transaction structure including version, inputs, outputs,
    /// witness data (if SegWit), and locktime. Automatically includes SegWit
    /// marker (0x00) and flag (0x01) bytes for SegWit transactions.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `transaction` - Complete Bitcoin transaction structure to encode
    ///
    /// #### Returns
    /// * `ByteArray` - Raw transaction bytes ready for broadcast
    fn encode_transaction(ref self: BTCEncoder, transaction: BitcoinTransaction) -> ByteArray;

    /// Encodes a single Bitcoin transaction input to the current position.
    ///
    /// Serializes input structure: previous TXID (32 bytes), previous output index,
    /// script signature with compact size length prefix, and sequence number.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `input` - Transaction input to encode
    fn encode_input(ref self: BTCEncoder, input: TransactionInput);

    /// Encodes a single Bitcoin transaction output to the current position.
    ///
    /// Serializes output structure: value (8 bytes, little-endian) and script public key
    /// with compact size length prefix.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `output` - Transaction output to encode
    fn encode_output(ref self: BTCEncoder, output: TransactionOutput);

    /// Encodes SegWit witness data for a single input.
    ///
    /// Serializes witness stack structure: witness item count (compact size) followed
    /// by each witness item with its length prefix and data.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `witness` - Witness data to encode
    fn encode_witness(ref self: BTCEncoder, witness: TransactionWitness);

    /// Writes a Bitcoin compact size integer (variable-length encoding).
    ///
    /// Implements Bitcoin's compact size encoding:
    /// - < 0xfd: 1 byte value
    /// - 0xfd: 3 bytes (1 + 2 little-endian)
    /// - 0xfe: 5 bytes (1 + 4 little-endian)
    /// - 0xff: 9 bytes (1 + 8 little-endian)
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `value` - The integer value to encode
    fn write_compact_size(ref self: BTCEncoder, value: u64);

    /// Writes a single byte to the current position.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `value` - The byte value to write
    fn write_u8(ref self: BTCEncoder, value: u8);

    /// Writes a 32-bit unsigned integer as little-endian bytes.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `value` - The u32 value to encode
    fn write_u32_le(ref self: BTCEncoder, value: u32);

    /// Writes a 64-bit unsigned integer as little-endian bytes.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `value` - The u64 value to encode
    fn write_u64_le(ref self: BTCEncoder, value: u64);

    /// Writes raw bytes to the current position.
    ///
    /// #### Arguments
    /// * `self` - Mutable reference to the encoder context
    /// * `bytes` - The ByteArray to append
    fn write_bytes(ref self: BTCEncoder, bytes: ByteArray);
}

/// Implementation of the Bitcoin transaction encoder trait.
///
/// Provides concrete implementations for all Bitcoin transaction encoding operations,
/// including support for both legacy and SegWit transaction formats.
pub impl TransactionEncoderImpl of TransactionEncoderTrait {
    fn new() -> BTCEncoder {
        BTCEncoder { data: Default::default() }
    }

    fn encode_transaction(ref self: BTCEncoder, transaction: BitcoinTransaction) -> ByteArray {
        // Write version (4 bytes, little-endian)
        self.write_u32_le(transaction.version);

        // Write SegWit marker and flag if this is a SegWit transaction
        if transaction.is_segwit {
            self.write_u8(0x00); // Marker
            self.write_u8(0x01); // Flag
        }

        // Write input count (compact size)
        self.write_compact_size(transaction.inputs.len().into());

        // Encode inputs
        let mut i = 0_u32;
        while i < transaction.inputs.len() {
            self.encode_input(transaction.inputs.at(i).clone());
            i += 1;
        }

        // Write output count (compact size)
        self.write_compact_size(transaction.outputs.len().into());

        // Encode outputs
        let mut i = 0_u32;
        while i < transaction.outputs.len() {
            self.encode_output(transaction.outputs.at(i).clone());
            i += 1;
        }

        // Encode witness data if SegWit
        if transaction.is_segwit {
            let mut i = 0_u32;
            while i < transaction.witness.len() {
                self.encode_witness(transaction.witness.at(i).clone());
                i += 1;
            }
        }

        // Write locktime (4 bytes, little-endian)
        self.write_u32_le(transaction.locktime);

        self.data.clone()
    }

    fn encode_input(ref self: BTCEncoder, input: TransactionInput) {
        // Write previous transaction hash (32 bytes)
        self.write_bytes(input.previous_txid);

        // Write previous output index (4 bytes, little-endian)
        self.write_u32_le(input.previous_vout);

        // Write script signature length (compact size)
        self.write_compact_size(input.script_sig.len().into());

        // Write script signature
        self.write_bytes(input.script_sig);

        // Write sequence (4 bytes, little-endian)
        self.write_u32_le(input.sequence);
    }

    fn encode_output(ref self: BTCEncoder, output: TransactionOutput) {
        // Write value (8 bytes, little-endian)
        self.write_u64_le(output.value);

        // Write script public key length (compact size)
        self.write_compact_size(output.script_pubkey.len().into());

        // Write script public key
        self.write_bytes(output.script_pubkey);
    }

    fn encode_witness(ref self: BTCEncoder, witness: TransactionWitness) {
        // Write witness stack item count (compact size)
        self.write_compact_size(witness.witness_stack.len().into());

        let mut i = 0_u32;
        while i < witness.witness_stack.len() {
            let item = witness.witness_stack.at(i).clone();

            // Write witness item length (compact size)
            self.write_compact_size(item.len().into());

            // Write witness item data
            self.write_bytes(item);

            i += 1;
        }
    }

    fn write_compact_size(ref self: BTCEncoder, value: u64) {
        if value < 0xfd {
            // 1 byte
            self.write_u8(value.try_into().unwrap());
        } else if value <= 0xffff {
            // 3 bytes total (1 + 2) - write as little-endian u16
            self.write_u8(0xfd);
            self.data.append_u16_le(value.try_into().unwrap());
        } else if value <= 0xffffffff {
            // 5 bytes total (1 + 4) - write as little-endian u32
            self.write_u8(0xfe);
            self.write_u32_le(value.try_into().unwrap());
        } else {
            // 9 bytes total (1 + 8) - write as little-endian u64
            self.write_u8(0xff);
            self.write_u64_le(value);
        }
    }

    fn write_u8(ref self: BTCEncoder, value: u8) {
        self.data.append_byte(value);
    }

    fn write_u32_le(ref self: BTCEncoder, value: u32) {
        self.data.append_u32_le(value);
    }

    fn write_u64_le(ref self: BTCEncoder, value: u64) {
        self.data.append_u64_le(value);
    }

    fn write_bytes(ref self: BTCEncoder, bytes: ByteArray) {
        self.data.append(@bytes);
    }
}
