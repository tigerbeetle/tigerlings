#!/bin/bash

source ./tools/processes_descendents_kill.sh
source ./tools/terminal_format.sh

# Trap the script exit signal and send SIGINT to the server process
trap 'processes_descendents_kill $$' EXIT SIGHUP SIGINT SIGQUIT SIGTERM SIGKILL

echo "${bold}Welcome to the Tigerlings exercises!${normal}"
echo ""
echo "This script will run each exercise and stop when it gets to a broken one."
echo "Once you've fixed that exercise, run this script again to continue."
echo ""

# Run each exercise
for file in $(ls exercises/[0-9][0-9][0-9]*.sh | sort -n); do
    echo "${bold}Running exercise: ./$file${normal}"

    if [ "$file" = "exercises/000_download.sh" ]; then
        # Only download/build TigerBeetle if it's not already available
        if  ./tigerbeetle version >/dev/null 2>&1; then
            echo "TigerBeetle is already available. Skipping exercise."
        else
            "$file"
        fi
    elif [ "$file" = "exercises/002_server.sh" ]; then
        # Execute the file in the background and store its process ID
        "$file" 2>&1 | sed "s/^/${bold}[Server]${normal} /" &
        server_pid=$!
        sleep 1
        if ! kill -0 $server_pid 2>/dev/null; then
            exit 1
        fi
    else
        # Execute the file normally
        "$file"
    fi

    # Check the exit status
    if [ $? -ne 0 ]; then
        echo ""
        echo "Uh oh, there is a problem in ./$file!"
        exit 1
    fi

    echo ""
done

processes_descendents_kill $$
