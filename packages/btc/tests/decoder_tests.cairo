use alexandria_btc::decoder::TransactionDecoderTrait;
use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;

// Helper function for appending zeros
fn append_zeros(ref data: ByteArray, count: usize) {
    let mut i = 0_usize;
    while i < count {
        data.append_byte(0x00);
        i += 1;
    }
}

#[test]
fn test_compact_size_decoding() {
    // Test single byte compact size (< 0xfd)
    let mut data: ByteArray = Default::default();
    data.append_byte(0x42);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_compact_size();
    assert!(result == 0x42);

    // Test 3-byte compact size (0xfd + 2 bytes)
    let mut data: ByteArray = Default::default();
    data.append_byte(0xfd);
    data.append_u16_le(0x1234);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_compact_size();
    assert!(result == 0x1234);

    // Test 5-byte compact size (0xfe + 4 bytes)
    let mut data: ByteArray = Default::default();
    data.append_byte(0xfe);
    data.append_u32_le(0x12345678);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_compact_size();
    assert!(result == 0x12345678);
}

#[test]
fn test_u32_le_reading() {
    let mut data: ByteArray = Default::default();
    data.append_u32_le(0x12345678);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_u32_le();
    assert!(result == 0x12345678);
}

#[test]
fn test_u64_le_reading() {
    let mut data: ByteArray = Default::default();
    data.append_u64_le(0x1122334455667788);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_u64_le();
    assert!(result == 0x1122334455667788);
}

#[test]
fn test_legacy_transaction_decoding() {
    // Simple legacy transaction with 1 input, 1 output
    // Version: 0x01000000 (little-endian)
    // Input count: 0x01
    // Input:
    //   - Previous txid: 32 bytes of 0x00
    //   - Previous vout: 0x00000000
    //   - Script sig length: 0x00
    //   - Sequence: 0xffffffff
    // Output count: 0x01
    // Output:
    //   - Value: 0x0100000000000000 (1 satoshi)
    //   - Script pubkey length: 0x19 (25 bytes)
    //   - Script pubkey: 25 bytes (P2PKH script)
    // Locktime: 0x00000000

    // Build transaction data using ByteArrayExt little-endian methods
    let mut tx_data: ByteArray = Default::default();
    // Version (4 bytes, little-endian): 0x01000000
    tx_data.append_u32_le(1);
    // Input count: 0x01
    tx_data.append_byte(0x01);
    // Input: Previous txid (32 bytes of 0x00)
    append_zeros(ref tx_data, 32_usize);
    // Previous vout (4 bytes): 0x00000000
    tx_data.append_u32_le(0);
    // Script sig length: 0x00
    tx_data.append_byte(0x00);
    // Sequence (4 bytes): 0xffffffff
    tx_data.append_u32_le(0xffffffff);
    // Output count: 0x01
    tx_data.append_byte(0x01);
    // Output value (8 bytes): 0x0100000000000000 (1 satoshi)
    tx_data.append_u64_le(1);
    // Script pubkey length: 0x19 (25 bytes)
    tx_data.append_byte(0x19);
    // Script pubkey (25 bytes - P2PKH script)
    tx_data.append_byte(0x76);
    tx_data.append_byte(0xa9);
    tx_data.append_byte(0x14);
    append_zeros(ref tx_data, 20_usize);
    tx_data.append_byte(0x88);
    tx_data.append_byte(0xac);
    // Locktime (4 bytes): 0x00000000
    tx_data.append_u32_le(0);

    let mut decoder = TransactionDecoderTrait::new(tx_data);
    let tx = decoder.decode_transaction();

    assert!(tx.version == 1);
    assert!(tx.inputs.len() == 1);
    assert!(tx.outputs.len() == 1);
    assert!(tx.locktime == 0);
    assert!(!tx.is_segwit);

    // Check input
    let input = tx.inputs.at(0);
    assert!(*input.previous_vout == 0);
    assert!(*input.sequence == 0xffffffff);
    assert!(input.script_sig.len() == 0);

    // Check output
    let output = tx.outputs.at(0);
    assert!(*output.value == 1);
    assert!(output.script_pubkey.len() == 25);
}

