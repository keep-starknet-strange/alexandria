use core::sha256::{compute_sha256_byte_array, compute_sha256_u32_array};
use crate::bip340_utils::tagged_hash;
use crate::bytes_utils::{
    append_u256_be,
    pack_sha256,
    append_u32_le,
    append_u64_le,
    append_u256_le,
    append_varint,
    append_varslice,
};

#[derive(Drop, Clone)]
struct Transaction {
    version: u32,
    locktime: u32,
    inputs: Array<TxInput>,
    outputs: Array<TxOutput>,
}

#[derive(Drop, Clone)]
struct TxInput {
    hash: u256,
    index: u32,
    sequence: u32,
    script: ByteArray,
}

#[derive(Drop, Clone)]
struct TxOutput {
    value: u64,
    script: ByteArray,
}

const SIGHASH_ALL: u8 = 0x01;

#[inline(always)]
fn hash256(input: @ByteArray) -> Span<u32> {
    let hash = compute_sha256_byte_array(input).span();
    let hash_array: Array<u32> = array![
        *hash[0],
        *hash[1],
        *hash[2],
        *hash[3],
        *hash[4],
        *hash[5],
        *hash[6],
        *hash[7],
    ];

    compute_sha256_u32_array(hash_array, 0, 0).span()
}

#[inline(always)]
fn build_to_spend_tx(message: @ByteArray, script_pubkey: @ByteArray) -> Transaction {
    let message_hash = pack_sha256(
        tagged_hash("BIP0322-signed-message", message)
    );
    let mut script_sig: ByteArray = "";

    script_sig.append_byte(0x0);
    script_sig.append_byte(0x20);

    append_u256_be(ref script_sig, message_hash);

    Transaction {
        version: 0,
        locktime: 0,
        inputs: array![TxInput { hash: 0, script: script_sig, index: 0xFFFFFFFF, sequence: 0, }],
        outputs: array![TxOutput { value: 0, script: script_pubkey.clone(), }],
    }
}

#[inline(always)]
fn build_to_sign_tx(
    to_spend_tx_id: u256,
    script_pubkey: @ByteArray,
) -> Transaction {
    let mut script: ByteArray = "";

    script.append_byte(0x6a);

    Transaction {
        version: 0,
        locktime: 0,
        inputs: array![TxInput { hash: to_spend_tx_id, script: script_pubkey.clone(), index: 0, sequence: 0 }],
        outputs: array![TxOutput { value: 0, script, }],
    }
}

#[inline(always)]
fn get_script_pubkey(pub_key: u256) -> ByteArray {
    let mut res: ByteArray = "";

    res.append_byte(0x51_u8);
    res.append_byte(0x20_u8);

    append_u256_be(ref res, pub_key);

    res
}

#[inline(always)]
fn get_transaction_id(tx: @Transaction) -> u256 {
    let serialized = serialize_transaction_for_id(tx);

    pack_sha256(hash256(@serialized))
}

#[inline(always)]
fn serialize_transaction_for_id(tx: @Transaction) -> ByteArray {
    let mut data: ByteArray = "";

    // version u32
    append_u32_le(ref data, *tx.version);
    // in len
    append_varint(ref data, tx.inputs.len());

    let input = tx.inputs[0];

    // tx in hash
    // TODO: See if not concat 32 0 bytes here directly
    append_u256_le(ref data, *input.hash);
    // tx in index
    append_u32_le(ref data, *input.index);
    // tx in script
    append_varslice(ref data, input.script);
    // tx in sequence
    append_u32_le(ref data, *input.sequence);
    // out len
    append_varint(ref data, tx.outputs.len());

    let output = tx.outputs[0];

    // tx out value
    append_u64_le(ref data, *output.value);
    // tx out script
    append_varslice(ref data, output.script);
    // locktime
    append_u32_le(ref data, *tx.locktime);

    data
}

#[inline(always)]
fn hash_for_witness_v1(
    tx: @Transaction,
    prev_out_scripts: @ByteArray,
) -> u256 {
    if tx.inputs.len() != 1 || prev_out_scripts.len() == 0 {
        core::panic_with_felt252('invalid inputs');
    }

    let mut prev_outs: ByteArray = "";
    let input = tx.inputs[0];

    append_u256_be(ref prev_outs, *input.hash);
    append_u32_le(ref prev_outs, *input.index);

    let hash_prevouts = pack_sha256(compute_sha256_byte_array(@prev_outs).span());

    let mut amounts: ByteArray = "";

    append_u64_le(ref amounts, 0x0);

    let hash_amounts = pack_sha256(compute_sha256_byte_array(@amounts).span());

    let mut script_pub_keys: ByteArray = "";

    script_pub_keys.append_byte(prev_out_scripts.len().try_into().unwrap());

    script_pub_keys = ByteArrayTrait::concat(@script_pub_keys, prev_out_scripts);

    let hash_script_pub_keys = pack_sha256(compute_sha256_byte_array(@script_pub_keys).span());

    let mut sequences: ByteArray = "";

    append_u32_le(ref sequences, *input.sequence);

    let hash_sequences = pack_sha256(compute_sha256_byte_array(@sequences).span());
    let output = tx.outputs[0];

    let mut outputs: ByteArray = "";

    append_u64_le(ref outputs, *output.value);
    append_varslice(ref outputs, output.script);

    let hash_ouputs = pack_sha256(compute_sha256_byte_array(@outputs).span());

    let mut sig_msg: ByteArray = "";

    sig_msg.append_byte(0x0);
    sig_msg.append_byte(SIGHASH_ALL);
    append_u32_le(ref sig_msg, *tx.version);
    append_u32_le(ref sig_msg, *tx.locktime);
    append_u256_be(ref sig_msg, hash_prevouts);
    append_u256_be(ref sig_msg, hash_amounts);
    append_u256_be(ref sig_msg, hash_script_pub_keys);
    append_u256_be(ref sig_msg, hash_sequences);
    append_u256_be(ref sig_msg, hash_ouputs);
    sig_msg.append_byte(0x0);
    append_u32_le(ref sig_msg, 0x0);

    pack_sha256(tagged_hash("TapSighash", @sig_msg))
}

#[inline(always)]
pub fn bip322_msg_hash(
    pub_key: u256,
    message: ByteArray
) -> u256 {
    let script_pubkey = get_script_pubkey(pub_key);

    let to_spend_tx = build_to_spend_tx(@message, @script_pubkey);
    let to_spend_tx_id = get_transaction_id(@to_spend_tx);

    let to_sign_tx = build_to_sign_tx(
        to_spend_tx_id,
        @script_pubkey,
    );

    hash_for_witness_v1(
        @to_sign_tx,
        @script_pubkey
    )
}
