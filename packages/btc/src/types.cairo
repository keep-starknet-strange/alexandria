use starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256PointTrait, Secp256Trait};
use starknet::secp256k1::Secp256k1Point;

/// Helper function to convert hex character to nibble (4 bits)
fn hex_char_to_nibble(c: u8) -> u8 {
    if c >= '0' && c <= '9' {
        c - '0'
    } else if c >= 'a' && c <= 'f' {
        c - 'a' + 10
    } else if c >= 'A' && c <= 'F' {
        c - 'A' + 10
    } else {
        panic!("Invalid hex character")
    }
}

/// Bitcoin network types
#[derive(Copy, Drop, Serde, PartialEq)]
pub enum BitcoinNetwork {
    Mainnet,
    Testnet,
    Regtest,
}

/// Bitcoin address types
#[derive(Copy, Drop, Serde, PartialEq)]
pub enum BitcoinAddressType {
    P2PKH, // Pay to Public Key Hash (Legacy)
    P2SH, // Pay to Script Hash
    P2WPKH, // Pay to Witness Public Key Hash (SegWit v0)
    P2WSH, // Pay to Witness Script Hash (SegWit v0)
    P2TR // Pay to Taproot (SegWit v1)
}

/// Bitcoin public key representation (matches actual Bitcoin format)
#[derive(Clone, Drop, Serde)]
pub struct BitcoinPublicKey {
    /// Raw public key bytes (33 bytes compressed or 65 bytes uncompressed)
    pub bytes: ByteArray,
}

/// Legacy public key representation (for compatibility)
#[derive(Copy, Drop, Serde)]
pub struct BitcoinPublicKeyCoords {
    pub x: u256,
    pub y: u256,
}

/// Implementation for BitcoinPublicKey
impl BitcoinPublicKeyImpl of BitcoinPublicKeyTrait {
    /// Create a compressed public key from x-coordinate and y-parity
    ///
    /// #### Arguments
    /// * `x` - The x-coordinate (32 bytes)
    /// * `is_even_y` - Whether y-coordinate is even (true) or odd (false)
    ///
    /// #### Returns
    /// * `BitcoinPublicKey` - 33-byte compressed public key
    fn from_x_coordinate(x: u256, is_even_y: bool) -> BitcoinPublicKey {
        let mut bytes = Default::default();

        // Add prefix byte: 0x02 for even y, 0x03 for odd y
        if is_even_y {
            bytes.append_byte(0x02);
        } else {
            bytes.append_byte(0x03);
        }

        // Add x-coordinate (32 bytes, big-endian)
        bytes.append_word(x.high.into(), 16);
        bytes.append_word(x.low.into(), 16);

        BitcoinPublicKey { bytes }
    }

    /// Create an uncompressed public key from x and y coordinates
    ///
    /// #### Arguments
    /// * `x` - The x-coordinate (32 bytes)
    /// * `y` - The y-coordinate (32 bytes)
    ///
    /// #### Returns
    /// * `BitcoinPublicKey` - 65-byte uncompressed public key
    fn from_coordinates(x: u256, y: u256) -> BitcoinPublicKey {
        let mut bytes = Default::default();

        // Add prefix byte: 0x04 for uncompressed
        bytes.append_byte(0x04);

        // Add x-coordinate (32 bytes, big-endian)
        bytes.append_word(x.high.into(), 16);
        bytes.append_word(x.low.into(), 16);

        // Add y-coordinate (32 bytes, big-endian)
        bytes.append_word(y.high.into(), 16);
        bytes.append_word(y.low.into(), 16);

        BitcoinPublicKey { bytes }
    }

