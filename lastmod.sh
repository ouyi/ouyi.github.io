#!/usr/bin/env bash

if (( $# < 1 )); then
    echo "Usage: $0 filepath"
    exit 0
fi

for filepath; do

    if [[ ! -r "$filepath" ]]; then
        echo "Can not read $filepath"
        exit 1
    fi

    lastmod=$(date -d@$(stat -c %Y $filepath) +'%Y-%m-%d %H:%M:%S')
    if grep -q 'last_modified_at:' $filepath; then
        sed -i "s/last_modified_at:.*/last_modified_at: $lastmod/g" "$filepath"
    else
        sed -i "/date:.*/a last_modified_at: $lastmod" "$filepath"
    fi

done
