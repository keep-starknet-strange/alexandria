use alexandria_btc::decoder::TransactionDecoderTrait;
use alexandria_btc::encoder::TransactionEncoderTrait;
use alexandria_btc::types::{
    BitcoinTransaction, TransactionInput, TransactionOutput, TransactionWitness,
};

#[test]
fn test_compact_size_encoding() {
    let mut encoder = TransactionEncoderTrait::new();

    // Test single byte compact size (< 0xfd)
    encoder.write_compact_size(0x42);
    assert!(encoder.data.at(0).unwrap() == 0x42);
    assert!(encoder.data.len() == 1);

    // Test 3-byte compact size (0xfd + 2 bytes)
    let mut encoder = TransactionEncoderTrait::new();
    encoder.write_compact_size(0x1234);
    assert!(encoder.data.len() == 3); // Total length should be 3
    assert!(encoder.data.at(0).unwrap() == 0xfd);
    // Check little-endian encoding of 0x1234 (2 bytes)
    assert!(encoder.data.at(1).unwrap() == 0x34);
    assert!(encoder.data.at(2).unwrap() == 0x12);

    // Test 5-byte compact size (0xfe + 4 bytes)
    let mut encoder = TransactionEncoderTrait::new();
    encoder.write_compact_size(0x12345678);
    assert!(encoder.data.len() == 5); // Total length should be 5
    assert!(encoder.data.at(0).unwrap() == 0xfe);
    // Check little-endian encoding of 0x12345678 (4 bytes)
    assert!(encoder.data.at(1).unwrap() == 0x78);
    assert!(encoder.data.at(2).unwrap() == 0x56);
    assert!(encoder.data.at(3).unwrap() == 0x34);
    assert!(encoder.data.at(4).unwrap() == 0x12);

    // Test 9-byte compact size (0xff + 8 bytes)
    let mut encoder = TransactionEncoderTrait::new();
    encoder.write_compact_size(0x1122334455667788);
    assert!(encoder.data.len() == 9); // Total length should be 9
    assert!(encoder.data.at(0).unwrap() == 0xff);
    // Check little-endian encoding of 0x1122334455667788 (8 bytes)
    assert!(encoder.data.at(1).unwrap() == 0x88);
    assert!(encoder.data.at(2).unwrap() == 0x77);
    assert!(encoder.data.at(3).unwrap() == 0x66);
    assert!(encoder.data.at(4).unwrap() == 0x55);
    assert!(encoder.data.at(5).unwrap() == 0x44);
    assert!(encoder.data.at(6).unwrap() == 0x33);
    assert!(encoder.data.at(7).unwrap() == 0x22);
    assert!(encoder.data.at(8).unwrap() == 0x11);
}

#[test]
fn test_u32_le_encoding() {
    let mut encoder = TransactionEncoderTrait::new();
    encoder.write_u32_le(0x12345678);

    // Verify little-endian encoding
    assert!(encoder.data.at(0).unwrap() == 0x78);
    assert!(encoder.data.at(1).unwrap() == 0x56);
    assert!(encoder.data.at(2).unwrap() == 0x34);
    assert!(encoder.data.at(3).unwrap() == 0x12);
}

#[test]
fn test_u64_le_encoding() {
    let mut encoder = TransactionEncoderTrait::new();
    encoder.write_u64_le(0x1122334455667788);

    // Verify little-endian encoding
    assert!(encoder.data.at(0).unwrap() == 0x88);
    assert!(encoder.data.at(1).unwrap() == 0x77);
    assert!(encoder.data.at(2).unwrap() == 0x66);
    assert!(encoder.data.at(3).unwrap() == 0x55);
    assert!(encoder.data.at(4).unwrap() == 0x44);
    assert!(encoder.data.at(5).unwrap() == 0x33);
    assert!(encoder.data.at(6).unwrap() == 0x22);
    assert!(encoder.data.at(7).unwrap() == 0x11);
}

