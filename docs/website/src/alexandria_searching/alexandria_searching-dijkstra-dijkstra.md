# dijkstra

Implements Dijkstra's shortest path algorithm to find shortest distances from a source node to all other nodes in a weighted graph with non-negative edge weights.

Time complexity: O((V + E) log V) where V is vertices and E is edges Space complexity: O(V) for distance tracking and priority queue

## Arguments

- `self` - The graph containing nodes and adjacency information
- `source` - The starting node to calculate shortest paths from

## Returns

- `Felt252Dict<u128>` - Dictionary mapping node IDs to their shortest distances from source

## Algorithm Overview

1. Initialize all distances to infinity except source (distance 0)
2. Use priority queue to always process the closest unvisited node
3. For each node, update distances to its neighbors if a shorter path is found
4. Mark nodes as visited to avoid reprocessing
5. Continue until all reachable nodes are processed

Fully qualified path: `alexandria_searching::dijkstra::dijkstra`

```rust
pub fn dijkstra(ref self: Graph<Nullable<Span<Node>>>, source: u32) -> Felt252Dict<u128>
```
