#!/bin/bash

function remove_data_file() {
    if [ -f "0_0.tigerbeetle" ]; then
        rm "0_0.tigerbeetle"
    fi
}

remove_data_file

./tools/patches_apply.sh

trap './tools/patches_revert.sh; remove_data_file' EXIT SIGHUP SIGINT SIGQUIT SIGTERM SIGKILL

./run.sh

# Check the exit status
if [ $? -ne 0 ]; then
    exit 1
fi
