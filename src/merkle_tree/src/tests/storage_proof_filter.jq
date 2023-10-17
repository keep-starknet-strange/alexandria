def node:
    if has("binary")
    then
        "TrieNode::Binary(
            BinaryNode {
                left: \(.binary.left),
                right: \(.binary.right),
            }
        )"
    else
        "TrieNode::Edge(
            EdgeNode {
                path: \(.edge.path.value),
                length: \(.edge.path.len),
                child: \(.edge.child),
            }
        )"
    end
;

def proof:
    "array![\n\(.|map(node) | join(",\n"))\n]"
;

.result|"ContractStateProof {
    class_commitment: \(.class_commitment),
    contract_proof: \(.contract_proof | proof),
    contract_data: \(.contract_data|"ContractData {
        class_hash: \(.class_hash),
        nonce: \(.nonce),
        contract_state_hash_version: 0,
        storage_proof: \(.storage_proofs | .[0] | proof),
    }")
}"