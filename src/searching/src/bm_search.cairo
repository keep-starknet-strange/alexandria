// The Boyer-Moore string search algorithm
use dict::Felt252DictTrait;

// Find `pattern` in `text` and return the index of every match.
/// * `text` - The text to search in.
/// * `pattern` - The pattern to search for.
/// # Returns
/// * `Array<usize>` - The index of every match.
fn bm_search(text: @ByteArray, pattern: @ByteArray) -> Array<usize> {
    let mut positions: Array<usize> = array![];
    let n = text.len();
    let m = pattern.len();
    if n == 0 || m == 0 || m > n {
        return positions;
    }

    let mut collection = felt252_dict_new::<usize>();
    let mut collect_id = 0;
    loop {
        if collect_id == m {
            break;
        }
        let c = pattern.at(collect_id).unwrap();
        collection
            .insert(
                c.into(), collect_id + 1
            ); // avoid 0 since felt252_dict init every entry to 0 by default
        collect_id += 1;
    };

    let mut shift: usize = 0;
    loop {
        if shift > n - m {
            break;
        }

        let mut j = m;
        loop {
            if j == 0 || @pattern.at(j - 1).unwrap() != @text.at(shift + j - 1).unwrap() {
                break;
            }
            j -= 1;
        };
        if j == 0 {
            positions.append(shift);
            let add_to_shift = {
                if shift + m < n {
                    let c = text.at(shift + m).unwrap();
                    let index = collection.get(c.into());
                    if index == 0 {
                        m + 1
                    } else {
                        m - index + 1
                    }
                } else {
                    1
                }
            };
            shift += add_to_shift;
        } else {
            let c = text.at(shift + j - 1).unwrap();
            let index = collection.get(c.into());
            if j <= (index + 1) {
                shift += 1;
            } else {
                shift += j - index;
            }
        }
    };

    positions
}
