use core::fmt::{Debug, Display, Error, Formatter};
use starknet::{ClassHash, ContractAddress, EthAddress, StorageAddress};


/// Display
mod display_felt252_based {
    use core::fmt::{Display, Error, Formatter};
    pub impl TDisplay<T, +Into<T, felt252>, +Copy<T>> of Display<T> {
        fn fmt(self: @T, ref f: Formatter) -> Result<(), Error> {
            let value: felt252 = (*self).into();
            Display::<u256>::fmt(@value.into(), ref f)
        }
    }
}

pub impl EthAddressDisplay = display_felt252_based::TDisplay<EthAddress>;
pub impl ContractAddressDisplay = display_felt252_based::TDisplay<ContractAddress>;
pub impl ClassHashDisplay = display_felt252_based::TDisplay<ClassHash>;
pub impl StorageAddressDisplay = display_felt252_based::TDisplay<StorageAddress>;

/// Debug
mod debug_display_based {
    use core::fmt::{Debug, Display, Error, Formatter};
    pub impl TDebug<T, +Display<T>> of Debug<T> {
        fn fmt(self: @T, ref f: Formatter) -> Result<(), Error> {
            Display::fmt(self, ref f)
        }
    }
}


pub impl EthAddressDebug = debug_display_based::TDebug<EthAddress>;
pub impl ContractAddressDebug = debug_display_based::TDebug<ContractAddress>;
pub impl ClassHashDebug = debug_display_based::TDebug<ClassHash>;
pub impl StorageAddressDebug = debug_display_based::TDebug<StorageAddress>;

impl ArrayTDebug<T, +Display<T>, +Copy<T>> of Debug<Array<T>> {
    fn fmt(self: @Array<T>, ref f: Formatter) -> Result<(), Error> {
        Debug::fmt(@self.span(), ref f)
    }
}

pub impl SpanTDebug<T, +Display<T>, +Copy<T>> of Debug<Span<T>> {
    fn fmt(self: @Span<T>, ref f: Formatter) -> Result<(), Error> {
        let mut self = *self;
        write!(f, "[")?;
        loop {
            match self.pop_front() {
                Option::Some(value) => {
                    if Display::fmt(value, ref f).is_err() {
                        break Result::Err(Error {});
                    }
                    if self.len() == 0 {
                        break Result::Ok(());
                    }
                    if write!(f, ", ").is_err() {
                        break Result::Err(Error {});
                    };
                },
                Option::None => { break Result::Ok(()); },
            };
        }?;
        write!(f, "]")
    }
}
