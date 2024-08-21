mod bubble_sort;
pub mod interface;
pub mod merge_sort;
pub mod quick_sort;
#[cfg(test)]
mod tests;

pub use bubble_sort::BubbleSort;
pub use interface::{Sortable, SortableVec};
pub use merge_sort::MergeSort;
pub use quick_sort::QuickSort;

