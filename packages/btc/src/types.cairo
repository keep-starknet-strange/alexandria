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

/// Public key representation
#[derive(Copy, Drop, Serde)]
pub struct BitcoinPublicKey {
    pub x: u256,
    pub y: u256,
    pub compressed: bool,
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

impl BitcoinNetworkImpl of Into<BitcoinNetwork, u8> {
    fn into(self: BitcoinNetwork) -> u8 {
        match self {
            BitcoinNetwork::Mainnet => 0x00,
            BitcoinNetwork::Testnet => 0x6f,
            BitcoinNetwork::Regtest => 0x6f,
        }
    }
}

impl BitcoinAddressTypeImpl of Into<BitcoinAddressType, u8> {
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
