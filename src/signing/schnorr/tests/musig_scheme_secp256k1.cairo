// Below is presented a MuSig scheme where two signers can sign a single message.
// To do this, the secp256k1 curve is used.

use core::clone::Clone;
use array::ArrayTrait;
use core::traits::Into;
use test::test_utils::{assert_eq, assert_ne};
use option::OptionTrait;
use starknet::secp256k1::{secp256k1_new_syscall, Secp256k1Point};
use starknet::secp256_trait::{Secp256Trait, Secp256PointTrait};
use starknet::{SyscallResult, SyscallResultTrait};
use debug::PrintTrait;
use core::result::ResultTrait;
use traits::{TryInto};
use core::traits::Default;
use integer::{
    BoundedInt, u128_wrapping_sub, u16_sqrt, u32_sqrt, u64_sqrt, u8_sqrt, u512, u256_wide_mul,
    u256_as_non_zero, u512_safe_div_rem_by_u256, u128_as_non_zero
};
use test::test_utils::{assert_le, assert_lt, assert_gt, assert_ge};

// Generator Point:

fn get_generator_point() -> Secp256k1Point {
    secp256k1_new_syscall(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
    )
        .unwrap_syscall()
        .unwrap()
}

// Curve Size:

fn get_curve_size() -> u256 {
        0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
    }

// Private Keys:

fn Alice_PrivKey() -> u256 {
    0x2
}

fn Bob_PrivKey() -> u256 {
    0x3
}

// Nonces:

fn Alice_Nonce() -> u256 {
    0x4
}

fn Bob_Nonce() -> u256 {
    0x5
}

#[test]
#[available_gas(1000000000)]
fn verification() {

    // Generator:

    let (Gx, Gy) = get_generator_point().get_coordinates().unwrap_syscall();

    // Privates Keys:

    let Alice_PrivKey = Alice_PrivKey();
    let Bob_PrivKey  = Bob_PrivKey();

    //Public Keys:

    let gx_gy = secp256k1_new_syscall(Gx,Gy).unwrap_syscall().unwrap();

    let Alice_PublicKey = gx_gy.mul(Alice_PrivKey).unwrap_syscall();
    let Bob_PublicKey = gx_gy.mul(Bob_PrivKey).unwrap_syscall();

    // Nonces:

    let Alice_Nonce = Alice_Nonce();
    let Bob_Nonce  = Bob_Nonce();

    // Public Nonce:

    let Alice_PublicNonce = gx_gy.mul(Alice_Nonce).unwrap_syscall();
    let Bob_PublicNonce = gx_gy.mul(Bob_Nonce).unwrap_syscall();

    // Aggretaged Public Nonce:
    
    let R = Alice_PublicNonce.add(Bob_PublicNonce).unwrap_syscall();

    // Hash of the public key set:

    let (P_x_Alice, P_y_Alice) = Alice_PublicKey.get_coordinates().unwrap_syscall();
    let (P_x_Bob, P_y_Bob) = Bob_PublicKey.get_coordinates().unwrap_syscall();

    let l = keccak::keccak_u256s_le_inputs(array![P_x_Alice, P_x_Bob].span());

    // Weight factor:

    let w_a = keccak::keccak_u256s_le_inputs(array![l, P_x_Alice].span());
    let w_b = keccak::keccak_u256s_le_inputs(array![l, P_x_Bob].span());

    // Aggretaged public key:

    let X_1 = Alice_PublicKey.mul(w_a).unwrap_syscall();
    let X_2 = Bob_PublicKey.mul(w_b).unwrap_syscall();

    let X = X_1.add(X_2).unwrap_syscall();    

    // Challenge e:

    let (R_x_aggregated, R_y_aggregated) = R.get_coordinates().unwrap_syscall();
    let (X_x_aggretaged, X_y_aggregated) = X.get_coordinates().unwrap_syscall();

    let msg = 'Hello, Starknet';

    let e = keccak::keccak_u256s_le_inputs(array![R_x_aggregated, X_x_aggretaged, msg].span());

    // Signature:

    let p = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141_u256.try_into().unwrap();

    let (_, w_a_e) = u512_safe_div_rem_by_u256(u256_wide_mul(w_a, e), p);
    let (_, AlicePriv_w_a_e) = u512_safe_div_rem_by_u256(u256_wide_mul(w_a_e, Alice_PrivKey()), p);
    let s_a = ((Alice_Nonce + AlicePriv_w_a_e) % 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141);

    let (_, w_b_e) = u512_safe_div_rem_by_u256(u256_wide_mul(w_b, e), p);
    let (_, BobPriv_w_b_e) = u512_safe_div_rem_by_u256(u256_wide_mul(w_b_e, Bob_PrivKey()), p);
    let s_b = ((Bob_Nonce + BobPriv_w_b_e) % 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141);

    // Aggregated Signature:

    let s = ((s_a + s_b) % 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141);

    // Verification:

    let sG = gx_gy.mul(s).unwrap_syscall();

    let xx_yy = secp256k1_new_syscall(X_x_aggretaged, X_y_aggregated).unwrap_syscall().unwrap();
    let eX = xx_yy.mul(e).unwrap_syscall();
    
    let rx_ry = secp256k1_new_syscall(R_x_aggregated, R_y_aggregated).unwrap_syscall().unwrap();
    let R_eX = rx_ry.add(eX).unwrap_syscall();
    
    let (x, y) = sG.get_coordinates().unwrap_syscall();
    let (x2, y2) = R_eX.get_coordinates().unwrap_syscall();
    
    if x != x2 || y != y2 {
        panic_with_felt252('error, sG is equal to R_eX')
    }  

}
