# GraphTrait

Graph trait defining operations for working with weighted directed graphs.

Fully qualified path: `alexandria_searching::dijkstra::GraphTrait`

```rust
pub trait GraphTrait
```

## Trait functions

### new

Create a new empty graph instance.

## Returns

- `Graph<Nullable<Span<Node>>>` - A new empty graph

Fully qualified path: `alexandria_searching::dijkstra::GraphTrait::new`

```rust
fn new() -> Graph<Nullable<Span<Node>>>
```

### add_edge

Add a weighted directed edge to the graph.

## Arguments

- `self` - The graph instance to modify
- `source` - The source node ID
- `dest` - The destination node ID
- `weight` - The weight/cost of the edge

Fully qualified path: `alexandria_searching::dijkstra::GraphTrait::add_edge`

```rust
fn add_edge(ref self: Graph<Nullable<Span<Node>>>, source: u32, dest: u32, weight: u128)
```

### shortest_path

Calculate shortest paths from a source node to all other nodes using Dijkstra's algorithm.

## Arguments

- `self` - The graph instance \* `source` - The starting node ID to calculate paths from

## Returns

- `Felt252Dict<u128>` - Dictionary mapping node IDs to shortest distances

Fully qualified path: `alexandria_searching::dijkstra::GraphTrait::shortest_path`

```rust
fn shortest_path(ref self: Graph<Nullable<Span<Node>>>, source: u32) -> Felt252Dict<u128>
```

### adj_nodes

Get adjacent nodes for a given source node.

## Arguments

- `self` - The graph instance
- `source` - The node ID to get adjacencies for

## Returns

- `Nullable<Span<Node>>` - Span of adjacent nodes or null if none exist

Fully qualified path: `alexandria_searching::dijkstra::GraphTrait::adj_nodes`

```rust
fn adj_nodes(ref self: Graph<Nullable<Span<Node>>>, source: felt252) -> Nullable<Span<Node>>
```
