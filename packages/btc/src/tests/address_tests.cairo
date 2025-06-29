use alexandria_btc::address::{private_key_to_address, public_key_to_address, validate_address};
use alexandria_btc::keys::{create_private_key, private_key_to_public_key};
use alexandria_btc::types::{BitcoinAddressType, BitcoinNetwork};

#[test]
fn test_create_private_key() {
    let private_key = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    assert!(private_key.key == 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef);
    assert!(private_key.network == BitcoinNetwork::Mainnet);
    assert!(private_key.compressed == true);
}

#[test]
fn test_private_to_public_key() {
    let private_key = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let public_key = private_key_to_public_key(private_key);

    // Verify the public key was generated (simplified check)
    assert!(public_key.x != 0);
    assert!(public_key.y != 0);
    assert!(public_key.compressed == true);
}

#[test]
fn test_generate_p2pkh_address() {
    let private_key = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let address = private_key_to_address(private_key, BitcoinAddressType::P2PKH);

    assert!(address.address_type == BitcoinAddressType::P2PKH);
    assert!(address.network == BitcoinNetwork::Mainnet);
    assert!(address.address.len() > 0);
    assert!(address.script_pubkey.len() > 0);
}

#[test]
fn test_generate_p2sh_address() {
    let private_key = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let address = private_key_to_address(private_key, BitcoinAddressType::P2SH);

    assert!(address.address_type == BitcoinAddressType::P2SH);
    assert!(address.network == BitcoinNetwork::Mainnet);
    assert!(address.address.len() > 0);
    assert!(address.script_pubkey.len() > 0);
}

#[test]
fn test_generate_p2wpkh_address() {
    let private_key = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let address = private_key_to_address(private_key, BitcoinAddressType::P2WPKH);

    assert!(address.address_type == BitcoinAddressType::P2WPKH);
    assert!(address.network == BitcoinNetwork::Mainnet);
    assert!(address.address.len() > 0);
    assert!(address.script_pubkey.len() > 0);
}

#[test]
fn test_generate_p2tr_address() {
    let private_key = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let address = private_key_to_address(private_key, BitcoinAddressType::P2TR);

    assert!(address.address_type == BitcoinAddressType::P2TR);
    assert!(address.network == BitcoinNetwork::Mainnet);
    assert!(address.address.len() > 0);
    assert!(address.script_pubkey.len() > 0);
}

#[test]
fn test_different_networks() {
    let private_key_mainnet = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let private_key_testnet = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Testnet,
        true,
    );

    let address_mainnet = private_key_to_address(private_key_mainnet, BitcoinAddressType::P2PKH);
    let address_testnet = private_key_to_address(private_key_testnet, BitcoinAddressType::P2PKH);

    assert!(address_mainnet.network == BitcoinNetwork::Mainnet);
    assert!(address_testnet.network == BitcoinNetwork::Testnet);

    // Addresses should be different due to different network prefixes
    assert!(address_mainnet.address != address_testnet.address);
}

#[test]
fn test_compressed_vs_uncompressed() {
    let private_key_compressed = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        true,
    );

    let private_key_uncompressed = create_private_key(
        0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
        BitcoinNetwork::Mainnet,
        false,
    );

    let public_key_compressed = private_key_to_public_key(private_key_compressed);
    let public_key_uncompressed = private_key_to_public_key(private_key_uncompressed);

    let address_compressed = public_key_to_address(
        public_key_compressed, BitcoinAddressType::P2PKH, BitcoinNetwork::Mainnet,
    );
    let address_uncompressed = public_key_to_address(
        public_key_uncompressed, BitcoinAddressType::P2PKH, BitcoinNetwork::Mainnet,
    );

    // Addresses should be different due to different public key formats
    assert!(address_compressed.address != address_uncompressed.address);
}

#[test]
fn test_address_validation() {
    // Test valid mainnet address format (simplified)
    let valid_mainnet = "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa";
    assert!(validate_address(valid_mainnet, BitcoinNetwork::Mainnet) == true);

    // Test valid testnet address format (simplified)
    let valid_testnet = "mipcBbFg9gMiCh81Kj8tqqdgoZub1ZJRfn";
    assert!(validate_address(valid_testnet, BitcoinNetwork::Testnet) == true);
}

#[test]
#[should_panic]
fn test_invalid_private_key_zero() {
    create_private_key(0, BitcoinNetwork::Mainnet, true);
}

#[test]
#[should_panic]
fn test_invalid_private_key_too_large() {
    let invalid_key = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364142;
    create_private_key(invalid_key, BitcoinNetwork::Mainnet, true);
}
