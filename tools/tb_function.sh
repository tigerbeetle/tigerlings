#!/bin/bash

source ./tools/terminal_format.sh

# This is a helper function that simplifies sending individual requests
# to TigerBeetle using the REPL command in non-interactive mode.
function tb() {
    # You can start the REPL by leaving off the --command argument
    # but we want to run specific requests in these exercises, so we'll
    # pass the request as an argument to this function.
    local output=$(./tigerbeetle repl --cluster=0 --addresses=3000 --command="$1" 2>&1)

    local prefixed_output=$(echo "$output" | sed "s/^/${bold}[Client]${normal} /")
    echo "$prefixed_output"

    # TigerBeetle returns a status for each event in the batch.
    # For the purposes of these exercises, we want to treat any error status as script failure.
    # The exceptions are:
    #   - "exists" (idempotent re-creation)
    #   - "linked_event_failed" (expected in linked event exercises)
    #   - "created" (success)
    while IFS= read -r line; do
        if [[ $line == *"Status."* && $line != *"Status.created"* && $line != *"Status.exists"* && $line != *"Status.linked_event_failed"* ]]; then
            exit 1
        fi
        if [[ $line =~ Cannot|panic ]]; then
            exit 1
        fi
    done <<< "$output"
}