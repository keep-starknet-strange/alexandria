// The Levenshtein Distance
use dict::Felt252DictTrait;


// Compute the edit distance between two byte arrays
/// * `arr1` - The first byte array.
/// * `arr2` - The second byte array.
/// # Returns
/// * `usize` - The edit distance between the two byte arrays.
fn levenshtein_distance(arr1: @ByteArray, arr2: @ByteArray) -> usize {
    let m = arr1.len();
    let n = arr2.len();

    if m == 0 {
        return n;
    }

    let mut prev_dist = felt252_dict_new::<usize>();
    let mut init_index: usize = 0;
    loop {
        if init_index == m + 1 {
            break;
        }
        prev_dist.insert(init_index.into(), init_index);
        init_index += 1;
    };

    let mut row: usize = 0;
    loop {
        if row == n {
            break;
        }
        let c2 = arr2.at(row).unwrap();
        let mut prev_substitution_cost = prev_dist.get(0);
        prev_dist.insert(0, row + 1);

        let mut col: usize = 0;
        loop {
            if col == m {
                break;
            }
            let c1 = arr1.at(col).unwrap();
            let deletion_cost = prev_dist.get(col.into()) + 1;
            let insertion_cost = prev_dist.get((col + 1).into()) + 1;
            let substitution_cost = if c1 == c2 {
                prev_substitution_cost
            } else {
                prev_substitution_cost + 1
            };

            prev_substitution_cost = prev_dist.get((col + 1).into());
            let mut min_cost = deletion_cost;
            if insertion_cost < min_cost {
                min_cost = insertion_cost;
            }
            if substitution_cost < min_cost {
                min_cost = substitution_cost;
            }
            prev_dist.insert((col + 1).into(), min_cost);

            col += 1
        };

        row += 1;
    };

    prev_dist.get(m.into())
}