#[test]
fn test_segwit_transaction_detection() {
    // SegWit transaction with marker (0x00) and flag (0x01)
    // Version: 0x01000000
    // Marker: 0x00
    // Flag: 0x01
    // Input count: 0x01
    // ... rest of transaction data ...

    // Build SegWit transaction data using ByteArrayExt little-endian methods
    let mut segwit_data: ByteArray = Default::default();
    // Version: 0x01000000
    segwit_data.append_u32_le(1);
    // SegWit marker and flag
    segwit_data.append_byte(0x00);
    segwit_data.append_byte(0x01);
    // Input count: 0x01
    segwit_data.append_byte(0x01);
    // Input: Previous txid (32 bytes of 0x00)
    append_zeros(ref segwit_data, 32_usize);
    // Previous vout: 0x00000000
    segwit_data.append_u32_le(0);
    // Script sig length: 0x00
    segwit_data.append_byte(0x00);
    // Sequence: 0xffffffff
    segwit_data.append_u32_le(0xffffffff);
    // Output count: 0x01
    segwit_data.append_byte(0x01);
    // Output value: 0x0100000000000000
    segwit_data.append_u64_le(1);
    // Script pubkey length: 0x19
    segwit_data.append_byte(0x19);
    // Script pubkey
    segwit_data.append_byte(0x76);
    segwit_data.append_byte(0xa9);
    segwit_data.append_byte(0x14);
    append_zeros(ref segwit_data, 20_usize);
    segwit_data.append_byte(0x88);
    segwit_data.append_byte(0xac);
    // Witness data: 1 item with length 0
    segwit_data.append_byte(0x01);
    segwit_data.append_byte(0x00);
    // Locktime: 0x00000000
    segwit_data.append_u32_le(0);

    let mut decoder = TransactionDecoderTrait::new(segwit_data);
    let tx = decoder.decode_transaction();

    assert!(tx.is_segwit);
    assert!(tx.witness.len() == tx.inputs.len());
}

#[test]
fn test_witness_data_decoding() {
    // Test witness stack with 2 items
    // Witness count: 0x02
    // Item 1: length 0x47 (71 bytes) + 71 bytes of data
    // Item 2: length 0x21 (33 bytes) + 33 bytes of data

    let mut witness_data: ByteArray = Default::default();
    // Witness count: 0x02
    witness_data.append_byte(0x02);
    // First item length: 0x47 (71 bytes)
    witness_data.append_byte(0x47);
    // Add 71 bytes of dummy data (0x41 = 'A')
    let mut i = 0_usize;
    while i < 71 {
        witness_data.append_byte(0x41);
        i += 1;
    }
    // Second item length: 0x21 (33 bytes)
    witness_data.append_byte(0x21);
    // Add 33 bytes of dummy data (0x42 = 'B')
    let mut i = 0_usize;
    while i < 33 {
        witness_data.append_byte(0x42);
        i += 1;
    }

    let mut decoder = TransactionDecoderTrait::new(witness_data);
    let witness = decoder.decode_witness();

    assert!(witness.witness_stack.len() == 2);
    assert!(witness.witness_stack.at(0).len() == 71);
    assert!(witness.witness_stack.at(1).len() == 33);
}

