/// Bitcoin network types
#[derive(Copy, Drop, Serde, PartialEq)]
pub enum Network {
    Mainnet,
    Testnet,
    Regtest,
}

/// Bitcoin address types
#[derive(Copy, Drop, Serde, PartialEq)]
pub enum AddressType {
    P2PKH, // Pay to Public Key Hash (Legacy)
    P2SH, // Pay to Script Hash
    P2WPKH, // Pay to Witness Public Key Hash (SegWit v0)
    P2WSH, // Pay to Witness Script Hash (SegWit v0)
    P2TR // Pay to Taproot (SegWit v1)
}

/// Public key representation
#[derive(Copy, Drop, Serde)]
pub struct PublicKey {
    pub x: u256,
    pub y: u256,
    pub compressed: bool,
}

/// Bitcoin address structure
#[derive(Drop, Serde)]
pub struct BitcoinAddress {
    pub address: ByteArray,
    pub address_type: AddressType,
    pub network: Network,
    pub script_pubkey: ByteArray,
}

/// Private key structure
#[derive(Copy, Drop, Serde)]
pub struct PrivateKey {
    pub key: u256,
    pub network: Network,
    pub compressed: bool,
}

impl NetworkImpl of Into<Network, u8> {
    fn into(self: Network) -> u8 {
        match self {
            Network::Mainnet => 0x00,
            Network::Testnet => 0x6f,
            Network::Regtest => 0x6f,
        }
    }
}

impl AddressTypeImpl of Into<AddressType, u8> {
    fn into(self: AddressType) -> u8 {
        match self {
            AddressType::P2PKH => 0x00, // Mainnet prefix
            AddressType::P2SH => 0x05, // Mainnet prefix
            AddressType::P2WPKH => 0x00, // Handled by bech32
            AddressType::P2WSH => 0x00, // Handled by bech32
            AddressType::P2TR => 0x00 // Handled by bech32
        }
    }
}
