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

    declare -A prev_gas
    if [ -f gas_report.json ]; then
        while read -r line; do
            if [[ $line =~ \"(.*)\":[[:space:]]*([0-9]+) ]]; then
                prev_gas["${BASH_REMATCH[1]}"]=${BASH_REMATCH[2]}
            fi
        done < gas_report.json
    fi

    echo "{" > new_gas_report.json
    declare -A gas_diff
    local increased_gas=false
    local increased_tests=()

    while read -r test_name gas_used; do
        echo "  \"$test_name\": $gas_used," >> new_gas_report.json

        if [ -n "${prev_gas[$test_name]}" ]; then
            old_gas=${prev_gas[$test_name]}
            if [ "$gas_used" -ne "$old_gas" ]; then
                diff=$((gas_used - old_gas))
                if [ "$diff" -gt 0 ]; then
                    increased_tests+=("$test_name (Old: $old_gas, New: $gas_used)")
                    increased_gas=true
                fi
                if [ "$diff" -gt 0 ]; then
                    gas_diff["$test_name"]="+$diff"
                else
                    gas_diff["$test_name"]="$diff"
                fi
            fi
        fi
    done <<< "$gas_data"

    echo "}" >> new_gas_report.json
    mv new_gas_report.json gas_report.json
    echo "{" > gas_report_diff.json

    for test in "${!gas_diff[@]}"; do
        echo "  \"$test\": \"${gas_diff[$test]}\"," >> gas_report_diff.json
    done

    sed -i '$ s/,$//' gas_report_diff.json
    echo "}" >> gas_report_diff.json

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