#[test]
fn test_multi_input_output_transaction() {
    // Transaction with 2 inputs and 2 outputs
    // This would be a longer test case in practice
    // For brevity, we'll test the structure parsing

    let mut multi_tx_data: ByteArray = Default::default();
    // Version: 0x01000000
    multi_tx_data.append_u32_le(1);
    // Input count: 0x02
    multi_tx_data.append_byte(0x02);
    // First input - txid (32 bytes of 0x00)
    append_zeros(ref multi_tx_data, 32_usize);
    // vout, script_sig_len, sequence
    multi_tx_data.append_u32_le(0);
    multi_tx_data.append_byte(0x00);
    multi_tx_data.append_u32_le(0xffffffff);
    // Second input - txid (32 bytes of 0x00)
    append_zeros(ref multi_tx_data, 32_usize);
    // vout, script_sig_len, sequence
    multi_tx_data.append_u32_le(1);
    multi_tx_data.append_byte(0x00);
    multi_tx_data.append_u32_le(0xffffffff);
    // Output count: 0x02
    multi_tx_data.append_byte(0x02);
    // First output - value, script_len
    multi_tx_data.append_u64_le(1);
    multi_tx_data.append_byte(0x19);
    // Script pubkey (25 bytes)
    multi_tx_data.append_byte(0x76);
    multi_tx_data.append_byte(0xa9);
    multi_tx_data.append_byte(0x14);
    append_zeros(ref multi_tx_data, 20_usize);
    multi_tx_data.append_byte(0x88);
    multi_tx_data.append_byte(0xac);
    // Second output - value, script_len
    multi_tx_data.append_u64_le(2);
    multi_tx_data.append_byte(0x19);
    // Script pubkey (25 bytes)
    multi_tx_data.append_byte(0x76);
    multi_tx_data.append_byte(0xa9);
    multi_tx_data.append_byte(0x14);
    // Fill with 0x11 bytes
    let mut i = 0_usize;
    while i < 20 {
        multi_tx_data.append_byte(0x11);
        i += 1;
    }
    multi_tx_data.append_byte(0x88);
    multi_tx_data.append_byte(0xac);
    // Locktime: 0x00000000
    multi_tx_data.append_u32_le(0);

    let mut decoder = TransactionDecoderTrait::new(multi_tx_data);
    let tx = decoder.decode_transaction();

    assert!(tx.inputs.len() == 2);
    assert!(tx.outputs.len() == 2);

    // Check first output value
    assert!(*tx.outputs.at(0).value == 1);
    // Check second output value
    assert!(*tx.outputs.at(1).value == 2);
}

