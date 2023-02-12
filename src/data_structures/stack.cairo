//! Stack implementation.
//!
//! # Example
//! ```
//! use quaireaux::data_structures::stack::StacTrait;
//!
//! // Create a new stack instance.
//! let mut stack = StacTrait::new();
//! # TODO: Add example code for the different methods.

// Core lib imports
use dict::DictFeltToTrait;

//! Stack module
/// Stack representation.
// #[derive(Drop, Copy)]
struct Stack {
    //TODO: Question, do we need "word_dict_start" in CairoV1?
    word_dict_start: DictFeltTo::<T>,
    word_dict: DictFeltTo::<T>,
    len: felt,
}

// #[derive(Drop, Copy)]
struct Summary {
    squashed_start: SquashedDictFeltTo::<T>,
    squashed_end: SquashedDictFeltTo::<T>,
    len: felt,
}

trait StackTrait<T> {
    fn new() -> Stack;
    fn push(ref self: Stack, value: T);
    fn pop(ref self: Stack) -> Option::<T>;
    fn peek(ref self: Stack, idx: u32) -> Option::<T>;
    fn len(ref self: Stack) -> u128;
    fn swap_i(ref self: Stack, i: felt);
    fn finalize(ref self: Stack) -> Summary;
}
impl StackImpl<T> of StackTrait::<T> {
    // Stack New Function
    fn new() -> Stack {
        let new_word_dict = new::DictFeltTo < T > ();
        Stack { word_dict_start: new_word_dict, word_dict: new_word_dict, len: 0,  }
    }

    // Stack Push function
    fn push(ref self: Stack, value: T) {
        // First Deconstruct? (Why do we need to deconstruct)?
        // Get initial word_dict and initial_len
        let Stack{word_dict: mut word_dict, word_dict_start: mut word_dict_start, len: mut len } =
            self;
        //TODO: Overflow check?

        //Insert new value to Stack
        word_dict.insert(len, value);

        //TODO: If we have a uint256 or any struct as "value", do we need to increment +2 or +n instead of +1?
        let new_len = len + 1;
        self = Stack { word_dict_start, word_dict, new_len };
    }

    //Stack Pop Function
    fn pop(ref self: Stack) -> Option::<T> {
        let Stack{word_dict: mut word_dict, word_dict_start: mut word_dict_start, len: mut len } =
            self;

        // Check if len > 0
        if len <= 0 {
            return Option::<T>::None(());
        }

        // Get "value" at index "len"      
        let value = word_dict.get(len);
        let new_len = len - 1;
        self = Stack { word_dict_start, word_dict, new_len };

        //Return value
        return Option::<T>::Some(value);
    }

    fn peek(ref self: Stack, index: u32) -> Option::<T> {
        let Stack{word_dict: mut word_dict, word_dict_start: mut word_dict_start, len: mut len } =
            self;

        // Check if index is within len
        if len < index {
            return Option::<T>::None(());
        }
        // Get "value" at "index"
        let value = word_dict.get(index);

        let new_len = len - 1;
        self = Stack { word_dict_start, word_dict, new_len };

        // Return value
        return Option::<T>::Some(value);
    }

    fn len(ref self: Stack) -> felt {
        let Stack{len: len } = self;

        return len;
    }

    fn swap_i(ref self: Stack, i: felt) {
        let Stack{word_dict_start: word_dict_start, word_dict: word_dict, len: len } = self;
        len
        i_index = len - i;
        // Check if i <= len
        if len < i {
            return Option::<T>::None(());
        }
        // Get "values" to "swap"
        let value_i = word_dict.get(i_index);
        let value_len = word_dict.get(len);
        // "Swap" value
        word_dict.insert(len, value_i);
        word_dict.insert(i_index, value_len);
    }

    fn finalize(ref self: Stack) -> Summary {
        let Stack{word_dict_start: word_dict_start, word_dict: word_dict, len: len } = self;

        // Finalize both dicts
        let word_dict_start_finalized = word_start_dict.finalize();
        let word_dict_finalized = word_dict.finalize();
        // Create and return summary
        Summary {
            squashed_start: word_dict_start_finalized, squashed_end: word_dict_finalized, len: len, 
        }
    }
}
// impl Array2DU8Drop of Drop::<Array::<Array::<u8>>>;
// impl Array2DU8Copy of Copy::<Array::<Array::<u8>>>;