#[test]
fn test_simple_legacy_transaction_encoding() {
    // Create a simple legacy transaction with 1 input, 1 output
    let mut previous_txid = "";
    let mut i = 0_usize;
    while i < 32 {
        previous_txid.append_byte(0x00);
        i += 1;
    }

    let input = TransactionInput {
        previous_txid, previous_vout: 0, script_sig: "", sequence: 0xffffffff,
    };

    let mut script_pubkey = "";
    script_pubkey.append_byte(0x76); // OP_DUP
    script_pubkey.append_byte(0xa9); // OP_HASH160
    script_pubkey.append_byte(0x14); // Push 20 bytes
    let mut i = 0_usize;
    while i < 20 {
        script_pubkey.append_byte(0x00);
        i += 1;
    }
    script_pubkey.append_byte(0x88); // OP_EQUALVERIFY
    script_pubkey.append_byte(0xac); // OP_CHECKSIG

    let output = TransactionOutput { value: 1, script_pubkey };

    let transaction = BitcoinTransaction {
        version: 1,
        inputs: array![input],
        outputs: array![output],
        locktime: 0,
        witness: array![],
        is_segwit: false,
    };

    // Encode the transaction
    let mut encoder = TransactionEncoderTrait::new();
    let encoded_data = encoder.encode_transaction(transaction);

    // Verify the encoded data by decoding it back
    let mut decoder = TransactionDecoderTrait::new(encoded_data);
    let decoded_tx = decoder.decode_transaction();

    assert!(decoded_tx.version == 1);
    assert!(decoded_tx.inputs.len() == 1);
    assert!(decoded_tx.outputs.len() == 1);
    assert!(decoded_tx.locktime == 0);
    assert!(!decoded_tx.is_segwit);

    // Check input
    let decoded_input = decoded_tx.inputs.at(0);
    assert!(*decoded_input.previous_vout == 0);
    assert!(*decoded_input.sequence == 0xffffffff);
    assert!(decoded_input.script_sig.len() == 0);
    assert!(decoded_input.previous_txid.len() == 32);

    // Check output
    let decoded_output = decoded_tx.outputs.at(0);
    assert!(*decoded_output.value == 1);
    assert!(decoded_output.script_pubkey.len() == 25);
}

#[test]
fn test_segwit_transaction_encoding() {
    // Create a SegWit transaction
    let mut previous_txid = "";
    let mut i = 0_usize;
    while i < 32 {
        previous_txid.append_byte(0x00);
        i += 1;
    }

    let input = TransactionInput {
        previous_txid, previous_vout: 0, script_sig: "", sequence: 0xffffffff,
    };

    let mut script_pubkey = "";
    script_pubkey.append_byte(0x00); // OP_0
    script_pubkey.append_byte(0x14); // Push 20 bytes
    let mut i = 0_usize;
    while i < 20 {
        script_pubkey.append_byte(0x00);
        i += 1;
    }

    let output = TransactionOutput { value: 1, script_pubkey };

    // Create witness data
    let mut witness_item = "";
    witness_item.append_byte(0x47); // 71 bytes of dummy signature
    let mut i = 0_usize;
    while i < 70 {
        witness_item.append_byte(0x30);
        i += 1;
    }

    let witness = TransactionWitness { witness_stack: array![witness_item] };

    let transaction = BitcoinTransaction {
        version: 1,
        inputs: array![input],
        outputs: array![output],
        locktime: 0,
        witness: array![witness],
        is_segwit: true,
    };

    // Encode the transaction
    let mut encoder = TransactionEncoderTrait::new();
    let encoded_data = encoder.encode_transaction(transaction);

    // Verify SegWit marker and flag are present
    assert!(encoded_data.at(4).unwrap() == 0x00); // Marker after version
    assert!(encoded_data.at(5).unwrap() == 0x01); // Flag

    // Verify the encoded data by decoding it back
    let mut decoder = TransactionDecoderTrait::new(encoded_data);
    let decoded_tx = decoder.decode_transaction();

    assert!(decoded_tx.version == 1);
    assert!(decoded_tx.inputs.len() == 1);
    assert!(decoded_tx.outputs.len() == 1);
    assert!(decoded_tx.locktime == 0);
    assert!(decoded_tx.is_segwit);
    assert!(decoded_tx.witness.len() == 1);

    // Check witness data
    let decoded_witness = decoded_tx.witness.at(0);
    assert!(decoded_witness.witness_stack.len() == 1);
    assert!(decoded_witness.witness_stack.at(0).len() == 71);
}