    /// Create from hex string (e.g.,
    /// "02862130f1fb98f93631802facfa603c943ad85626663fe79450de881a5222f4b2")
    ///
    /// #### Arguments
    /// * `hex_string` - Hex string of public key bytes
    ///
    /// #### Returns
    /// * `BitcoinPublicKey` - Public key from hex
    fn from_hex(hex_string: ByteArray) -> BitcoinPublicKey {
        // Parse hex string to bytes
        let mut bytes = "";
        let mut i = 0_usize;

        while i < hex_string.len() {
            if i + 1 < hex_string.len() {
                let c1 = hex_string.at(i).unwrap();
                let c2 = hex_string.at(i + 1).unwrap();

                let b1 = hex_char_to_nibble(c1);
                let b2 = hex_char_to_nibble(c2);

                let byte_val = b1 * 16 + b2;
                bytes.append_byte(byte_val);

                i += 2;
            } else {
                i += 1;
            }
        }

        BitcoinPublicKey { bytes }
    }

    /// Check if this is a compressed public key
    ///
    /// #### Returns
    /// * `bool` - True if compressed (33 bytes), false if uncompressed (65 bytes)
    fn is_compressed(self: @BitcoinPublicKey) -> bool {
        self.bytes.len() == 33
    }

    /// Get the x-coordinate from the public key
    ///
    /// #### Returns
    /// * `u256` - The x-coordinate
    fn get_x_coordinate(self: @BitcoinPublicKey) -> u256 {
        if self.bytes.len() < 33 {
            return 0;
        }

        // Extract bytes 1-32 (skip prefix byte)
        let mut x: u256 = 0;
        let mut i = 1_usize;
        while i < 33 {
            x = x * 256 + self.bytes.at(i).unwrap().into();
            i += 1;
        }
        x
    }

    /// Get the y-coordinate from uncompressed public key
    ///
    /// #### Returns
    /// * `Option<u256>` - The y-coordinate if uncompressed, None if compressed
    fn get_y_coordinate(self: @BitcoinPublicKey) -> Option<u256> {
        if self.bytes.len() != 65 {
            return Option::None;
        }

        // Extract bytes 33-64
        let mut y: u256 = 0;
        let mut i = 33_usize;
        while i < 65 {
            y = y * 256 + self.bytes.at(i).unwrap().into();
            i += 1;
        }
        Option::Some(y)
    }

    /// Convert to legacy coordinate format for compatibility.
    /// Always returns full affine coordinates, recovering `y` when needed.
    ///
    /// #### Returns
    /// * `BitcoinPublicKeyCoords` - Legacy format with x and y coordinates
    fn to_coords(self: @BitcoinPublicKey) -> BitcoinPublicKeyCoords {
        let x = self.get_x_coordinate();

        if !self.is_compressed() {
            let Option::Some(y) = self.get_y_coordinate() else {
                panic!("Missing y coordinate for uncompressed public key");
            };
            return BitcoinPublicKeyCoords { x, y };
        }

        assert!(self.bytes.len() == 33, "Invalid compressed public key length");
        let prefix = self.bytes.at(0).unwrap();
        assert!(prefix == 0x02 || prefix == 0x03, "Invalid compressed public key prefix");
        let y_is_odd = prefix == 0x03;

        let point_option = Secp256Trait::<
            Secp256k1Point,
        >::secp256_ec_get_point_from_x_syscall(x, y_is_odd)
            .unwrap_syscall();

        let Option::Some(point) = point_option else {
            panic!("Failed to recover compressed public key");
        };

        let (_, y) = point.get_coordinates().unwrap_syscall();
        BitcoinPublicKeyCoords { x, y }
    }
}

/// Trait for BitcoinPublicKey operations
pub trait BitcoinPublicKeyTrait {
    fn from_x_coordinate(x: u256, is_even_y: bool) -> BitcoinPublicKey;
    fn from_coordinates(x: u256, y: u256) -> BitcoinPublicKey;
    fn from_hex(hex_string: ByteArray) -> BitcoinPublicKey;
    fn is_compressed(self: @BitcoinPublicKey) -> bool;
    fn get_x_coordinate(self: @BitcoinPublicKey) -> u256;
    fn get_y_coordinate(self: @BitcoinPublicKey) -> Option<u256>;
    fn to_coords(self: @BitcoinPublicKey) -> BitcoinPublicKeyCoords;
}

/// Bitcoin address structure
#[derive(Drop, Serde)]
pub struct BitcoinAddress {
    pub address: ByteArray,
    pub address_type: BitcoinAddressType,
    pub network: BitcoinNetwork,
    pub script_pubkey: ByteArray,
}

