#! /usr/bin/env bash
set -e;
set -o pipefail;

curl -s -X POST \
    -H 'Content-Type: application/json' \
    -d '{
        "jsonrpc": "2.0",
        "method": "pathfinder_getProof",
        "params": {
            "block_id": { "block_hash": "'${1}'"},
            "contract_address": "'${2}'",
            "keys": ["'${3}'"]
        },
        "id": 0
    }' \
    https://starknet-mainnet.g.alchemy.com/v2/-PEdaMXc6znJmRDiadouarlPjdT6f10Z \
    | jq -r -f proof_filter.jq