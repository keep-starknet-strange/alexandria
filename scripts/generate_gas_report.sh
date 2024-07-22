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

    echo "{" > new_gas_report.json
    echo "$gas_data" | while read -r test_name gas_used; do
        echo "  \"$test_name\": $gas_used," >> new_gas_report.json
    done
    sed -i '' -e '$ s/,$//' new_gas_report.json 2>/dev/null || sed -i '$ s/,$//' new_gas_report.json
    echo "}" >> new_gas_report.json

        if [ -f "gas_report.json" ]; then
        local increased_gas=false
        sed '1d;$d' new_gas_report.json > temp_report.txt
        while read -r line; do
            test_name=$(echo "$line" | cut -d':' -f1 | tr -d ' "')
            gas_used=$(echo "$line" | cut -d':' -f2 | tr -d ' ,')
            old_gas=$(grep "\"$test_name\":" gas_report.json | cut -d':' -f2 | tr -d ' ,')
            if [ -n "$old_gas" ] && [ "$gas_used" -gt "$old_gas" ]; then
                echo "Gas usage increased for test: $test_name"
                echo "Old: $old_gas, New: $gas_used"
                increased_gas=true
            fi
            done < temp_report.txt
            rm temp_report.txt

            if [ "$increased_gas" = true ]; then
            echo "Gas usage has increased. Please review the changes."
            echo "Updating gas report with new values."
            mv new_gas_report.json gas_report.json
            exit 1
        else
            echo "Gas usage has not increased. Updating gas report."
            mv new_gas_report.json gas_report.json
            exit 0
        fi
    else
        echo "No existing gas report found. Creating a new one."
        mv new_gas_report.json gas_report.json
        exit 0
    fi
}

generate_gas_report