# AI Orchestrator Skill

A master orchestration and dynamic learning framework designed for AI coding agents and IDEs (e.g., **Claude Code**, **Cursor**, **Kimi**, **Codex**, **Windsurf**, and **GitHub Copilot**).

This orchestration layer forces the AI agent to assess task complexity, decompose requests into atomic sub-tasks, and match them against specialized domain skills and toolsets before writing code or running commands. It ensures **zero raw execution** (always grounding actions in skills or documentation) and features a structured **3-Phase Critical Analysis** (Red Team → Premortem → Steelman) and a **Deep Research Pipeline**.

---

## 🚀 How It Works

1. **Step 0: Active Mind Assessment**:
   - The AI evaluates the true complexity (not just length) of the request.
   - Decomposes the prompt into atomic, manageable sub-tasks.
   - Routes to the correct function (e.g., standard execution, 3-Phase Analysis, or Deep Research).

2. **Function 1: 3-Phase Analysis (3PA)**:
   - Activates when the prompt verbatim contains `"3 Phase Analysis"`.
   - Adversarially pressure-tests proposals through three sequential phases:
     - **Red Team**: Attacks the plan from all angles to find flaws.
     - **Premortem**: Assumes complete failure and analyzes root causes.
     - **Steelman**: Rebuilds the strongest version addressing all risks.

3. **Function 2: Skill Fetching & Execution**:
   - Maps each sub-task to the best skill or tool (e.g., database, security, devops).
   - **Dynamic Graph Learning**: Reads the selected skill's instructions, extracts its capabilities, and updates a knowledge graph (e.g., `graph.json`) using `scripts/update_graph.py` so the system learns what the skill does best.
   - Checks tool/MCP availability and presents an Execution Plan before making changes.

4. **Function 3: Deep Research Pipeline**:
   - Activates on research-intent triggers (e.g., `"deep research"`).
   - Iteratively searches the web, reads raw contents, audits details for contradictions, and synthesizes a high-fidelity report with clickable inline markdown citations.

---

## 🛠️ Installation & Setup

Choose the guide below corresponding to your AI assistant/IDE:

### 1. Cursor (`.cursorrules`)
To load the orchestrator project-wide in Cursor:
1. Copy the contents of `orchestrator-skill.md`.
2. Paste them into a `.cursorrules` file at the root of your project directory, or add them under **Cursor Settings > Features > Rules for AI**.

### 2. Claude Code (`.clauderules`)
To load the orchestrator in Claude CLI sessions:
1. Copy the contents of `orchestrator-skill.md`.
2. Save it as `.clauderules` in the root of your git repository. Claude CLI will automatically load these rules at startup.

### 3. GitHub Copilot & VS Code (`.github/copilot-instructions.md`)
To guide GitHub Copilot in VS Code or VS Code Chat:
1. Copy the contents of `orchestrator-skill.md`.
2. Save it as `.github/copilot-instructions.md` in your project repository.

### 4. Windsurf (`.windsurfrules`)
To configure Windsurf's agent:
1. Copy the contents of `orchestrator-skill.md`.
2. Save it as `.windsurfrules` at the root of your workspace.

### 5. Kimi, Codex, ChatGPT, & Other Web UIs
For web-based AI coding interfaces:
- Paste the contents of `orchestrator-skill.md` as custom instructions in your system prompt settings, or paste it as the initial system framing prompt at the start of your chat session.

---

## 📊 Dynamic Graph Learning (Optional)

If your system uses a Graphify-style JSON knowledge graph (`graph.json`) to index files and directories, you can use the included `scripts/update_graph.py` script to dynamically index skill capabilities during comparison:

```bash
python scripts/update_graph.py --skill [skill-name] --category [category-node-id] --description "[what-it-does-best]" --graph [path/to/graph.json]
```

### Script Arguments:
* `--skill`: The name of the skill being indexed (e.g., `react-testing`).
* `--category`: The ID of the parent category in the graph (e.g., `skills_testing`).
* `--description`: A brief summary of what the skill does best.
* `--graph`: (Optional) Path to your `graph.json`. If omitted, the script checks common relative paths.

---

## 📜 License
This project is licensed under the MIT License. Feel free to customize and share it with your team!
