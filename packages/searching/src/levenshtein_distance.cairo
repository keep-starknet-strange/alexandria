// The Levenshtein Distance
use core::dict::Felt252DictTrait;

/// Compute the edit distance between two byte arrays
/// * `arr1` - The first byte array.
/// * `arr2` - The second byte array.
/// # Returns
/// * `usize` - The edit distance between the two byte arrays.
pub fn levenshtein_distance(arr1: @ByteArray, arr2: @ByteArray) -> usize {
    // Get the lengths of both arrays
    let arr1_len = arr1.len();
    let arr2_len = arr2.len();

    // If the first array is empty, the distance is the length of the second array
    if arr1_len == 0 {
        return arr2_len;
    }

    // Initialize a dictionary to store previous distances, with keys and values as indices
    let mut prev_distances = Default::default();
    let mut index: usize = 0;
    // Break the loop when index equals the length of the first array plus 1
    while index != arr1_len + 1 {
        prev_distances.insert(index.into(), index);
        index += 1;
    }

    // Initialize a variable to keep track of the current row
    let mut current_row: usize = 0;
    // Break the loop when current row equals the length of the second array
    while current_row != arr2_len {
        let second_array_element = arr2.at(current_row).unwrap();
        let mut previous_substitution_cost = prev_distances.get(0);
        prev_distances.insert(0, current_row + 1);

        // Initialize a variable to keep track of the current column
        let mut current_column: usize = 0;
        // Break the loop when current column equals the length of the first array
        while current_column != arr1_len {
            let first_array_element = arr1.at(current_column).unwrap();
            let deletion_cost = prev_distances.get(current_column.into()) + 1;
            let insertion_cost = prev_distances.get((current_column + 1).into()) + 1;
            let substitution_cost = if first_array_element == second_array_element {
                previous_substitution_cost
            } else {
                previous_substitution_cost + 1
            };

            previous_substitution_cost = prev_distances.get((current_column + 1).into());
            let min_cost = if insertion_cost < deletion_cost {
                insertion_cost
            } else if substitution_cost < deletion_cost {
                substitution_cost
            } else {
                deletion_cost
            };
            prev_distances.insert((current_column + 1).into(), min_cost);

            current_column += 1
        }

        current_row += 1;
    }

    // Return the Levenshtein distance
    prev_distances.get(arr1_len.into())
}
