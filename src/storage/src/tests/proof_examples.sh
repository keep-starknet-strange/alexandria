#! /usr/bin/env bash
set -e;
set -o pipefail;

        #   https://starknet-mainnet.infura.io/v3/56387818e18e404a9a6d2391af0e9085

function rpc_call() {
     printf "Request:\n${1}\nReply:\n"
     curl -s -X POST \
          -H 'Content-Type: application/json' \
          -d "${1}" \
          https://starknet-mainnet.g.alchemy.com/v2/-PEdaMXc6znJmRDiadouarlPjdT6f10Z
     printf "\n\n"
}

rpc_call '{
    "jsonrpc": "2.0",
    "method": "pathfinder_getProof",
    "params": {
        "block_id": "latest",
        "contract_address": "0x00da114221cb83fa859dbdb4c44beeaa0bb37c7537ad5ae66fe5e0efd20e6eb3",
        "keys": [
            "0x4ae51d08cd202d1472587dfe63dbf2d5ec767cbf4218b59b7ab71956780c6ee"
        ]
    },
    "id": 0
}'