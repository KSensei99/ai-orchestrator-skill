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

## 🧠 Core Philosophy & Truth Principles

This orchestrator enforces strict constraints on the AI's logic to prevent common pitfalls such as speculation, false agreement, and bloated code modifications:

*   **Speak the Hard Truth**: The AI is forbidden from lying, guessing, or presenting ambiguous/speculative results. All responses must be grounded in verified facts.
*   **Adversarial Objectivity**: The AI will not blindly agree with the user to be polite or "helpful". It is instructed to fact-check user inputs, identify errors, and only agree when the user is factually correct.
*   **Surgical Code Changes**: Touch only what you must. The AI is directed to write/modify the minimum amount of code required to resolve a task, avoiding unrelated changes.
*   **No Speculation**: The AI must not guess intent, configurations, or parameters. If there is ambiguity or a lack of context, the AI will openly expose its confusion.
*   **Expose Trade-offs**: All architectural, design, or layout recommendations must be presented alongside their trade-offs (never as one-sided wins).
*   **Cleanup Your Mess**: The AI only cleans up or alters files and environments that it directly created during the active task.

---

## 🛠️ Installation & Setup

Choose your installation method: either a **one-command script** for your specific Operating System, or a **manual configuration** guide for your specific AI Coder/IDE.

---

### 💻 OS-Specific One-Command Installation

Run the command matching your operating system in your terminal to open an interactive installation wizard.

#### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/KSensei99/ai-orchestrator-skill/main/install.ps1 | iex
```
*Note: This downloads and runs the PowerShell installer to set up Cursor, Claude, Windsurf, or global config directories.*

#### macOS / Linux (Bash)
```bash
curl -sSL https://raw.githubusercontent.com/KSensei99/ai-orchestrator-skill/main/install.sh | bash
```
*Note: This downloads and executes the Bash installer script. You can pass arguments to run silently: `curl -sSL ... | bash -s -- --target cursor`.*

---

### ⚙️ IDE & AI Coder Manual Configuration

If you prefer to configure the orchestrator manually, follow the guide for your environment:

#### 🟢 Claude Code
1. Copy the contents of [orchestrator-skill.md](orchestrator-skill.md).
2. Save it as `.clauderules` at the root of your project repository.
3. Claude CLI will automatically load these rules at startup.

#### 🔵 Cursor
1. Copy the contents of [orchestrator-skill.md](orchestrator-skill.md).
2. Paste them into a `.cursorrules` file at the root of your project directory, or add them in the UI settings under **Cursor Settings > Features > Rules for AI**.

#### 🟡 Windsurf
1. Copy the contents of [orchestrator-skill.md](orchestrator-skill.md).
2. Save it as `.windsurfrules` at the root of your workspace.

#### 🐙 VS Code & GitHub Copilot
1. Copy the contents of [orchestrator-skill.md](orchestrator-skill.md).
2. Create a `.github` folder if it doesn't exist and save the file as `.github/copilot-instructions.md` in your project repository.

#### 🌐 Web-Based AI Coders (Kimi, Qwen, Codex, ChatGPT)
- Copy the contents of [orchestrator-skill.md](orchestrator-skill.md).
- Paste them into the **Custom Instructions** / **System Instructions** settings in the model's web interface, or send it as the initial prompt of a new chat session.

#### 🧠 Antigravity / OpenCode / Hermes / Kiro
To install as a global system skill:
1. Create a directory named `fetch-function` inside your global skill config path:
   - macOS/Linux: `~/.config/skills/fetch-function/`
   - Windows: `%USERPROFILE%\.gemini\config\skills\fetch-function\`
2. Save [orchestrator-skill.md](orchestrator-skill.md) as `SKILL.md` inside that directory.
3. Save `scripts/update_graph.py` inside a `scripts/` folder in that directory to enable dynamic graph indexing.

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
