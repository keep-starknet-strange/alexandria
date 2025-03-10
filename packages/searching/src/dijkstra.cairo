use core::nullable::{FromNullableResult, match_nullable};
//! Dijkstra algorithm using priority queue

#[derive(Copy, Drop)]
pub struct Node {
    source: u32,
    dest: u32,
    weight: u128,
}

#[generate_trait]
pub impl NodeGetters of NodeGettersTrait {
    fn weight(self: @Node) -> @u128 {
        self.weight
    }

    fn dest(self: @Node) -> @u32 {
        self.dest
    }

    fn source(self: @Node) -> @u32 {
        self.source
    }
}

/// Graph representation.
pub struct Graph<T> {
    pub(crate) nodes: Array<Node>,
    adj_nodes: Felt252Dict<T>,
}

/// Graph trait.
pub trait GraphTrait {
    /// Create a new graph instance.
    fn new() -> Graph<Nullable<Span<Node>>>;
    /// add an edge to graph
    fn add_edge(ref self: Graph<Nullable<Span<Node>>>, source: u32, dest: u32, weight: u128);
    /// return shortest path from s
    fn shortest_path(ref self: Graph<Nullable<Span<Node>>>, source: u32) -> Felt252Dict<u128>;
    /// return shortest path from s
    fn adj_nodes(ref self: Graph<Nullable<Span<Node>>>, source: felt252) -> Nullable<Span<Node>>;
}

impl DestructGraph<T, +Drop<T>, +Felt252DictValue<T>> of Destruct<Graph<T>> {
    fn destruct(self: Graph<T>) nopanic {
        self.adj_nodes.squash();
    }
}

impl GraphImpl of GraphTrait {
    fn new() -> Graph<Nullable<Span<Node>>> {
        Graph { nodes: array![], adj_nodes: Default::default() }
    }

    fn add_edge(ref self: Graph<Nullable<Span<Node>>>, source: u32, dest: u32, weight: u128) {
        let adj_nodes = self.adj_nodes.get(source.into());
        let mut nodes: Array<Node> = array![];
        let mut is_null = false;
        let node = Node { source, dest, weight };
        let mut span = match match_nullable(adj_nodes) {
            FromNullableResult::Null => {
                is_null = true;
                nodes.append(node);
                nodes.span()
            },
            FromNullableResult::NotNull(adj_nodes) => { adj_nodes.unbox() },
        };

        // iterate over existing array to add new node
        if !is_null {
            for current_value in span {
                nodes.append(*current_value);
            }
            nodes.append(node);
        }
        // add node
        self.nodes.append(node);
        // add adj node
        self.adj_nodes.insert(source.into(), NullableTrait::new(nodes.span()));
    }

    fn shortest_path(ref self: Graph<Nullable<Span<Node>>>, source: u32) -> Felt252Dict<u128> {
        dijkstra(ref self, source)
    }


    fn adj_nodes(ref self: Graph<Nullable<Span<Node>>>, source: felt252) -> Nullable<Span<Node>> {
        self.adj_nodes.get(source)
    }
}

pub fn dijkstra(ref self: Graph<Nullable<Span<Node>>>, source: u32) -> Felt252Dict<u128> {
    let mut priority_queue = array![];
    let mut visited_node = array![];
    let mut dist: Felt252Dict<u128> = Default::default();
    let node_size = self.nodes.len();
    let nodes = self.nodes.span();
    // add first node to pripority queue
    let initial_node = Node { source, dest: 0, weight: 0 };
    priority_queue.append(initial_node);

    // init dist with infinite value
    let mut index = 0;
    while index != node_size {
        let current_node = *nodes.at(index);
        dist.insert(current_node.dest.into(), 255_u128);
        index += 1;
    }

    // distance from itself is 0
    dist.insert(source.into(), 0);

    let mut visited = 0;
    let mut no_more_adj_node = false;
    // iterate while all node aren't visited
    while visited != node_size {
        let mut edge_distance: u128 = 0;
        let mut new_distance: u128 = 0;
        let adj_nodes = self.adj_nodes.get(visited.into());

        // retrieve adj node
        let mut adj_nodes_list = match match_nullable(adj_nodes) {
            FromNullableResult::Null => {
                no_more_adj_node = true;
                priority_queue.span()
            },
            FromNullableResult::NotNull(adj_nodes) => { adj_nodes.unbox() },
        };

        if !no_more_adj_node {
            let current_node: Node = priority_queue.pop_front().unwrap();
            visited += 1;
            let mut index = 0;

            let adj_nodes_list_len = adj_nodes_list.len();
            while index != adj_nodes_list_len {
                let adj_node: Node = *adj_nodes_list.get(index).unwrap().unbox();

                if !is_node_visited(ref visited_node, adj_node.dest) {
                    edge_distance = adj_node.weight.into();
                    new_distance = dist.get(adj_node.source.into()) + edge_distance;

                    // lower distance calculated
                    if new_distance < dist.get(adj_node.dest.into()) {
                        dist.insert(adj_node.dest.into(), new_distance);
                    }

                    let weight = dist.get(adj_node.dest.into());
                    // add node to priority_queue
                    priority_queue.append(Node { source, dest: adj_node.dest, weight });
                }
                index += 1;
            }

            visited_node.append(current_node.source);
        } else {
            no_more_adj_node = false;
            visited += 1;
        };
    }
    dist
}

/// Check if a node has already been visited
fn is_node_visited(ref nodes: Array<u32>, current_node: u32) -> bool {
    let mut index = 0;
    let n = nodes.span();

    loop {
        if index == n.len() {
            break false;
        }

        let source: u32 = *n.at(index);
        if source == current_node {
            break true;
        }
        index += 1;
    }
}
