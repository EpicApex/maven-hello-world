#!/bin/bash

# Directory to search in
directory="/Users/omrifreidenberg/Projects/Devops-applications/Refael/maven-hello-world"

# Prefix to look for
prefix="myapp"

# Use find to locate files with the specified prefix
found_file="$(find "$directory" -type f -name "${prefix}*")"

# Check if a file was found
if [ -n "$found_file" ]; then
    # Use basename to extract the file name
    filename="$(basename "$found_file")"
    echo "$filename"
    echo "Building docker image with $filename"
    tag=$(echo $filename | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
    echo $tag
    docker build -t $tag .
else
    echo "File with prefix '$prefix' not found."
fi