#[test]
fn test_real_bitcoin_transaction_decoding() {
    // Real Bitcoin legacy transaction with 2 inputs and 2 outputs
    // Total bytes: 374 (0x176)
    // This test verifies our decoder can handle actual Bitcoin network data
    // Uses ByteArrayExt methods (append_u128, append_u64, etc.) for efficient construction
    // Gas optimized: ~12M gas (18% improvement vs manual byte appending)
    // Transaction hex:
    // 0100000002d06bf58a37205493ca5ab2f6c66d67f9a6116f55a1c6e57d570e3f2ce20ad4e3010000008a47304402206f8c15ac6b1ab6fade5b226a87e32fffa7a508dea86c85d7ea2c192dc34f11f302207fa72558f8a0445ff9799870f25ff7da5a2e55c3988075982bc77d056f9400d7014104739e52da88e1145aabdc482a1fc970b4294511f3ff8ae286efc1fd5bdfde63f9293345d8a254f8280bad0bc9d3c500fc1f16d520c4d55d640e7b1370f87e047affffffffd23f1795d0856496e7ff47cd2cf9fa32dee1a63cdd76b3e4332cf48e55a01904010000008a47304402206cbfc8c988b41d22727e16f8e2b56c155643633d44ac384a455aabe6e3269b0502205be3aa7f016772172b444f995c5089bb3abc4904083a9587d0356afbfbef9559014104739e52da88e1145aabdc482a1fc970b4294511f3ff8ae286efc1fd5bdfde63f9293345d8a254f8280bad0bc9d3c500fc1f16d520c4d55d640e7b1370f87e047affffffff0244ab1500000000001976a914bddfe9058adbff08046e45182f070c8ce9d7013a88ac770e0100000000001976a914bb5f38238359a93aeb4ff87fbca0aed7f46051af88ac00000000

    let mut real_tx_data: ByteArray = Default::default();

    // Version: 01000000 (little-endian, so version = 1)
    real_tx_data.append_u32_le(1);

    // Input count: 02
    real_tx_data.append_byte(0x02);

    // Input 1:
    // TXID: d06bf58a37205493ca5ab2f6c66d67f9a6116f55a1c6e57d570e3f2ce20ad4e3 (reversed in raw data)
    // Using u256 for efficiency (32 bytes = 1x u256)
    real_tx_data.append_u256(0xe30ad4e22c3f0e577d6e1ca1556f11a6f9676dc6f6b25aca935420378af56bd0);

    // VOUT: 01000000 (little-endian, so vout = 1)
    real_tx_data.append_u32_le(1);

    // Script sig size: 8a (138 bytes)
    real_tx_data.append_byte(0x8a);

    // Script sig:
    // 47304402206f8c15ac6b1ab6fade5b226a87e32fffa7a508dea86c85d7ea2c192dc34f11f302207fa72558f8a0445ff9799870f25ff7da5a2e55c3988075982bc77d056f9400d7014104739e52da88e1145aabdc482a1fc970b4294511f3ff8ae286efc1fd5bdfde63f9293345d8a254f8280bad0bc9d3c500fc1f16d520c4d55d640e7b1370f87e047a
    // Breaking down into u256 chunks for efficient appending (138 bytes = 4*32 + 10 bytes)
    real_tx_data.append_u256(0x47304402206f8c15ac6b1ab6fade5b226a87e32fffa7a508dea86c85d7ea2c19);
    real_tx_data.append_u256(0x2dc34f11f302207fa72558f8a0445ff9799870f25ff7da5a2e55c3988075982b);
    real_tx_data.append_u256(0xc77d056f9400d7014104739e52da88e1145aabdc482a1fc970b4294511f3ff8a);
    real_tx_data.append_u256(0xe286efc1fd5bdfde63f9293345d8a254f8280bad0bc9d3c500fc1f16d520c4d5);
    // Last 10 bytes: 5d640e7b1370f87e047a
    real_tx_data.append_u64(0x5d640e7b1370f87e);
    real_tx_data.append_u16(0x047a);

    // Sequence: ffffffff
    real_tx_data.append_u32_le(0xffffffff);

    // Input 2:
    // TXID: d23f1795d0856496e7ff47cd2cf9fa32dee1a63cdd76b3e4332cf48e55a01904 (reversed in raw data)
    // Using u256 for efficiency (32 bytes = 1x u256)
    real_tx_data.append_u256(0x0419a0558ef42c33e4b376dd3ca6e1de32faf92ccd47ffe7966485d095173fd2);

    // VOUT: 01000000 (little-endian, so vout = 1)
    real_tx_data.append_u32_le(1);

    // Script sig size: 8a (138 bytes)
    real_tx_data.append_byte(0x8a);

    // Script sig:
    // 47304402206cbfc8c988b41d22727e16f8e2b56c155643633d44ac384a455aabe6e3269b0502205be3aa7f016772172b444f995c5089bb3abc4904083a9587d0356afbfbef9559014104739e52da88e1145aabdc482a1fc970b4294511f3ff8ae286efc1fd5bdfde63f9293345d8a254f8280bad0bc9d3c500fc1f16d520c4d55d640e7b1370f87e047a
    // Breaking down into u256 chunks for efficient appending (138 bytes = 4*32 + 10 bytes)
    real_tx_data.append_u256(0x47304402206cbfc8c988b41d22727e16f8e2b56c155643633d44ac384a455aab);
    real_tx_data.append_u256(0xe6e3269b0502205be3aa7f016772172b444f995c5089bb3abc4904083a9587d0);
    real_tx_data.append_u256(0x356afbfbef9559014104739e52da88e1145aabdc482a1fc970b4294511f3ff8a);
    real_tx_data.append_u256(0xe286efc1fd5bdfde63f9293345d8a254f8280bad0bc9d3c500fc1f16d520c4d5);
    // Last 10 bytes: 5d640e7b1370f87e047a
    real_tx_data.append_u64(0x5d640e7b1370f87e);
    real_tx_data.append_u16(0x047a);

    // Sequence: ffffffff
    real_tx_data.append_u32_le(0xffffffff);

    // Output count: 02
    real_tx_data.append_byte(0x02);

    // Output 1:
    // Amount: 44ab150000000000 (little-endian, so amount = 0x000000000015ab44 = 1420100 satoshis)
    real_tx_data.append_u64_le(0x000000000015ab44);

    // Script pubkey size: 19 (25 bytes)
    real_tx_data.append_byte(0x19);

    // Script pubkey: 76a914bddfe9058adbff08046e45182f070c8ce9d7013a88ac (25 bytes P2PKH)
    // 16 bytes + 8 bytes + 1 byte = 25 bytes total
    real_tx_data.append_u128(0x76a914bddfe9058adbff08046e45182f);
    real_tx_data.append_u64(0x070c8ce9d7013a88);
    real_tx_data.append_byte(0xac);

    // Output 2:
    // Amount: 770e010000000000 (little-endian, so amount = 0x0000000000010e77 = 69239 satoshis)
    real_tx_data.append_u64_le(0x0000000000010e77);

    // Script pubkey size: 19 (25 bytes)
    real_tx_data.append_byte(0x19);

    // Script pubkey: 76a914bb5f38238359a93aeb4ff87fbca0aed7f46051af88ac (25 bytes P2PKH)
    // 16 bytes + 8 bytes + 1 byte = 25 bytes total
    real_tx_data.append_u128(0x76a914bb5f38238359a93aeb4ff87fbc);
    real_tx_data.append_u64(0xa0aed7f46051af88);
    real_tx_data.append_byte(0xac);

    // Locktime: 00000000
    real_tx_data.append_u32_le(0);

    // Decode the transaction
    let mut decoder = TransactionDecoderTrait::new(real_tx_data);
    let tx = decoder.decode_transaction();

    // Verify transaction structure
    assert!(tx.version == 1);
    assert!(tx.inputs.len() == 2);
    assert!(tx.outputs.len() == 2);
    assert!(tx.locktime == 0);
    assert!(!tx.is_segwit);

    // Verify first input
    let input1 = tx.inputs.at(0);
    assert!(*input1.previous_vout == 1);
    assert!(*input1.sequence == 0xffffffff);
    assert!(input1.script_sig.len() == 138);
    assert!(input1.previous_txid.len() == 32);

    // Verify first input script signature content (first few bytes)
    assert!(input1.script_sig.at(0).unwrap() == 0x47); // DER signature length
    assert!(input1.script_sig.at(1).unwrap() == 0x30); // DER sequence tag
    assert!(input1.script_sig.at(2).unwrap() == 0x44); // DER sequence length
    assert!(input1.script_sig.at(3).unwrap() == 0x02); // DER integer tag (r value)
    assert!(input1.script_sig.at(4).unwrap() == 0x20); // r value length (32 bytes)

    // Verify second input
    let input2 = tx.inputs.at(1);
    assert!(*input2.previous_vout == 1);
    assert!(*input2.sequence == 0xffffffff);
    assert!(input2.script_sig.len() == 138);
    assert!(input2.previous_txid.len() == 32);

    // Verify second input script signature content (first few bytes)
    assert!(input2.script_sig.at(0).unwrap() == 0x47); // DER signature length
    assert!(input2.script_sig.at(1).unwrap() == 0x30); // DER sequence tag
    assert!(input2.script_sig.at(2).unwrap() == 0x44); // DER sequence length
    assert!(input2.script_sig.at(3).unwrap() == 0x02); // DER integer tag (r value)
    assert!(input2.script_sig.at(4).unwrap() == 0x20); // r value length (32 bytes)

    // Verify script signature ending bytes (public key part)
    // Both signatures end with the same public key:
    // 04739e52da88e1145aabdc482a1fc970b4294511f3ff8ae286efc1fd5bdfde63f9293345d8a254f8280bad0bc9d3c500fc1f16d520c4d55d640e7b1370f87e047a
    assert!(input1.script_sig.at(137).unwrap() == 0x7a); // Last byte of public key
    assert!(input2.script_sig.at(137).unwrap() == 0x7a); // Last byte of public key
    assert!(input1.script_sig.at(136).unwrap() == 0x04); // Second to last byte
    assert!(input2.script_sig.at(136).unwrap() == 0x04); // Second to last byte

    // Verify first output (1420100 satoshis)
    let output1 = tx.outputs.at(0);
    assert!(*output1.value == 1420100);
    assert!(output1.script_pubkey.len() == 25);

    // Verify second output (69239 satoshis)
    let output2 = tx.outputs.at(1);
    assert!(*output2.value == 69239);
    assert!(output2.script_pubkey.len() == 25);
}

