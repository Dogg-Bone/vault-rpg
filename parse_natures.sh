#!/bin/bash
OUTPUT_DIR="Rules/Vagabonds/Natures"
mkdir -p "$OUTPUT_DIR"
for file in "Rules/PDF Archive/Markdown Versions"/*/*.md; do
    grep -A 10 -i "Nature choose one" "$file" | grep "^- " | grep ":" | while read -r line; do
        nature_name=$(echo "$line" | cut -d: -f1 | sed 's/^- //')
        description=$(echo "$line" | cut -d: -f2- | sed 's/^ //')
        echo "$description" > "$OUTPUT_DIR/$nature_name.md"
    done
done
