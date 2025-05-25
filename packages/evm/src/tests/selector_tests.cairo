use selector::SelectorTrait;
use crate::selector;

#[test]
fn test_compute_selector() {
    let data: ByteArray = "transfer(address,uint256)";
    let selector_value = SelectorTrait::compute_selector(data);
    assert_eq!(selector_value, 0xA9059CBB);
}

#[test]
fn test_compute_selector_long() {
    let mut data: ByteArray =
        "transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256)";
    let selector_value = SelectorTrait::compute_selector(data);
    assert_eq!(selector_value, 0xF9ECAE0B);
}

#[test]
fn test_compute_empty_selector() {
    let mut data: ByteArray = "";
    let selector_value = SelectorTrait::compute_selector(data);
    assert_eq!(selector_value, 0xC5D24601);
}
