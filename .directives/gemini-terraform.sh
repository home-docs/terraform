#!/bin/bash
# Gemini CLI helper script to load terraform directives and pass user prompt

MASTER_FILE=".directives/system-terraform.md"

if [[ ! -f "$MASTER_FILE" ]]; then
  echo "Error: $MASTER_FILE not found!"
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 \"Your terraform prompt here\""
  exit 1
fi

SYSTEM_PROMPT=$(cat "$MASTER_FILE")
USER_PROMPT="$*"

# Run gemini CLI chat with system and user prompts
gemini chat --system "$SYSTEM_PROMPT" "$USER_PROMPT"
