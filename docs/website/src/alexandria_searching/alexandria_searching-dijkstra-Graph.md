# Graph

Graph representation.

Fully qualified path: `alexandria_searching::dijkstra::Graph`

```rust
pub struct Graph<T> {
    pub(crate) nodes: Array<Node>,
    adj_nodes: Felt252Dict<T>,
}
```