/// Private key structure
#[derive(Copy, Drop, Serde)]
pub struct BitcoinPrivateKey {
    pub key: u256,
    pub network: BitcoinNetwork,
    pub compressed: bool,
}

/// Bitcoin transaction input structure
#[derive(Clone, Drop, Serde)]
pub struct TransactionInput {
    /// Previous transaction hash (32 bytes, reversed)
    pub previous_txid: ByteArray,
    /// Previous output index
    pub previous_vout: u32,
    /// Script signature
    pub script_sig: ByteArray,
    /// Sequence number
    pub sequence: u32,
}

/// Bitcoin transaction output structure
#[derive(Clone, Drop, Serde)]
pub struct TransactionOutput {
    /// Value in satoshis
    pub value: u64,
    /// Script public key
    pub script_pubkey: ByteArray,
}

/// Bitcoin transaction witness data
#[derive(Clone, Drop, Serde)]
pub struct TransactionWitness {
    /// Array of witness stack items
    pub witness_stack: Array<ByteArray>,
}

/// Complete Bitcoin transaction structure
#[derive(Clone, Drop, Serde)]
pub struct BitcoinTransaction {
    /// Transaction version
    pub version: u32,
    /// Array of transaction inputs
    pub inputs: Array<TransactionInput>,
    /// Array of transaction outputs
    pub outputs: Array<TransactionOutput>,
    /// Lock time
    pub locktime: u32,
    /// Witness data (for SegWit transactions)
    pub witness: Array<TransactionWitness>,
    /// Whether this is a SegWit transaction
    pub is_segwit: bool,
}

/// Bitcoin transaction decoder context
#[derive(Clone, Drop, Serde)]
pub struct BTCDecoder {
    /// Raw transaction data
    pub data: ByteArray,
    /// Current reading offset
    pub offset: usize,
}

/// Bitcoin transaction encoder context
#[derive(Clone, Drop, Serde)]
pub struct BTCEncoder {
    /// Output transaction data buffer
    pub data: ByteArray,
}

impl BitcoinNetworkImpl of Into<BitcoinNetwork, u8> {
    /// Converts a Bitcoin network enum to its corresponding address prefix byte.
    ///
    /// This conversion is used when generating Bitcoin addresses to determine
    /// the appropriate version byte for different network types.
    ///
    /// #### Arguments
    /// * `self` - The Bitcoin network type to convert
    ///
    /// #### Returns
    /// * `u8` - The network prefix byte (0x00 for mainnet, 0x6f for testnet/regtest)
    fn into(self: BitcoinNetwork) -> u8 {
        match self {
            BitcoinNetwork::Mainnet => 0x00,
            BitcoinNetwork::Testnet => 0x6f,
            BitcoinNetwork::Regtest => 0x6f,
        }
    }
}

impl BitcoinAddressTypeImpl of Into<BitcoinAddressType, u8> {
    /// Converts a Bitcoin address type to its corresponding version prefix byte.
    ///
    /// This function maps Bitcoin address types to their respective version bytes
    /// used in Base58Check encoding for legacy address formats. SegWit addresses
    /// (P2WPKH, P2WSH, P2TR) use bech32 encoding and return 0x00 as they don't
    /// use traditional version bytes.
    ///
    /// #### Arguments
    /// * `self` - The Bitcoin address type to convert
    ///
    /// #### Returns
    /// * `u8` - The version byte (0x00 for P2PKH, 0x05 for P2SH on mainnet)
    fn into(self: BitcoinAddressType) -> u8 {
        match self {
            BitcoinAddressType::P2PKH => 0x00, // Mainnet prefix
            BitcoinAddressType::P2SH => 0x05, // Mainnet prefix
            BitcoinAddressType::P2WPKH => 0x00, // Handled by bech32
            BitcoinAddressType::P2WSH => 0x00, // Handled by bech32
            BitcoinAddressType::P2TR => 0x00 // Handled by bech32
        }
    }
}