#[test]
#[should_panic(expected: 'Not enough bytes for u32')]
fn test_insufficient_data_u32() {
    // Test reading u32 with insufficient data (only 3 bytes)
    let mut data: ByteArray = Default::default();
    data.append_byte(0x01);
    data.append_byte(0x02);
    data.append_byte(0x03);
    let mut decoder = TransactionDecoderTrait::new(data);
    decoder.read_u32_le(); // Should panic
}

#[test]
#[should_panic(expected: 'Not enough bytes for u64')]
fn test_insufficient_data_u64() {
    // Test reading u64 with insufficient data (only 7 bytes)
    let mut data: ByteArray = Default::default();
    data.append_u32_le(0x12345678);
    data.append_byte(0x01);
    data.append_byte(0x02);
    data.append_byte(0x03);
    let mut decoder = TransactionDecoderTrait::new(data);
    decoder.read_u64_le(); // Should panic
}

#[test]
fn test_compact_size_edge_cases() {
    // Test maximum single byte value (0xfc)
    let mut data: ByteArray = Default::default();
    data.append_byte(0xfc);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_compact_size();
    assert!(result == 0xfc);

    // Test minimum 3-byte compact size (0xfd + 0xfd00)
    let mut data: ByteArray = Default::default();
    data.append_byte(0xfd);
    data.append_u16_le(0xfd);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_compact_size();
    assert!(result == 0xfd);

    // Test maximum 16-bit compact size (0xfd + 0xffff)
    let mut data: ByteArray = Default::default();
    data.append_byte(0xfd);
    data.append_u16_le(0xffff);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_compact_size();
    assert!(result == 0xffff);

    // Test 9-byte compact size (0xff + 8 bytes)
    let mut data: ByteArray = Default::default();
    data.append_byte(0xff);
    data.append_u64_le(0x123456789abcdef0);
    let mut decoder = TransactionDecoderTrait::new(data);
    let result = decoder.read_compact_size();
    assert!(result == 0x123456789abcdef0);
}

