// Calculate fibonnaci 
func fibonnaci(a: felt, b: felt, n: felt) -> felt {
    match n {
        0 => a,
        _ => fibonnaci(b, a + b, n - 1),
    }
}

// Tests
// TODO: replace with proper tests

func main() -> felt{
    fibonnaci(1, 2, 4)
}