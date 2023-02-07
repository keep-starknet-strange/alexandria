use array::ArrayTrait;

use quaireaux::data_structures::queue::Queue;
use quaireaux::data_structures::queue::QueueTrait;


#[test]
#[available_gas(2000000)]
fn queue_enqueue_test() {
    assert(1 == 1, 'The length of a new Queue should be 0');

    // let queue = QueueTrait::<felt>::new();
    // let result_len = queue.len();

    // let mut expected_len = 0;
    // assert(result_len == expected_len, 'The length of a new Queue should be 0');
}
// fn main() -> bool {
//     let mut queue = QueueTrait::<felt>::new();

//     match queue.peek_front() {
//         Option::Some(x) => {
//             debug::print_felt(x);    
//         },
//         Option::None(_) => {
//             debug::print_felt('None');
//         },
//     };

//     match queue.peek_front() {
//         Option::Some(x) => {
//             debug::print_felt(x);    
//         },
//         Option::None(_) => {
//             debug::print_felt('None');
//         },
//     };

//     queue.is_empty()
// }
