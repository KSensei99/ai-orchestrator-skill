#!/usr/bin/env bash

# AI Orchestrator Skill - Unix/macOS Installer
# Installs the orchestrator skill across different AI coding environments (Claude Code, Cursor, Windsurf, Copilot, Antigravity, etc.)

REPO_RAW_URL="https://raw.githubusercontent.com/KSensei99/ai-orchestrator-skill/main"

# Help message
show_help() {
  echo "Usage: ./install.sh [options]"
  echo ""
  echo "Options:"
  echo "  --target <type>   Specify target: cursor, claude, windsurf, copilot, antigravity, all-local, menu"
  echo "  --help            Show this help message"
}

# Determine source: local files or remote raw fetch
get_content() {
  local filename=$1
  if [ -f "$filename" ]; then
    cat "$filename"
  else
    curl -sSL "$REPO_RAW_URL/$filename"
  fi
}

detect_and_update_graph() {
  local possible_graphs=(
    "knowledge/graphify-out/graph.json"
    "graphify-out/graph.json"
    "graph.json"
    "../knowledge/graphify-out/graph.json"
  )
  
  local graph_path=""
  for g in "${possible_graphs[@]}"; do
    if [ -f "$g" ]; then
      graph_path="$g"
      break
    fi
  done
  
  if [ -n "$graph_path" ]; then
    echo "Graphify graph detected at: $graph_path"
    
    # Ensure scripts/update_graph.py is present locally to execute
    if [ ! -f "scripts/update_graph.py" ]; then
      mkdir -p scripts
      get_content "scripts/update_graph.py" > scripts/update_graph.py
    fi
    
    if command -v python3 &>/dev/null; then
      python3 scripts/update_graph.py --skill orchestrator-skill --category knowledge_skills_ai_agentic_systems --description "Master orchestration and dynamic learning skill." --graph "$graph_path"
      echo "[SUCCESS] Automatically registered orchestrator-skill in detected Graphify graph."
    elif command -v python &>/dev/null; then
      python scripts/update_graph.py --skill orchestrator-skill --category knowledge_skills_ai_agentic_systems --description "Master orchestration and dynamic learning skill." --graph "$graph_path"
      echo "[SUCCESS] Automatically registered orchestrator-skill in detected Graphify graph."
    else
      echo "[WARNING] Python not found. Skipping automatic Graphify indexing."
      echo "You can index manually later using: python scripts/update_graph.py --skill orchestrator-skill --category knowledge_skills_ai_agentic_systems --description \"...\" --graph $graph_path"
    fi
  fi
}

install_cursor() {
  echo "Installing for Cursor (.cursorrules)..."
  get_content "orchestrator-skill.md" > .cursorrules
  echo "[SUCCESS] Saved to .cursorrules in current directory."
  detect_and_update_graph
}

install_claude() {
  echo "Installing for Claude Code (.clauderules)..."
  get_content "orchestrator-skill.md" > .clauderules
  echo "[SUCCESS] Saved to .clauderules in current directory."
  detect_and_update_graph
}

install_windsurf() {
  echo "Installing for Windsurf (.windsurfrules)..."
  get_content "orchestrator-skill.md" > .windsurfrules
  echo "[SUCCESS] Saved to .windsurfrules in current directory."
  detect_and_update_graph
}

install_copilot() {
  echo "Installing for GitHub Copilot (.github/copilot-instructions.md)..."
  mkdir -p .github
  get_content "orchestrator-skill.md" > .github/copilot-instructions.md
  echo "[SUCCESS] Saved to .github/copilot-instructions.md in current directory."
  detect_and_update_graph
}

install_antigravity() {
  echo "Installing for Antigravity/OpenCode/Hermes/Kiro..."
  
  # Determine local config path
  local skill_paths=(
    "$HOME/.config/opencode/skills/fetch-function"
    "$HOME/.gemini/config/skills/fetch-function"
    "$HOME/.config/skills/fetch-function"
  )
  
  local installed=0
  for path in "${skill_paths[@]}"; do
    # Check parent directory existence or create if .gemini/.config exists
    local parent_dir=$(dirname "$path")
    if [ -d "$parent_dir" ]; then
      echo "Found config path: $parent_dir"
      mkdir -p "$path/scripts"
      get_content "orchestrator-skill.md" > "$path/SKILL.md"
      get_content "scripts/update_graph.py" > "$path/scripts/update_graph.py"
      echo "[SUCCESS] Installed skill to $path"
      installed=1
    fi
  done
  
  if [ $installed -eq 0 ]; then
    # Fallback to default
    local fallback="$HOME/.gemini/config/skills/fetch-function"
    echo "No config directory found. Creating default: $HOME/.gemini/config/skills/"
    mkdir -p "$fallback/scripts"
    get_content "orchestrator-skill.md" > "$fallback/SKILL.md"
    get_content "scripts/update_graph.py" > "$fallback/scripts/update_graph.py"
    echo "[SUCCESS] Installed skill to $fallback"
  fi
}

install_all_local() {
  install_cursor
  install_claude
  install_windsurf
  install_copilot
}

run_menu() {
  echo "=================================================="
  echo "      AI Orchestrator Skill Installer             "
  echo "=================================================="
  echo "Where would you like to install the Orchestrator?"
  echo "1) Cursor (.cursorrules)"
  echo "2) Claude Code (.clauderules)"
  echo "3) Windsurf (.windsurfrules)"
  echo "4) GitHub Copilot (.github/copilot-instructions.md)"
  echo "5) Antigravity/OpenCode/Hermes/Kiro (~/.config/skills/)"
  echo "6) All Project-level rules (Cursor + Claude + Windsurf + Copilot)"
  echo "7) Cancel"
  read -p "Select option [1-7]: " opt
  case $opt in
    1) install_cursor ;;
    2) install_claude ;;
    3) install_windsurf ;;
    4) install_copilot ;;
    5) install_antigravity ;;
    6) install_all_local ;;
    7) echo "Cancelled."; exit 0 ;;
    *) echo "Invalid option."; run_menu ;;
  esac
}

# Command line parser
TARGET="menu"
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --target) TARGET="$2"; shift ;;
    --help) show_help; exit 0 ;;
    *) echo "Unknown option: $1"; show_help; exit 1 ;;
  esac
  shift
done

case $TARGET in
  cursor) install_cursor ;;
  claude) install_claude ;;
  windsurf) install_windsurf ;;
  copilot) install_copilot ;;
  antigravity) install_antigravity ;;
  all-local) install_all_local ;;
  menu) run_menu ;;
  *) echo "Unknown target: $TARGET"; show_help; exit 1 ;;
esac

echo "Done!"
