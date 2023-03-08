// Core lib imports
use array::ArrayTrait;

// Internal imports
//! IMPLEMENTATION CURRENTLY BROKEN
use quaireaux::data_structures::trie::TrieTrait;

#[test]
#[available_gas(2000000)]
fn test_trie() {
    let mut this_key = array_new::<felt>();

    // this - 74 68 69 73
    key.append(74);
    key.append(68);
    key.append(69);
    key.append(73);

    let mut that_key = array_new::<felt>();

    // that - 74 68 61 74
    key.append(74);
    key.append(68);
    key.append(69);
    key.append(73);

    let mut trie = Trie::new();
    trie.insert(this_key, 1);
    trie.insert(that_key, 2);

    let mut test_key = array_new::<felt>();

    // that - 74 68 61 74
    key.append(74);
    key.append(68);
    key.append(69);
    key.append(73);

    let val = trie.get(test_key);
    assert(val == 2, 'value should be 2')
}
