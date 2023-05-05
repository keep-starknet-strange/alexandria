trait Construct<T> {
    fn new() -> T;
}

fn new<T, impl TConstruct: Construct<T>>() -> T {
    Construct::new()
}
