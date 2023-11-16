// LENGTH
const RLP_EMPTY_INPUT: felt252 = 'KKT: EmptyInput';
const RLP_INPUT_TOO_SHORT: felt252 = 'KKT: InputTooShort';

#[derive(Drop, Copy, PartialEq)]
enum RLPError {
    EmptyInput: felt252,
    InputTooShort: felt252,
}

impl RLPErrorIntoU256 of Into<RLPError, u256> {
    fn into(self: RLPError) -> u256 {
        match self {
            RLPError::EmptyInput(error_message) => error_message.into(),
            RLPError::InputTooShort(error_message) => error_message.into(),
        }
    }
}
