use alexandria_bytes::byte_array_ext::{ByteArrayTraitExt, SpanU8IntoByteArray};
use core::traits::Into;
use starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256PointTrait, Secp256Trait};
use starknet::secp256k1::Secp256k1Point;
use crate::encoder::TransactionEncoderTrait;
use crate::hash::sha256_byte_array;
use crate::taproot::{lift_x_coordinate, tagged_hash_byte_array, tagged_hash_u256};
use crate::types::{BitcoinTransaction, TransactionInput, TransactionOutput, TransactionWitness};

const EMPTY_32_BYTES: [u8; 32] = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];

#[derive(Drop, Copy, PartialEq)]
pub enum SighashType {
    DEFAULT,
    ALL,
}

impl SighashTypeIntoU8 of Into<SighashType, u8> {
    const fn into(self: SighashType) -> u8 {
        match self {
            SighashType::DEFAULT => 0_u8,
            SighashType::ALL => 1_u8,
        }
    }
}

#[inline(always)]
fn build_to_spend_tx(message: @ByteArray, script_pubkey: @ByteArray) -> BitcoinTransaction {
    let message_hash = tagged_hash_byte_array("BIP0322-signed-message", message);
    let mut script_sig: ByteArray = "";

    script_sig.append_byte(0x0);
    script_sig.append_byte(0x20);
    script_sig.append(@message_hash);

    let previous_txid: ByteArray = EMPTY_32_BYTES.span().into();

    BitcoinTransaction {
        version: 0,
        locktime: 0,
        inputs: array![
            TransactionInput { previous_txid, script_sig, previous_vout: 0xFFFFFFFF, sequence: 0 },
        ],
        outputs: array![TransactionOutput { value: 0, script_pubkey: script_pubkey.clone() }],
        witness: array![],
        is_segwit: false,
    }
}

#[inline(always)]
fn build_to_sign_tx(to_spend_tx_id: ByteArray, script_pubkey: ByteArray) -> BitcoinTransaction {
    let mut script: ByteArray = "";

    script.append_byte(0x6a);

    BitcoinTransaction {
        version: 0,
        locktime: 0,
        inputs: array![
            TransactionInput {
                previous_txid: to_spend_tx_id, script_sig: "", previous_vout: 0, sequence: 0,
            },
        ],
        outputs: array![TransactionOutput { value: 0, script_pubkey: script }],
        witness: array![TransactionWitness { witness_stack: array![script_pubkey] }],
        is_segwit: false,
    }
}

#[inline(always)]
fn get_script_pubkey(pub_key: u256) -> ByteArray {
    let mut res: ByteArray = "";

    res.append_byte(0x51_u8);
    res.append_byte(0x20_u8);
    res.append_u256(pub_key);

    res
}

#[inline(always)]
fn get_transaction_id(tx: BitcoinTransaction) -> ByteArray {
    let mut encoder = TransactionEncoderTrait::new();
    let serialized = encoder.encode_transaction(tx);
    let first_hash = sha256_byte_array(@serialized);

    sha256_byte_array(@first_hash)
}

#[inline(always)]
fn hash_for_witness_v1(sighash_type: SighashType, tx: @BitcoinTransaction) -> ByteArray {
    let prev_out_scripts = tx.witness[0].witness_stack[0];

    if tx.inputs.len() != 1 || prev_out_scripts.len() == 0 {
        core::panic_with_felt252('invalid inputs');
    }

    let mut prev_outs: ByteArray = "";
    let input = tx.inputs[0];

    prev_outs.append(input.previous_txid);
    prev_outs.append_u32_le(*input.previous_vout);

    let hash_prevouts = sha256_byte_array(@prev_outs);
    let mut amounts: ByteArray = "";

    amounts.append_u64_le(0x0);

    let hash_amounts = sha256_byte_array(@amounts);
    let mut script_pub_keys: ByteArray = "";

    script_pub_keys.append_byte(prev_out_scripts.len().try_into().unwrap());
    script_pub_keys.append(prev_out_scripts);

    let hash_script_pub_keys = sha256_byte_array(@script_pub_keys);
    let mut sequences: ByteArray = "";

    sequences.append_u32_le(*input.sequence);

    let hash_sequences = sha256_byte_array(@sequences);
    let output = tx.outputs[0];

    let mut outputs: ByteArray = "";

    outputs.append_u64_le(*output.value);

    // manually appending varslice (output.script_pubkey < 0xfd
    outputs.append_byte(output.script_pubkey.len().try_into().unwrap());
    outputs.append(output.script_pubkey);

    let hash_ouputs = sha256_byte_array(@outputs);
    let mut sig_msg: ByteArray = "";

    sig_msg.append_byte(0x0);
    sig_msg.append_byte(sighash_type.into());
    sig_msg.append_u32_le(*tx.version);
    sig_msg.append_u32_le(*tx.locktime);
    sig_msg.append(@hash_prevouts);
    sig_msg.append(@hash_amounts);
    sig_msg.append(@hash_script_pub_keys);
    sig_msg.append(@hash_sequences);
    sig_msg.append(@hash_ouputs);
    sig_msg.append_byte(0x0);
    sig_msg.append_u32_le(0x0);

    tagged_hash_byte_array("TapSighash", @sig_msg)
}

pub fn tweak_public_key(internal_key: u256) -> u256 {
    let P = lift_x_coordinate(internal_key).unwrap();
    let mut internal_key_bytes: ByteArray = "";

    internal_key_bytes.append_u256(internal_key);

    let tweak = tagged_hash_u256("TapTweak", @internal_key_bytes);
    let tweek_G = Secp256Trait::<Secp256k1Point>::get_generator_point().mul(tweak).unwrap_syscall();
    let Q = P.add(tweek_G).unwrap_syscall();
    let (x, _) = Q.get_coordinates().unwrap_syscall();

    x
}

#[inline(always)]
pub fn bip322_msg_hash_with_type(
    sighash_type: SighashType, pub_key: u256, message: ByteArray,
) -> ByteArray {
    let script_pubkey = get_script_pubkey(pub_key);
    let to_spend_tx = build_to_spend_tx(@message, @script_pubkey);
    let to_spend_tx_id = get_transaction_id(to_spend_tx);
    let to_sign_tx = build_to_sign_tx(to_spend_tx_id, script_pubkey);

    hash_for_witness_v1(sighash_type, @to_sign_tx)
}

#[inline(always)]
pub fn bip322_msg_hash(pub_key: u256, message: ByteArray) -> ByteArray {
    bip322_msg_hash_with_type(SighashType::ALL, pub_key, message)
}