#[test]
fn test_multi_input_output_transaction_encoding() {
    // Create a transaction with 2 inputs and 2 outputs
    let mut previous_txid1 = "";
    let mut previous_txid2 = "";
    let mut i = 0_usize;
    while i < 32 {
        previous_txid1.append_byte(0x00);
        previous_txid2.append_byte(0x11);
        i += 1;
    }

    let input1 = TransactionInput {
        previous_txid: previous_txid1, previous_vout: 0, script_sig: "", sequence: 0xffffffff,
    };

    let input2 = TransactionInput {
        previous_txid: previous_txid2, previous_vout: 1, script_sig: "", sequence: 0xffffffff,
    };

    let mut script_pubkey1 = "";
    script_pubkey1.append_byte(0x76);
    script_pubkey1.append_byte(0xa9);
    script_pubkey1.append_byte(0x14);
    let mut i = 0_usize;
    while i < 20 {
        script_pubkey1.append_byte(0x00);
        i += 1;
    }
    script_pubkey1.append_byte(0x88);
    script_pubkey1.append_byte(0xac);

    let mut script_pubkey2 = "";
    script_pubkey2.append_byte(0x76);
    script_pubkey2.append_byte(0xa9);
    script_pubkey2.append_byte(0x14);
    let mut i = 0_usize;
    while i < 20 {
        script_pubkey2.append_byte(0x11);
        i += 1;
    }
    script_pubkey2.append_byte(0x88);
    script_pubkey2.append_byte(0xac);

    let output1 = TransactionOutput { value: 1000, script_pubkey: script_pubkey1 };

    let output2 = TransactionOutput { value: 2000, script_pubkey: script_pubkey2 };

    let transaction = BitcoinTransaction {
        version: 1,
        inputs: array![input1, input2],
        outputs: array![output1, output2],
        locktime: 0,
        witness: array![],
        is_segwit: false,
    };

    // Encode the transaction
    let mut encoder = TransactionEncoderTrait::new();
    let encoded_data = encoder.encode_transaction(transaction);

    // Verify the encoded data by decoding it back
    let mut decoder = TransactionDecoderTrait::new(encoded_data);
    let decoded_tx = decoder.decode_transaction();

    assert!(decoded_tx.version == 1);
    assert!(decoded_tx.inputs.len() == 2);
    assert!(decoded_tx.outputs.len() == 2);
    assert!(decoded_tx.locktime == 0);
    assert!(!decoded_tx.is_segwit);

    // Check inputs
    let decoded_input1 = decoded_tx.inputs.at(0);
    let decoded_input2 = decoded_tx.inputs.at(1);
    assert!(*decoded_input1.previous_vout == 0);
    assert!(*decoded_input2.previous_vout == 1);

    // Check outputs
    let decoded_output1 = decoded_tx.outputs.at(0);
    let decoded_output2 = decoded_tx.outputs.at(1);
    assert!(*decoded_output1.value == 1000);
    assert!(*decoded_output2.value == 2000);
}

#[test]
fn test_round_trip_encoding_decoding() {
    // Test that encoding then decoding produces the same result
    let mut encoder = TransactionEncoderTrait::new();

    // Test compact size round trip
    encoder.write_compact_size(252);
    encoder.write_compact_size(65535);
    encoder.write_compact_size(4294967295);

    let mut decoder = TransactionDecoderTrait::new(encoder.data.clone());

    assert!(decoder.read_compact_size() == 252);
    assert!(decoder.read_compact_size() == 65535);
    assert!(decoder.read_compact_size() == 4294967295);
}

#[test]
fn test_bytes_encoding() {
    let mut encoder = TransactionEncoderTrait::new();

    let mut test_bytes = "";
    test_bytes.append_byte(0x01);
    test_bytes.append_byte(0x02);
    test_bytes.append_byte(0x03);
    test_bytes.append_byte(0x04);

    encoder.write_bytes(test_bytes);

    assert!(encoder.data.len() == 4);
    assert!(encoder.data.at(0).unwrap() == 0x01);
    assert!(encoder.data.at(1).unwrap() == 0x02);
    assert!(encoder.data.at(2).unwrap() == 0x03);
    assert!(encoder.data.at(3).unwrap() == 0x04);
}
