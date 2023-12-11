use core::fmt::{Display, Debug, Formatter, Error};
use starknet::{ContractAddress, EthAddress, ClassHash, StorageAddress, StorageBaseAddress};


/// Display
mod display_felt252_based {
    use core::fmt::{Display, Formatter, Error};
    use core::to_byte_array::AppendFormattedToByteArray;
    impl TDisplay<T, +Into<T, felt252>, +Copy<T>> of Display<T> {
        fn fmt(self: @T, ref f: Formatter) -> Result<(), Error> {
            let value: felt252 = (*self).into();
            Display::<u256>::fmt(@value.into(), ref f)
        }
    }
}

impl EthAddressDisplay = display_felt252_based::TDisplay<EthAddress>;
impl ContractAddressDisplay = display_felt252_based::TDisplay<ContractAddress>;
impl ClassHashDisplay = display_felt252_based::TDisplay<ClassHash>;
impl StorageAddressDisplay = display_felt252_based::TDisplay<StorageAddress>;

/// Debug
mod debug_display_based {
    use core::fmt::{Display, Debug, Formatter, Error};
    use core::to_byte_array::AppendFormattedToByteArray;
    impl TDebug<T, +Display<T>> of Debug<T> {
        fn fmt(self: @T, ref f: Formatter) -> Result<(), Error> {
            Display::fmt(self, ref f)
        }
    }
}


impl EthAddressDebug = debug_display_based::TDebug<EthAddress>;
impl ContractAddressDebug = debug_display_based::TDebug<ContractAddress>;
impl ClassHashDebug = debug_display_based::TDebug<ClassHash>;
impl StorageAddressDebug = debug_display_based::TDebug<StorageAddress>;

impl ArrayTDebug<T, +Display<T>, +Copy<T>> of Debug<Array<T>> {
    fn fmt(self: @Array<T>, ref f: Formatter) -> Result<(), Error> {
        Debug::fmt(@self.span(), ref f)
    }
}

impl SpanTDebug<T, +Display<T>, +Copy<T>> of Debug<Span<T>> {
    fn fmt(self: @Span<T>, ref f: Formatter) -> Result<(), Error> {
        let mut self = *self;
        write!(f, "[")?;
        loop {
            match self.pop_front() {
                Option::Some(value) => {
                    if Display::fmt(value, ref f).is_err() {
                        break Result::Err(Error {});
                    };
                    if self.len() == 0 {
                        break Result::Ok(());
                    }
                    if write!(f, ", ").is_err() {
                        break Result::Err(Error {});
                    };
                },
                Option::None => { break Result::Ok(()); }
            };
        }?;
        write!(f, "]")
    }
}
