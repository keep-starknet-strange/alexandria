#!/bin/bash

run_tests_and_collect_gas() {
    scarb test | grep -E 'test .* \.\.\. ok \(gas usage est\.: [0-9]+\)' | sed -E 's/test (.*) \.\.\. ok \(gas usage est\.: ([0-9]+)\)/\1 \2/' | sort -k2 -nr
}

generate_gas_report() {
    local gas_data=$(run_tests_and_collect_gas)
    
    if [ -z "$gas_data" ]; then
        echo "Error: No gas data found. Make sure 'scarb test' is running correctly."
        exit 1
    fi

    local increased_gas=false
    local increased_tests=()

    while read -r test_name gas_used; do
        old_gas=$(grep "\"$test_name\":" gas_report.json 2>/dev/null | cut -d':' -f2 | tr -d ' ,}')
        if [ -n "$old_gas" ] && [ "$gas_used" -gt "$old_gas" ]; then
            increased_tests+=("$test_name (Old: $old_gas, New: $gas_used)")
            increased_gas=true
        fi
        echo "  \"$test_name\": $gas_used," >> new_gas_report.json
    done <<< "$gas_data"

    echo "{" > gas_report.json
    sed '$ s/,$//' new_gas_report.json >> gas_report.json
    echo "}" >> gas_report.json
    rm new_gas_report.json

    if [ "$increased_gas" = true ]; then
        echo "Gas usage has increased in the following tests:"
        printf '%s\n' "${increased_tests[@]}"
        echo "PR check failed."
        exit 1
    else
        echo "Gas usage has not increased. PR check passed."
        exit 0
    fi
}

generate_gas_report