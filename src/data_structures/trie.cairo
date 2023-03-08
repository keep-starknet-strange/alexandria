//! Trie implementation
//!
//! # Example
//! ```
//! use quaireaux::data_structures::trie::TrieTrait;
//! IMPLEMENTATION CURRENTLY BROKEN
//! TODO: blocked by nested types support in Cairo
//! TODO: impl w/ dictionairy/hashmap
//! TODO: dict squash

// Core lib imports
use dict::DictFeltToTrait;
use option::OptionTrait;

/// Node representation
#[derive(Drop)]
struct Node {
    children: DictFeltTo::<Node>,
    value: felt,
}

trait NodeTrait {
    fn new() -> Node;
}

impl NodeImpl of NodeTrait {
    fn new(value: felt) -> Node {
        let children = DictFeltToTrait::<Node>::new();
        Node {
            children: children,
            value: value,
        }
    }
}

/// Trie representation
#[derive(Drop)]
struct Trie {
    root: Node,
}

/// Trie trait
trait TrieTrait {
    /// Create a new Trie instance
    fn new() -> Trie;
    /// Insert a key, value into the Trie
    fn insert(ref self: Trie, key: Array::<felt>, value: felt);
    /// Get a value from the Trie at a given key
    fn get(ref self: Trie, key: Array::<felt>) -> felt;
}

/// Trie implementation
impl TrieImpl of TrieTrait {
    fn new() -> Trie {
        let root = NodeTrait::new(0);
        Trie { root: root }
    }

    fn insert(ref self: Trie, key: Array::<felt>, value: felt) {
        _insert(ref self.root, key, 0_u32, value)
    }

    fn get(ref self: Trie, key: Array::<felt>) -> felt {
        _get(ref self.root, key, 0_u32)
    }
}

fn _insert(ref node: Node, key: Array::<felt>, key_index: u32, value: felt) {
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if key_index == key.len() {
        return ();
    }

    let key_size = key.len() - 1_u32;
    let prefix = key.at(key_index);
    let child = node.children.get(*prefix);

    // TODO: how to check that dict key is empty for non primative value
    if child == 0 {
        if key_index == key_size {
            let mut n = NodeTrait::new(value);
            node.children.insert(*prefix, n);
            return ();
        }
        let mut new_node = NodeTrait::new(0);
        node.children.insert(*prefix, new_node);
        let mut n = node.children.get(*prefix);
        _insert(ref n, key, key_index + 1_u32, value)
    }

    _insert(ref child, key, key_index + 1_32, value);
}

fn _get(ref node: Node, key: @Array::<felt>, key_index: u32) -> Option::<felt> {
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if key_index == key.len() {
        return Option::None(());
    }

    let prefix = key.at(key_index);
    let child = node.children.get(*prefix);

    // TODO: how to check that dict key is empty for non primative value
    if child == 0 {
        return Option::None(());
    }

    let key_size = key.len() - 1_u32;
    if key_index == key_size {
        return Option::Some(child.value);
    }

    _get(ref child, key, key_index + 1_u32)
}
