use alexandria_evm::selector;
use selector::SelectorTrait;

#[test]
fn test_compute_selector() {
    let data: ByteArray = "transfer(address,uint256)";
    let selector_value = SelectorTrait::compute_selector(data);
    assert!(selector_value == 0xA9059CBB);
}

#[test]
fn test_compute_selector_long() {
    let mut data: ByteArray =
        "transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256) transfer(address,uint256)";
    let selector_value = SelectorTrait::compute_selector(data);
    assert!(selector_value == 0xF9ECAE0B);
}

#[test]
fn test_compute_empty_selector() {
    let mut data: ByteArray = "";
    let selector_value = SelectorTrait::compute_selector(data);
    assert!(selector_value == 0xC5D24601);
}
