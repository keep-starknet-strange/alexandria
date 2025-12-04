use alexandria_bytes::byte_array_ext::{
    ByteArrayIntoArrayU8, ByteArrayTraitExt, SpanU8IntoByteArray,
};
use core::array::ArrayTrait;
use core::traits::Into;
use starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256PointTrait, Secp256Trait};
use starknet::secp256k1::Secp256k1Point;
use crate::address::{create_p2tr_script_pubkey, create_p2wpkh_script_pubkey};
use crate::encoder::TransactionEncoderTrait;
use crate::hash::{hash160_from_byte_array, sha256_byte_array};
use crate::taproot::{lift_x_coordinate, tagged_hash_byte_array, tagged_hash_u256};
use crate::types::{
    BitcoinPublicKey, BitcoinPublicKeyTrait, BitcoinTransaction, TransactionInput,
    TransactionOutput, TransactionWitness,
};

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

pub fn build_to_spend_tx(message: @ByteArray, script_pubkey: @ByteArray) -> BitcoinTransaction {
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

pub fn build_to_sign_tx(
    to_spend_tx_id: ByteArray, script_pubkey: ByteArray, is_segwit: bool,
) -> BitcoinTransaction {
    let mut script: ByteArray = "";

    script.append_byte(0x6a);

    let witness_stack = array![script_pubkey];
    let witness = array![TransactionWitness { witness_stack }];

    BitcoinTransaction {
        version: 0,
        locktime: 0,
        inputs: array![
            TransactionInput {
                previous_txid: to_spend_tx_id, script_sig: "", previous_vout: 0, sequence: 0,
            },
        ],
        outputs: array![TransactionOutput { value: 0, script_pubkey: script }],
        witness,
        is_segwit,
    }
}

fn build_p2tr_script_pubkey(pub_key: u256) -> ByteArray {
    let mut key_bytes: ByteArray = "";
    key_bytes.append_u256(pub_key);
    let key_array: Array<u8> = key_bytes.into();

    create_p2tr_script_pubkey(key_array)
}

fn build_p2wpkh_script_pubkey(public_key: @BitcoinPublicKey) -> ByteArray {
    if !public_key.is_compressed() {
        core::panic_with_felt252('p2wpkh requires compressed key');
    }

    let pubkey_bytes = public_key.bytes.clone();
    let pubkey_hash = hash160_from_byte_array(@pubkey_bytes);

    create_p2wpkh_script_pubkey(pubkey_hash)
}

fn get_transaction_id(tx: BitcoinTransaction) -> ByteArray {
    let mut encoder = TransactionEncoderTrait::new();
    let serialized = encoder.encode_transaction(tx);
    let first_hash = sha256_byte_array(@serialized);

    sha256_byte_array(@first_hash)
}

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

fn hash_for_witness_v0(sighash_type: SighashType, tx: @BitcoinTransaction) -> ByteArray {
    if tx.inputs.len() != 1 || tx.outputs.len() != 1 {
        core::panic_with_felt252('invalid inputs');
    }
    if tx.witness.len() == 0 || tx.witness[0].witness_stack.len() == 0 {
        core::panic_with_felt252('missing witness');
    }

    let prev_out_script = tx.witness[0].witness_stack[0];

    if prev_out_script.len() < 22 {
        core::panic_with_felt252('invalid script len');
    }
    if prev_out_script.at(0).unwrap() != 0x00 || prev_out_script.at(1).unwrap() != 0x14 {
        core::panic_with_felt252('invalid p2wpkh script');
    }

    let mut pubkey_hash: ByteArray = "";
    let mut idx: u32 = 2;
    while idx < prev_out_script.len() {
        pubkey_hash.append_byte(prev_out_script.at(idx).unwrap());
        idx += 1;
    }

    let input = tx.inputs[0];
    let output = tx.outputs[0];

    let mut prevouts: ByteArray = "";
    prevouts.append(input.previous_txid);
    prevouts.append_u32_le(*input.previous_vout);
    let hash_prevouts = {
        let first = sha256_byte_array(@prevouts);
        sha256_byte_array(@first)
    };

    let mut sequences: ByteArray = "";
    sequences.append_u32_le(*input.sequence);
    let hash_sequence = {
        let first = sha256_byte_array(@sequences);
        sha256_byte_array(@first)
    };

    let mut outputs: ByteArray = "";
    outputs.append_u64_le(*output.value);
    let script_len = output.script_pubkey.len();
    if script_len < 0xfd {
        outputs.append_byte(script_len.try_into().unwrap());
    } else if script_len <= 0xffff {
        outputs.append_byte(0xfd);
        outputs.append_u16_le(script_len.try_into().unwrap());
    } else if script_len <= 0xffffffff {
        outputs.append_byte(0xfe);
        outputs.append_u32_le(script_len.try_into().unwrap());
    } else {
        outputs.append_byte(0xff);
        outputs.append_u64_le(script_len.try_into().unwrap());
    }
    let output_script = output.script_pubkey.clone();
    outputs.append(@output_script);
    let hash_outputs = {
        let first = sha256_byte_array(@outputs);
        sha256_byte_array(@first)
    };

    let mut script_code: ByteArray = "";
    script_code.append_byte(0x76);
    script_code.append_byte(0xa9);
    script_code.append_byte(0x14);
    script_code.append(@pubkey_hash);
    script_code.append_byte(0x88);
    script_code.append_byte(0xac);

    let mut sighash_msg: ByteArray = "";
    sighash_msg.append_u32_le(*tx.version);
    sighash_msg.append(@hash_prevouts);
    sighash_msg.append(@hash_sequence);
    sighash_msg.append(input.previous_txid);
    sighash_msg.append_u32_le(*input.previous_vout);

    let script_code_len = script_code.len();
    if script_code_len < 0xfd {
        sighash_msg.append_byte(script_code_len.try_into().unwrap());
    } else if script_code_len <= 0xffff {
        sighash_msg.append_byte(0xfd);
        sighash_msg.append_u16_le(script_code_len.try_into().unwrap());
    } else if script_code_len <= 0xffffffff {
        sighash_msg.append_byte(0xfe);
        sighash_msg.append_u32_le(script_code_len.try_into().unwrap());
    } else {
        sighash_msg.append_byte(0xff);
        sighash_msg.append_u64_le(script_code_len.try_into().unwrap());
    }

    sighash_msg.append(@script_code);
    sighash_msg.append_u64_le(0);
    sighash_msg.append_u32_le(*input.sequence);
    sighash_msg.append(@hash_outputs);
    sighash_msg.append_u32_le(*tx.locktime);

    let sighash_flag: u32 = match sighash_type {
        SighashType::DEFAULT | SighashType::ALL => 1_u32,
    };
    sighash_msg.append_u32_le(sighash_flag);

    let first_hash = sha256_byte_array(@sighash_msg);
    sha256_byte_array(@first_hash)
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


pub fn bip322_msg_hash_p2tr_with_type(
    sighash_type: SighashType, pub_key: u256, message: ByteArray,
) -> ByteArray {
    let script_pubkey = build_p2tr_script_pubkey(pub_key);
    let to_spend_tx = build_to_spend_tx(@message, @script_pubkey);
    let to_spend_tx_id = get_transaction_id(to_spend_tx);
    let to_sign_tx = build_to_sign_tx(to_spend_tx_id, script_pubkey.clone(), false);

    hash_for_witness_v1(sighash_type, @to_sign_tx)
}

pub fn bip322_msg_hash_p2tr(pub_key: u256, message: ByteArray) -> ByteArray {
    bip322_msg_hash_p2tr_with_type(SighashType::ALL, pub_key, message)
}

pub fn bip322_msg_hash_p2wpkh_with_type(
    sighash_type: SighashType, public_key: BitcoinPublicKey, message: ByteArray,
) -> ByteArray {
    let script_pubkey = build_p2wpkh_script_pubkey(@public_key);
    let to_spend_tx = build_to_spend_tx(@message, @script_pubkey);
    let to_spend_tx_id = get_transaction_id(to_spend_tx);
    let to_sign_tx = build_to_sign_tx(to_spend_tx_id, script_pubkey.clone(), true);

    hash_for_witness_v0(sighash_type, @to_sign_tx)
}

pub fn bip322_msg_hash_p2wpkh(public_key: BitcoinPublicKey, message: ByteArray) -> ByteArray {
    bip322_msg_hash_p2wpkh_with_type(SighashType::ALL, public_key, message)
}
