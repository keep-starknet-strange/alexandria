// The Boyer-Moore string search algorithm
use core::dict::Felt252DictTrait;

/// Find `pattern` in `text` and return the index of every match.
/// * `text` - The text to search in.
/// * `pattern` - The pattern to search for.
/// # Returns
/// * `Array<usize>` - The index of every match.
pub fn bm_search(text: @ByteArray, pattern: @ByteArray) -> Array<usize> {
    let mut positions: Array<usize> = array![]; // Array to store the indices of every match
    let text_len = text.len(); // Length of the text
    let pattern_len = pattern.len(); // Length of the pattern

    // Check for invalid inputs or if the pattern is longer than the text
    if text_len == 0 || pattern_len == 0 || pattern_len > text_len {
        return positions;
    }

    // Dictionary to store the last occurrence of each character in the pattern
    let mut char_dict = Default::default();
    let mut pattern_index = 0; // Index of the current character in the pattern

    // Build the character dictionary
    while pattern_index != pattern_len {
        let current_char = pattern.at(pattern_index).unwrap();
        // Avoid 0 since felt252_dict initializes every entry to 0 by default
        char_dict.insert(current_char.into(), pattern_index + 1);
        pattern_index += 1;
    }

    let mut shift: usize = 0; // Shift value for pattern matching

    // Perform pattern matching
    while (shift <= text_len - pattern_len) {
        let mut pattern_index = pattern_len;

        // Compare characters from right to left
        while pattern_index != 0 {
            let pattern_value = pattern.at(pattern_index - 1).unwrap();
            let text_value = text.at(shift + pattern_index - 1).unwrap();
            if pattern_value != text_value {
                break;
            }
            pattern_index -= 1;
        }

        // If the pattern is found at the current shift position
        if pattern_index == 0 {
            positions.append(shift); // Add the current shift position to the positions array

            // Calculate the next shift value
            let add_to_shift = {
                if shift + pattern_len < text_len {
                    let next_char = text.at(shift + pattern_len).unwrap();
                    let index = char_dict.get(next_char.into());
                    if index == 0 {
                        pattern_len + 1
                    } else {
                        pattern_len - index + 1
                    }
                } else {
                    1
                }
            };
            shift += add_to_shift;
        } else {
            let current_char = text.at(shift + pattern_index - 1).unwrap();
            let index = char_dict.get(current_char.into());

            // Calculate the next shift value based on the last occurrence of the current character
            // in the pattern
            if pattern_index <= (index + 1) {
                shift += 1;
            } else {
                shift += pattern_index - index;
            }
        }
    }

    positions // Return the array of positions
}
