pub mod bubble_sort;
pub mod interface;
pub mod merge_sort;
pub mod quick_sort;
#[cfg(test)]
mod tests;

pub use bubble_sort::BubbleSortImpl;
pub use interface::Sortable;
use merge_sort::merge;
// use quick_sort::quick_sort; // Cannot do as name collide.


