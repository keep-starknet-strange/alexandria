//! Trie implementation
//!
//! # Example
//! ```
//! use quaireaux::data_structures::trie::TrieTrait;
//! TODO: implement with generics
//! TODO: implement use option::OptionTrait;

// Core lib imports
use array::ArrayTrait;
use dict::DictFeltToTrait;
use hash::LegacyHash;

/// Node representation
// #[derive(Drop)]
struct Node {
    /// needs to impl a hashmap with a node as val
		children: DictFeltTo::<felt>,
    val: felt,
}

trait NodeTrait {
    fn new() -> Node;
}

impl NodeImpl of NodeTrait {
    fn new() -> Node {
        let children = DictFeltToTrait::new();
        Node {
            children: children,
            val: 0,
        }
    }
}

/// Trie representation
// #[derive(Drop)]
struct Trie {
    root: Node,
}

/// Trie trait
trait TrieTrait {
    /// Create a new Trie instance
    fn new() -> Trie;
    /// Insert a key, value into the Trie
    fn insert(ref self: Trie, key: Array::<felt>, value: felt) -> bool;
    /// Get a value from the Trie at a given key
    fn get(ref self: Trie, key: Array::<felt>) -> felt;
}

/// Trie implementation
impl TrieImpl of TrieTrait {
    /// Create a new Trie instance
    fn new() -> Trie {
        let root = NodeTrait::new();
        Trie { root: root }
    }

    /// Insert a key, value into the Trie
    /// # Arguments
    /// * `key` - The key at which to insert
    /// * `value` - The value to insert
    /// # Returns
    /// True if insert successful
    fn insert(ref self: Trie, key: Array::<felt>, value: felt) -> bool {
        false
    }

    /// Get a value from the Trie at a given key
    /// # Arguments
    /// * `key` - The key at which to insert
    /// # Returns
    /// Value at given key
    fn get(ref self: Trie, key: Array::<felt>) -> felt {
        let key_len = key.len();
        internal_check(self.root.children, 0_u32, key_len, key)
    }
}

fn internal_check(mut children: DictFeltTo::<felt>, key_index: u32, key_len: usize, mut key: Array::<felt>) -> felt {
    if key_len == 0_u32 {
        return 0;
    }

    let key_element = key.at(key_index);

    let val = children.get(*key_element);
    let squashed_dict = children.squash();

    if val != 0 {
        return val;
    }
    internal_check(children, key_index + 1_u32, key_len - 1_u32, key)
}
