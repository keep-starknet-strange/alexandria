// The Boyer-Moore string search algorithm
use dict::Felt252DictTrait;

/// Find `pattern` in `text` and return the index of every match.
/// * `text` - The text to search in.
/// * `pattern` - The pattern to search for.
/// # Returns
/// * `Array<usize>` - The index of every match.
fn bm_search(text: @ByteArray, pattern: @ByteArray) -> Array<usize> {
    let mut positions: Array<usize> = array![]; // Array to store the indices of every match
    let text_len = text.len(); // Length of the text
    let pattern_len = pattern.len(); // Length of the pattern

    // Check for invalid inputs or if the pattern is longer than the text
    if text_len == 0 || pattern_len == 0 || pattern_len > text_len {
        return positions;
    }

    let mut char_dict = felt252_dict_new::<
        usize
    >(); // Dictionary to store the last occurrence of each character in the pattern
    let mut pattern_index = 0; // Index of the current character in the pattern

    // Build the character dictionary
    loop {
        if pattern_index == pattern_len {
            break;
        }
        let current_char = pattern.at(pattern_index).unwrap();
        char_dict
            .insert(
                current_char.into(), pattern_index + 1
            ); // Avoid 0 since felt252_dict initializes every entry to 0 by default
        pattern_index += 1;
    };

    let mut shift: usize = 0; // Shift value for pattern matching

    // Perform pattern matching
    loop {
        if shift > text_len - pattern_len {
            break;
        }

        let mut pattern_index = pattern_len;

        // Compare characters from right to left
        loop {
            if pattern_index == 0
                || @pattern
                    .at(pattern_index - 1)
                    .unwrap() != @text
                    .at(shift + pattern_index - 1)
                    .unwrap() {
                break;
            }
            pattern_index -= 1;
        };

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

            // Calculate the next shift value based on the last occurrence of the current character in the pattern
            if pattern_index <= (index + 1) {
                shift += 1;
            } else {
                shift += pattern_index - index;
            }
        }
    };

    positions // Return the array of positions
}
