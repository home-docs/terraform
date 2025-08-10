#!/bin/bash
# Sync system-terraform.md directives into .copilot.json (condensed prompt)

MASTER_FILE=".directives/system-terraform.md"
OUTPUT_FILE=".copilot.json"

if [[ ! -f "$MASTER_FILE" ]]; then
  echo "Error: $MASTER_FILE not found!"
  exit 1
fi

# Extract bullet points (- ) and join into single line prompt
PROMPT=$(grep -E "^- " "$MASTER_FILE" | sed 's/^- //' | tr '\n' ' ')

# Write JSON prompt file
cat > "$OUTPUT_FILE" <<EOF
{
  "prompt": "$PROMPT"
}
EOF

echo ".copilot.json updated from $MASTER_FILE"
