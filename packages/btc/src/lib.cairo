mod bip340_signature;
mod legacy_signature;
mod constants;
mod utils;

#[cfg(test)]
mod tests;
use bip340_signature::verify_bip340_signature;
use legacy_signature::{
    verify_legacy_signature,
    get_legacy_message_hash
};
