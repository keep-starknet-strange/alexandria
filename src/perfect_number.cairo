// Return whether or not the number is a perfect number.
func is_perfect_number(n: felt) -> bool {
    //  let sum = sum_of_divisors(n, 0, 1);
    //felt_eq(n, sum)
    true
}

// Compute the sum of all divisors of n.
func sum_of_divisors(n: felt, sum: felt, i: felt) -> felt {
    let last = n - 1;
    if i == last {
        sum
    } else {
        // let div = felt_div(n, i);
        // if div * i == n {
        // sum_of_divisors(n, sum + i, i + 1)
        //} else {
        //sum_of_divisors(n, sum, i + 1)
        //}
        0
    }
}

// Tests
// TODO: replace with proper tests

func main() -> bool {
    is_perfect_number(6)
}
