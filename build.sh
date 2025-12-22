#!/usr/bin/env bash
# Build README.md from section files

# Fail-fast execution: exit on errors (-e) or unset variables (-u), use pipeline failures (-o pipefail)
set -euo pipefail

# Clear temp file
TEMP_FILE="README.md.tmp"
> "$TEMP_FILE"

# List section files in order
SECTION_FILES=(
    "00-header.md"
    "01-introduction.md"
    "02-principles.md"
    "03-use-cases.md"
    "04-implementation.md"
    "05-pitfalls.md"
    "06-anti-patterns.md"
    "07-tools.md"
    "08-glossary.md"
    "09-footer.md"
)

# Concatenate all section files
for section in "${SECTION_FILES[@]}"; do
    file="sections/$section"
    if [[ ! -f "$file" ]]; then
        echo "Error: Missing section file: $file"
        exit 1
    fi

    # Add section content
    cat "$file" >> "$TEMP_FILE"

    # Add blank line separator
    echo "" >> "$TEMP_FILE"
done

# Move to final location
OUTPUT_FILE="README.md"
mv "$TEMP_FILE" "$OUTPUT_FILE"

# Report results
echo "✓ Built $OUTPUT_FILE from ${#SECTION_FILES[@]} sections"