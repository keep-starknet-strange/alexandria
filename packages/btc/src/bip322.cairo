use starknet::{
    SyscallResultTrait,
    secp256_trait::{Secp256PointTrait, Secp256Trait},
    secp256k1::Secp256k1Point
};
use crate::bytes_utils::{
    append_u256_be,
    append_u32_le,
    append_u64_le,
    append_u256_le,
    append_varint,
    append_varslice,
};
use crate::taproot::{
    tagged_hash_byte_array,
    tagged_hash_u256,
    lift_x_coordinate
};
use crate::hash::{sha256_byte_array, sha256_u256};

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
fn build_to_spend_tx(
    message: @ByteArray,
    script_pubkey: @ByteArray
) -> Transaction {
    let message_hash = tagged_hash_byte_array(
        "BIP0322-signed-message",
        message
    );
    let mut script_sig: ByteArray = "";

    script_sig.append_byte(0x0);
    script_sig.append_byte(0x20);
    script_sig.append(@message_hash);

    Transaction {
        version: 0,
        locktime: 0,
        inputs: array![TxInput {
            hash: 0,
            script: script_sig,
            index: 0xFFFFFFFF,
            sequence: 0,
        }],
        outputs: array![TxOutput { value: 0, script: script_pubkey.clone(), }]
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
        inputs: array![TxInput {
            hash: to_spend_tx_id,
            script: script_pubkey.clone(),
            index: 0,
            sequence: 0
        }],
        outputs: array![TxOutput { value: 0, script, }]
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
    let first_hash = sha256_byte_array(@serialized);

    sha256_u256(@first_hash)
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
) -> ByteArray {
    if tx.inputs.len() != 1 || prev_out_scripts.len() == 0 {
        core::panic_with_felt252('invalid inputs');
    }

    let mut prev_outs: ByteArray = "";
    let input = tx.inputs[0];

    append_u256_be(ref prev_outs, *input.hash);
    append_u32_le(ref prev_outs, *input.index);

    let hash_prevouts = sha256_byte_array(@prev_outs);
    let mut amounts: ByteArray = "";

    append_u64_le(ref amounts, 0x0);

    let hash_amounts = sha256_byte_array(@amounts);
    let mut script_pub_keys: ByteArray = "";

    script_pub_keys.append_byte(prev_out_scripts.len().try_into().unwrap());
    script_pub_keys.append(prev_out_scripts);

    let hash_script_pub_keys = sha256_byte_array(@script_pub_keys);
    let mut sequences: ByteArray = "";

    append_u32_le(ref sequences, *input.sequence);

    let hash_sequences = sha256_byte_array(@sequences);
    let output = tx.outputs[0];

    let mut outputs: ByteArray = "";

    append_u64_le(ref outputs, *output.value);
    append_varslice(ref outputs, output.script);

    let hash_ouputs = sha256_byte_array(@outputs);
    let mut sig_msg: ByteArray = "";

    sig_msg.append_byte(0x0);
    sig_msg.append_byte(SIGHASH_ALL);
    append_u32_le(ref sig_msg, *tx.version);
    append_u32_le(ref sig_msg, *tx.locktime);
    sig_msg.append(@hash_prevouts);
    sig_msg.append(@hash_amounts);
    sig_msg.append(@hash_script_pub_keys);
    sig_msg.append(@hash_sequences);
    sig_msg.append(@hash_ouputs);
    sig_msg.append_byte(0x0);
    append_u32_le(ref sig_msg, 0x0);

    tagged_hash_byte_array("TapSighash", @sig_msg)
}

pub fn tweak_public_key(internal_key: u256) -> u256 {
    let P = lift_x_coordinate(internal_key).unwrap();
    let mut internal_key_bytes: ByteArray = "";

    append_u256_be(ref internal_key_bytes, internal_key);

    let tweak = tagged_hash_u256("TapTweak", @internal_key_bytes);
    let tweek_G = Secp256Trait::<Secp256k1Point>::get_generator_point()
        .mul(tweak).unwrap_syscall();
    let Q = P.add(tweek_G).unwrap_syscall();
    let (x, _) = Q.get_coordinates().unwrap_syscall();

    x
}

#[inline(always)]
pub fn bip322_msg_hash(
    pub_key: u256,
    message: ByteArray
) -> ByteArray {
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
