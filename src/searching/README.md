# Searching

## [Binary search](./src/binary_search.cairo)

The binary search algorithm is a simple search in an ordered array-like compound. It starts by comparing the value we are looking for to the middle of the array. If it's not a match, the function calls itself recursively on the right or left half of the array until it does(n't) find the value in the array.

## [Dijkstra](./src/dijkstra.cairo)

Dijkstra's algorithm is a graph search algorithm that finds the shortest path from a source node to all other nodes in a weighted graph, ensuring the shortest distances are progressively updated as it explores nodes. It maintains a priority queue of nodes based on their tentative distances from the source and greedily selects the node with the smallest distance at each step.
