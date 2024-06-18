#!/bin/bash

source ./tools/processes_descendents_kill.sh

bold=$(tput bold)
normal=$(tput sgr0)

# Trap the script exit signal and send SIGINT to the server process
trap 'processes_descendents_kill $$' EXIT SIGHUP SIGINT SIGQUIT SIGTERM SIGKILL

# Run each exercise
for file in $(ls exercises/[0-9][0-9][0-9]*.sh | sort -n); do
    echo "${bold}Running exercise: ./$file${normal}"

    if [ "$file" = "exercises/000_download.sh" ]; then
        # Only download/build TigerBeetle if it's not already available
        if  ./tigerbeetle version >/dev/null 2>&1; then
            echo "TigerBeetle is already available. Skipping exercise."
        else
            bash "$file"
        fi
    elif [ "$file" = "exercises/002_server.sh" ]; then
        # Execute the file in the background and store its process ID
        bash "$file" 2>&1 | sed "s/^/${bold}[Server]${normal} /" &
        server_pid=$!
        sleep 1
        if ! kill -0 $server_pid 2>/dev/null; then
            wait $server_pid
            if [ $? -ne 0 ]; then
            exit 1
            fi
        fi
    else
        # Execute the file normally
        bash "$file"
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
