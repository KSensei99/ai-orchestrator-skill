#!/usr/bin/env bash

# AI Orchestrator Skill - Unix/macOS Installer
# Installs the orchestrator skill across different AI coding environments (Claude Code, Cursor, Windsurf, Copilot, Antigravity, etc.)

REPO_RAW_URL="https://raw.githubusercontent.com/KSensei99/ai-orchestrator-skill/main"

# Help message
show_help() {
  echo "Usage: ./install.sh [options]"
  echo ""
  echo "Options:"
  echo "  --target <type>   Specify target: cursor, claude, windsurf, copilot, global-apps, all-local, menu"
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

install_global_apps() {
  echo "Installing globally for Desktop Apps and CLI sessions..."
  
  local skill_content=""
  local script_content=""
  
  skill_content=$(get_content "orchestrator-skill.md")
  script_content=$(get_content "scripts/update_graph.py")
  
  # 1. Claude Code Global Rules (~/.clauderules)
  echo "$skill_content" > "$HOME/.clauderules"
  echo "[SUCCESS] Installed globally for Claude Code in $HOME/.clauderules"
  
  # 2. Cursor Global Rules (~/.cursorrules)
  echo "$skill_content" > "$HOME/.cursorrules"
  echo "[SUCCESS] Installed globally for Cursor in $HOME/.cursorrules"
  
  # 3. System Config Skill Directories (Antigravity, OpenCode, Hermes, Kiro, Qwen, Codex, Claude Code, Cursor)
  local config_pairs
  if [ "$(uname)" = "Darwin" ]; then
    config_pairs=(
      "$HOME/.gemini:$HOME/.gemini/config/skills/fetch-function"
      "$HOME/.config/opencode:$HOME/.config/opencode/skills/fetch-function"
      "$HOME/.config/qwen:$HOME/.config/qwen/skills/fetch-function"
      "$HOME/.config/codex:$HOME/.config/codex/skills/fetch-function"
      "$HOME/.config/hermes:$HOME/.config/hermes/skills/fetch-function"
      "$HOME/.config/kiro:$HOME/.config/kiro/skills/fetch-function"
      "$HOME/.config/claude:$HOME/.config/claude/skills/fetch-function"
      "$HOME/.config/cursor:$HOME/.config/cursor/skills/fetch-function"
      "$HOME/.config:$HOME/.config/skills/fetch-function"
      "$HOME/Library/Application Support/opencode:$HOME/Library/Application Support/opencode/skills/fetch-function"
      "$HOME/Library/Application Support/qwen:$HOME/Library/Application Support/qwen/skills/fetch-function"
      "$HOME/Library/Application Support/codex:$HOME/Library/Application Support/codex/skills/fetch-function"
      "$HOME/Library/Application Support/hermes:$HOME/Library/Application Support/hermes/skills/fetch-function"
      "$HOME/Library/Application Support/kiro:$HOME/Library/Application Support/kiro/skills/fetch-function"
      "$HOME/Library/Application Support/claude:$HOME/Library/Application Support/claude/skills/fetch-function"
      "$HOME/Library/Application Support/cursor:$HOME/Library/Application Support/cursor/skills/fetch-function"
    )
  else
    config_pairs=(
      "$HOME/.gemini:$HOME/.gemini/config/skills/fetch-function"
      "$HOME/.config/opencode:$HOME/.config/opencode/skills/fetch-function"
      "$HOME/.config/qwen:$HOME/.config/qwen/skills/fetch-function"
      "$HOME/.config/codex:$HOME/.config/codex/skills/fetch-function"
      "$HOME/.config/hermes:$HOME/.config/hermes/skills/fetch-function"
      "$HOME/.config/kiro:$HOME/.config/kiro/skills/fetch-function"
      "$HOME/.config/claude:$HOME/.config/claude/skills/fetch-function"
      "$HOME/.config/cursor:$HOME/.config/cursor/skills/fetch-function"
      "$HOME/.config:$HOME/.config/skills/fetch-function"
    )
  fi
  
  local installed=false
  for pair in "${config_pairs[@]}"; do
    local root="${pair%%:*}"
    local path="${pair#*:}"
    if [ -d "$root" ]; then
      mkdir -p "$path/scripts"
      echo "$skill_content" > "$path/SKILL.md"
      echo "$script_content" > "$path/scripts/update_graph.py"
      echo "[SUCCESS] Installed skill to $path"
      installed=true
    fi
  done
  
  # Fallback: create default gemini config path if no config directories matched
  if [ "$installed" = false ]; then
    local default_gemini="$HOME/.gemini/config/skills/fetch-function"
    mkdir -p "$default_gemini/scripts"
    echo "$skill_content" > "$default_gemini/SKILL.md"
    echo "$script_content" > "$default_gemini/scripts/update_graph.py"
    echo "[SUCCESS] Installed skill to $default_gemini"
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
  echo "1) Local: Cursor (.cursorrules)"
  echo "2) Local: Claude Code (.clauderules)"
  echo "3) Local: Windsurf (.windsurfrules)"
  echo "4) Local: GitHub Copilot (.github/copilot-instructions.md)"
  echo "5) Local: All project rules (Cursor + Claude + Windsurf + Copilot)"
  echo "6) Global: Install for all Desktop Apps & CLIs (Cursor, Claude, Qwen, Codex, Hermes, Kiro)"
  echo "7) Cancel"
  read -p "Select option [1-7]: " opt
  case $opt in
    1) install_cursor ;;
    2) install_claude ;;
    3) install_windsurf ;;
    4) install_copilot ;;
    5) install_all_local ;;
    6) install_global_apps ;;
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
  global-apps) install_global_apps ;;
  all-local) install_all_local ;;
  menu) run_menu ;;
  *) echo "Unknown target: $TARGET"; show_help; exit 1 ;;
esac

echo "Done!"
