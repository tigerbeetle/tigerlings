#!/bin/bash

source ./tools/processes_descendents_kill.sh
source ./tools/terminal_format.sh

# Trap the script exit signal and send SIGINT to the server process
trap 'processes_descendents_kill $$' EXIT SIGHUP SIGINT SIGQUIT SIGTERM SIGKILL

# Optional: skip ahead to a specific exercise number (e.g., ./run.sh 15)
# Setup exercises (000-002) always run regardless.
start_from=$((10#${1:-0}))

# Remove old data file to ensure a fresh start
rm -f 0_0.tigerbeetle

echo "${bold}Welcome to the Tigerlings exercises!${normal}"
echo ""
echo "This script will run each exercise and stop when it gets to a broken one."
echo "Once you've fixed that exercise, run this script again to continue."
if [ "$start_from" -gt 0 ]; then
    echo "Skipping ahead to exercise $start_from."
fi
echo ""

# Run each exercise
for file in $(ls exercises/[0-9][0-9][0-9]*.sh | sort -n); do
    # Extract the exercise number from the filename
    exercise_num=$((10#$(echo "$file" | grep -o '[0-9]\{3\}' | head -1)))

    # Always run setup exercises (000-002), skip others before start_from
    if [ "$exercise_num" -gt 2 ] && [ "$exercise_num" -lt "$start_from" ]; then
        continue
    fi

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
