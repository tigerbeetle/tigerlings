#!/bin/bash

# Define the directory paths
exercises_dir="./exercises"
patches_dir="./patches"

# Loop through each script in the exercises directory
for script in "$exercises_dir"/*.sh; do
    # Get the script file name without the directory path
    script_name=$(basename "$script")
    
    # Generate the patch file name
    patch_name="${script_name%.*}.patch"
    
    # Generate the patch using git diff
    patch=$(git diff -p "$script")
    
    # Check if the patch is non-empty
    if [[ -n $patch ]]; then
        # Save the patch to the patches directory
        echo "$patch" > "$patches_dir/$patch_name"
    fi
done