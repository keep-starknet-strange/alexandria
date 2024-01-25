# Searching

## [Boyer-Moore algorithm](./src/bm_search.cairo)

The Boyer-Moore algorithm is a string-searching algorithm that finds the position of a pattern in a string. It preprocesses the pattern to create two lookup tables: one for the bad character rule and one for the good suffix rule. The bad character rule shifts the pattern to align with the last occurrence of the mismatched character in the pattern. The good suffix rule shifts the pattern to align with the last occurrence of the suffix of the pattern that matches the suffix of the text.

The Boyer-Moore algorithm has a best-case time complexity of O(n/m) and a worst-case time complexity of O(nm), where n is the length of the text and m is the length of the pattern. It is the most efficient string-searching algorithm in practice.

## [Binary search](./src/binary_search.cairo)

The binary search algorithm is a simple search in an ordered array-like compound. It starts by comparing the value we are looking for to the middle of the array. If it's not a match, the function calls itself recursively on the right or left half of the array until it does(n't) find the value in the array.

## [Dijkstra](./src/dijkstra.cairo)

Dijkstra's algorithm is a graph search algorithm that finds the shortest path from a source node to all other nodes in a weighted graph, ensuring the shortest distances are progressively updated as it explores nodes. It maintains a priority queue of nodes based on their tentative distances from the source and greedily selects the node with the smallest distance at each step.

## [Levenshtein distance](./src/levenshtein_distance.cairo)

The Levenshtein distance is a string metric for measuring the difference between two sequences. It is the minimum number of single-character edits (insertions, deletions, or substitutions) required to change one string into the other. This version of the algorithm optmizes the space complexity. Time complexity: O(nm). Space complexity: O(n),
