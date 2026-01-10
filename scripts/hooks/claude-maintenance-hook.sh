#!/bin/bash
# Claude Code Maintenance Pre-Commit Hook
# Prompts user to update _meta.yaml files and/or _indices before commit
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Check for claude CLI
if ! command -v claude &> /dev/null; then
  echo "ERROR: 'claude' CLI not found. Install Claude Code first."
  echo "See: https://claude.ai/code"
  exit 1
fi

# Get staged files
cd "$PROJECT_ROOT"
staged_files=$(git diff --cached --name-only)
file_count=$(echo "$staged_files" | grep -c . || echo "0")

# Show summary
echo ""
echo "==========================================="
echo "  Files staged for commit: $file_count"
echo "-------------------------------------------"
if [ "$file_count" -gt 0 ]; then
  echo "$staged_files" | head -20
  if [ "$file_count" -gt 20 ]; then
    echo "  ... and $((file_count - 20)) more files"
  fi
else
  echo "  (no files staged)"
fi
echo "==========================================="

# Prompt user (with /dev/tty for interactive input)
echo ""
echo "Would you like to update project metadata?"
echo "  (m) Update _meta.yaml files"
echo "  (i) Update _indices/ folder"
echo "  (b) Both meta and indices"
echo "  (s) Skip - continue with commit"
echo ""
read -p "Choice [m/i/b/s]: " choice < /dev/tty

# Function to run meta update
run_meta_update() {
  echo ""
  echo ">>> Running meta file maintenance..."

  # Extract prompt from maintain-meta.md (skip YAML frontmatter)
  local cmd_file="$PROJECT_ROOT/.claude/commands/maintain-meta.md"
  if [ ! -f "$cmd_file" ]; then
    echo "ERROR: Command file not found: $cmd_file"
    exit 1
  fi

  # Extract content after the second ---
  local prompt
  prompt=$(sed '1,/^---$/d' "$cmd_file" | sed '1,/^---$/d')

  # Run Claude Code
  claude -p "$prompt" \
    --allowedTools "Read,Write,Edit,Glob,Bash(git add:*),Bash(ls:*)" \
    --max-turns 15

  # Stage any changes to _meta.yaml files
  git add "*/_meta.yaml" "_meta.yaml" 2>/dev/null || true

  echo ">>> Meta file maintenance complete."
}

# Function to run indices update
run_indices_update() {
  echo ""
  echo ">>> Running indices maintenance..."

  # Extract prompt from maintain-indices.md (skip YAML frontmatter)
  local cmd_file="$PROJECT_ROOT/.claude/commands/maintain-indices.md"
  if [ ! -f "$cmd_file" ]; then
    echo "ERROR: Command file not found: $cmd_file"
    exit 1
  fi

  # Extract content after the second ---
  local prompt
  prompt=$(sed '1,/^---$/d' "$cmd_file" | sed '1,/^---$/d')

  # Run Claude Code
  claude -p "$prompt" \
    --allowedTools "Read,Write,Edit,Glob,Bash(git add:*),Bash(ls:*),Skill" \
    --max-turns 20

  # Stage any changes to _indices
  git add "_indices/*" 2>/dev/null || true

  echo ">>> Indices maintenance complete."
}

# Execute based on choice (failures will abort commit due to set -e)
case "$choice" in
  m|M)
    run_meta_update
    ;;
  i|I)
    run_indices_update
    ;;
  b|B)
    run_meta_update
    run_indices_update
    ;;
  s|S)
    echo "Skipping maintenance..."
    ;;
  *)
    echo "Invalid choice. Aborting commit."
    exit 1
    ;;
esac

echo ""
echo "Pre-commit hook completed successfully."
exit 0
