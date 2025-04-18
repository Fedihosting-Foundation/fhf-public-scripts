#!/usr/bin/env bash

pictrs_base_url="http://127.0.0.1:7777"
pictrs_api_key=""

for url in "$@"
do
    echo "Attempting to purge $url"
    alias="$(rev <<< "$url" | cut -d/ -f1 | rev)"
    curl -s -H "x-api-token: $pictrs_api_key" -X POST "$pictrs_base_url/internal/purge?alias=$alias"
    # pictrs does not return a line break at the end of its output
    printf '\n' 
done