#[test]
fn test_empty_transaction_components() {
    // Test transaction with zero inputs and outputs
    let mut tx_data: ByteArray = Default::default();
    // Version
    tx_data.append_u32_le(1);
    // Input count: 0
    tx_data.append_byte(0x00);
    // Output count: 0
    tx_data.append_byte(0x00);
    // Locktime
    tx_data.append_u32_le(0);

    let mut decoder = TransactionDecoderTrait::new(tx_data);
    let tx = decoder.decode_transaction();

    assert!(tx.version == 1);
    assert!(tx.inputs.len() == 0);
    assert!(tx.outputs.len() == 0);
    assert!(tx.locktime == 0);
    assert!(!tx.is_segwit);
}

#[test]
fn test_maximum_values() {
    // Test transaction with maximum field values
    let mut tx_data: ByteArray = Default::default();

    // Maximum version (u32::MAX)
    tx_data.append_u32_le(0xffffffff);

    // Single input with maximum values
    tx_data.append_byte(0x01);
    // Maximum txid (32 bytes of 0xff)
    let mut i = 0_usize;
    while i < 32 {
        tx_data.append_byte(0xff);
        i += 1;
    }
    // Maximum vout
    tx_data.append_u32_le(0xffffffff);
    // Empty script sig
    tx_data.append_byte(0x00);
    // Maximum sequence
    tx_data.append_u32_le(0xffffffff);

    // Single output with maximum value
    tx_data.append_byte(0x01);
    // Maximum value (u64::MAX)
    tx_data.append_u64_le(0xffffffffffffffff);
    // Empty script pubkey
    tx_data.append_byte(0x00);

    // Maximum locktime
    tx_data.append_u32_le(0xffffffff);

    let mut decoder = TransactionDecoderTrait::new(tx_data);
    let tx = decoder.decode_transaction();

    assert!(tx.version == 0xffffffff);
    assert!(tx.inputs.len() == 1);
    assert!(*tx.inputs.at(0).previous_vout == 0xffffffff);
    assert!(*tx.inputs.at(0).sequence == 0xffffffff);
    assert!(tx.outputs.len() == 1);
    assert!(*tx.outputs.at(0).value == 0xffffffffffffffff);
    assert!(tx.locktime == 0xffffffff);
}

