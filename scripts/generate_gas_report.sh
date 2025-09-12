#!/bin/bash

run_tests_and_collect_gas() {
    snforge test | grep -E '\[PASS\] .* \(l1_gas: ~[0-9]+, l1_data_gas: ~[0-9]+, l2_gas: ~[0-9]+\)' | sed -E 's/\[PASS\] ([^(]*) \(l1_gas: ~[0-9]+, l1_data_gas: ~[0-9]+, l2_gas: ~([0-9]+)\)/\1 \2/' | sort -k2 -nr
}

generate_gas_report() {
    echo "Running tests and collecting gas data..."
    local gas_data=$(run_tests_and_collect_gas)

    if [ -z "$gas_data" ]; then
        echo "Error: No gas data found. Make sure 'snforge test' is running correctly."
        exit 1
    fi

    echo "Found $(echo "$gas_data" | wc -l) tests with gas usage data"

    # Create a temporary file to store previous gas values
    local prev_gas_file=$(mktemp)
    local root_gas_report="gas_report.json"
    if [ -f "$root_gas_report" ]; then
        echo "Loading previous gas report from $root_gas_report..."
        # Parse JSON entries and store in temporary file
        while IFS= read -r line; do
            # Skip lines that don't match JSON entry format
            if [[ $line == *\"*\":*[0-9]* ]]; then
                # Extract test name (between first " and last ":)
                test_name="${line#*\"}"
                test_name="${test_name%\":*}"

                # Extract gas value (after ": " and before optional comma)
                gas_value="${line#*\": }"
                gas_value="${gas_value%,*}"

                if [ -n "$test_name" ] && [ -n "$gas_value" ] && [[ "$gas_value" =~ ^[0-9]+$ ]]; then
                    echo "$test_name|$gas_value" >> "$prev_gas_file"
                fi
            fi
        done < "$root_gas_report"
        echo "Loaded $(wc -l < "$prev_gas_file") previous test results"
    else
        echo "No previous gas_report.json found at $root_gas_report - this is a first run"
    fi

    echo "Comparing gas usage and generating reports..."
    echo "{" > new_gas_report.json
    local gas_diff_file=$(mktemp)
    local increased_gas=false
    local increased_tests_file=$(mktemp)
    local changes_count=0
    local increases_count=0

    while read -r test_name gas_used; do
        echo "  \"$test_name\": $gas_used," >> new_gas_report.json

        # Look up previous gas value from file instead of associative array
        old_gas=$(grep "^$test_name|" "$prev_gas_file" 2>/dev/null | cut -d'|' -f2)
        if [ -n "$old_gas" ]; then
            if [ "$gas_used" -ne "$old_gas" ]; then
                diff=$((gas_used - old_gas))
                changes_count=$((changes_count + 1))
                if [ "$diff" -gt 0 ]; then
                    echo "$test_name (Old: $old_gas, New: $gas_used)" >> "$increased_tests_file"
                    increased_gas=true
                    increases_count=$((increases_count + 1))
                    echo "INCREASE: $test_name: $old_gas → $gas_used (+$diff)"
                else
                    echo "DECREASE: $test_name: $old_gas → $gas_used ($diff)"
                fi
                if [ "$diff" -gt 0 ]; then
                    echo "$test_name|+$diff" >> "$gas_diff_file"
                else
                    echo "$test_name|$diff" >> "$gas_diff_file"
                fi
            fi
        fi
    done <<< "$gas_data"

    echo "Gas comparison complete: $changes_count changes found ($increases_count increases)"

    echo "}" >> new_gas_report.json
    echo "Updating gas_report.json with new values..."
    mv new_gas_report.json "$root_gas_report"

    echo "Generating gas_report_diff.json..."
    echo "{" > gas_report_diff.json

    # Generate gas diff JSON from file
    if [ -s "$gas_diff_file" ]; then
        while IFS='|' read -r test_name diff_value; do
            echo "  \"$test_name\": \"$diff_value\"," >> gas_report_diff.json
        done < "$gas_diff_file"
        # Remove trailing comma from last entry (macOS sed compatible)
        sed -i '' '$ s/,$//' gas_report_diff.json
        echo "Created diff report with $(wc -l < "$gas_diff_file") entries"
    else
        echo "No gas changes detected - empty diff report created"
    fi
    echo "}" >> gas_report_diff.json

    # Clean up temporary files
    rm -f "$prev_gas_file" "$gas_diff_file"

    if [ "$increased_gas" = true ]; then
        echo "Gas usage has increased in the following tests:"
        cat "$increased_tests_file"
        rm -f "$increased_tests_file"
        exit 0
    else
        rm -f "$increased_tests_file"
        echo "Gas usage has not increased."
        exit 0
    fi
}

generate_gas_report
