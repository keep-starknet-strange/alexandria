mod bubble_sort;
pub mod interface;
mod merge_sort;
pub mod quick_sort;
#[cfg(test)]
mod tests;

pub use bubble_sort::BubbleSort;
pub use interface::Sortable;
pub use merge_sort::MergeSort;
// use quick_sort::quick_sort; // Cannot do as name collide.