#[test]
fn test_large_script_sizes() {
    // Test with moderately large script (255 bytes - maximum single byte compact size)
    let mut tx_data: ByteArray = Default::default();
    tx_data.append_u32_le(1); // Version
    tx_data.append_byte(0x01); // Input count

    // Input with large script sig
    append_zeros(ref tx_data, 32_usize); // Previous txid
    tx_data.append_u32_le(0); // Previous vout
    tx_data.append_byte(0xfc); // Script sig length (252 bytes - max single byte)
    let mut i = 0_usize;
    while i < 252 {
        tx_data.append_byte(0x6a); // OP_RETURN opcode
        i += 1;
    }
    tx_data.append_u32_le(0xffffffff); // Sequence

    tx_data.append_byte(0x01); // Output count
    tx_data.append_u64_le(1000); // Value
    tx_data.append_byte(0xfc); // Script pubkey length (252 bytes)
    let mut i = 0_usize;
    while i < 252 {
        tx_data.append_byte(0x51); // OP_1 opcode
        i += 1;
    }

    tx_data.append_u32_le(0); // Locktime

    let mut decoder = TransactionDecoderTrait::new(tx_data);
    let tx = decoder.decode_transaction();

    assert!(tx.inputs.at(0).script_sig.len() == 252);
    assert!(tx.outputs.at(0).script_pubkey.len() == 252);

    // Verify script content
    assert!(tx.inputs.at(0).script_sig.at(0).unwrap() == 0x6a);
    assert!(tx.inputs.at(0).script_sig.at(251).unwrap() == 0x6a);
    assert!(tx.outputs.at(0).script_pubkey.at(0).unwrap() == 0x51);
    assert!(tx.outputs.at(0).script_pubkey.at(251).unwrap() == 0x51);
}

#[test]
fn test_remaining_bytes_checker() {
    // Test the remaining() helper function
    let mut data: ByteArray = Default::default();
    data.append_u32_le(0x12345678);
    data.append_u16_le(0xabcd);
    // Total: 6 bytes

    let decoder = TransactionDecoderTrait::new(data);

    // Test valid remaining checks
    assert!(decoder.remaining(0, 6)); // Can read all 6 bytes from start
    assert!(decoder.remaining(0, 4)); // Can read 4 bytes from start
    assert!(decoder.remaining(2, 4)); // Can read 4 bytes from offset 2
    assert!(decoder.remaining(6, 0)); // Can read 0 bytes from end

    // Test invalid remaining checks
    assert!(!decoder.remaining(0, 7)); // Cannot read 7 bytes from 6-byte array
    assert!(!decoder.remaining(1, 6)); // Cannot read 6 bytes from offset 1
    assert!(!decoder.remaining(6, 1)); // Cannot read 1 byte from end
}
