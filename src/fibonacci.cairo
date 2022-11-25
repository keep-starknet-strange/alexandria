// Calculate fibonnaci 
func fibonacci(a: felt, b: felt, n: felt) -> felt {
    match n {
        0 => a,
        _ => fibonacci(b, a + b, n - 1),
    }
}

// Tests
// TODO: replace with proper tests

func main() -> felt{
    fibonacci(1, 2, 4)
}