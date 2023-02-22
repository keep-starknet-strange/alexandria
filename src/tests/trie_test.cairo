// Core lib imports
use array::ArrayTrait;

// Internal imports
use quaireaux::data_structures::trie::TrieTrait;

#[test]
#[available_gas(2000000)]
fn trie_test() {
    let mut t = TrieTrait::new();
    let mut key = ArrayTrait::new();
    key.append(1);
    key.append(2);

    let val = t.get(key);
    assert(val == 0, 'should be zero');
}
