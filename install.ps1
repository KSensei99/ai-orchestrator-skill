# AI Orchestrator Skill - Windows PowerShell Installer
# Installs the orchestrator skill across different AI coding environments (Claude Code, Cursor, Windsurf, Copilot, Antigravity, etc.)

param (
    [string]$Target = "menu"
)

$RepoRawUrl = "https://raw.githubusercontent.com/KSensei99/ai-orchestrator-skill/main"

function Show-Help {
    Write-Host "Usage: .\install.ps1 -Target <type>"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Target <type>   Specify target: cursor, claude, windsurf, copilot, antigravity, all-local, menu"
}

function Get-Content-Helper {
    param ($Filename)
    if (Test-Path $Filename) {
        return Get-Content -Raw $Filename
    } else {
        $url = "$RepoRawUrl/$Filename"
        return Invoke-RestMethod -Uri $url -UseBasicParsing
    }
}

function Detect-And-Update-Graph {
    $possibleGraphs = @(
        "knowledge/graphify-out/graph.json",
        "graphify-out/graph.json",
        "graph.json",
        "../knowledge/graphify-out/graph.json"
    )
    
    $graphPath = $null
    foreach ($g in $possibleGraphs) {
        if (Test-Path $g) {
            $graphPath = $g
            break
        }
    }
    
    if ($null -ne $graphPath) {
        Write-Host "Graphify graph detected at: $graphPath"
        
        # Ensure scripts/update_graph.py is present
        if (-not (Test-Path "scripts/update_graph.py")) {
            if (-not (Test-Path "scripts")) {
                New-Item -ItemType Directory -Path "scripts" | Out-Null
            }
            $scriptContent = Get-Content-Helper "scripts/update_graph.py"
            $scriptContent | Out-File -FilePath "scripts/update_graph.py" -Encoding utf8
        }
        
        # Check if Python is installed and run
        $pythonCmd = $null
        if (Get-Command "python3" -ErrorAction SilentlyContinue) {
            $pythonCmd = "python3"
        } elseif (Get-Command "python" -ErrorAction SilentlyContinue) {
            $pythonCmd = "python"
        }
        
        if ($null -ne $pythonCmd) {
            & $pythonCmd "scripts/update_graph.py" --skill "orchestrator-skill" --category "knowledge_skills_ai_agentic_systems" --description "Master orchestration and dynamic learning skill." --graph "$graphPath"
            Write-Host "[SUCCESS] Automatically registered orchestrator-skill in detected Graphify graph." -ForegroundColor Green
        } else {
            Write-Host "[WARNING] Python not found. Skipping automatic Graphify indexing." -ForegroundColor Yellow
            Write-Host "You can index manually later using: python scripts/update_graph.py --skill orchestrator-skill --category knowledge_skills_ai_agentic_systems --description '...' --graph $graphPath" -ForegroundColor Yellow
        }
    }
}

function Install-Cursor {
    Write-Host "Installing for Cursor (.cursorrules)..."
    $content = Get-Content-Helper "orchestrator-skill.md"
    $content | Out-File -FilePath ".cursorrules" -Encoding utf8
    Write-Host "[SUCCESS] Saved to .cursorrules in current directory." -ForegroundColor Green
    Detect-And-Update-Graph
}

function Install-Claude {
    Write-Host "Installing for Claude Code (.clauderules)..."
    $content = Get-Content-Helper "orchestrator-skill.md"
    $content | Out-File -FilePath ".clauderules" -Encoding utf8
    Write-Host "[SUCCESS] Saved to .clauderules in current directory." -ForegroundColor Green
    Detect-And-Update-Graph
}

function Install-Windsurf {
    Write-Host "Installing for Windsurf (.windsurfrules)..."
    $content = Get-Content-Helper "orchestrator-skill.md"
    $content | Out-File -FilePath ".windsurfrules" -Encoding utf8
    Write-Host "[SUCCESS] Saved to .windsurfrules in current directory." -ForegroundColor Green
    Detect-And-Update-Graph
}

function Install-Copilot {
    Write-Host "Installing for GitHub Copilot (.github/copilot-instructions.md)..."
    if (-not (Test-Path ".github")) {
        New-Item -ItemType Directory -Path ".github" | Out-Null
    }
    $content = Get-Content-Helper "orchestrator-skill.md"
    $content | Out-File -FilePath ".github/copilot-instructions.md" -Encoding utf8
    Write-Host "[SUCCESS] Saved to .github/copilot-instructions.md in current directory." -ForegroundColor Green
    Detect-And-Update-Graph
}

function Install-Antigravity {
    Write-Host "Installing for Antigravity/OpenCode/Hermes/Kiro..."
    
    $homeDir = [System.Environment]::GetFolderPath("UserProfile")
    $skillPaths = @(
        "$homeDir\.config\opencode\skills\fetch-function",
        "$homeDir\.gemini\config\skills\fetch-function",
        "$homeDir\.config\skills\fetch-function"
    )
    
    $installed = $false
    foreach ($path in $skillPaths) {
        $parentDir = Split-Path -Parent $path
        if (Test-Path $parentDir) {
            Write-Host "Found config path: $parentDir"
            if (-not (Test-Path "$path\scripts")) {
                New-Item -ItemType Directory -Path "$path\scripts" -Force | Out-Null
            }
            $skillContent = Get-Content-Helper "orchestrator-skill.md"
            $scriptContent = Get-Content-Helper "scripts/update_graph.py"
            
            $skillContent | Out-File -FilePath "$path\SKILL.md" -Encoding utf8
            $scriptContent | Out-File -FilePath "$path\scripts\update_graph.py" -Encoding utf8
            Write-Host "[SUCCESS] Installed skill to $path" -ForegroundColor Green
            $installed = $true
        }
    }
    
    if (-not $installed) {
        # Fallback to default
        $fallback = "$homeDir\.gemini\config\skills\fetch-function"
        Write-Host "No config directory found. Creating default: $homeDir\.gemini\config\skills\"
        if (-not (Test-Path "$fallback\scripts")) {
            New-Item -ItemType Directory -Path "$fallback\scripts" -Force | Out-Null
        }
        $skillContent = Get-Content-Helper "orchestrator-skill.md"
        $scriptContent = Get-Content-Helper "scripts/update_graph.py"
        
        $skillContent | Out-File -FilePath "$fallback\SKILL.md" -Encoding utf8
        $scriptContent | Out-File -FilePath "$fallback\scripts\update_graph.py" -Encoding utf8
        Write-Host "[SUCCESS] Installed skill to $fallback" -ForegroundColor Green
    }
}

function Install-All-Local {
    Install-Cursor
    Install-Claude
    Install-Windsurf
    Install-Copilot
}

function Show-Menu {
    Clear-Host
    Write-Host "=================================================="
    Write-Host "      AI Orchestrator Skill Installer             "
    Write-Host "=================================================="
    Write-Host "Where would you like to install the Orchestrator?"
    Write-Host "1) Cursor (.cursorrules)"
    Write-Host "2) Claude Code (.clauderules)"
    Write-Host "3) Windsurf (.windsurfrules)"
    Write-Host "4) GitHub Copilot (.github/copilot-instructions.md)"
    Write-Host "5) Antigravity/OpenCode/Hermes/Kiro (~/.config/skills/)"
    Write-Host "6) All Project-level rules (Cursor + Claude + Windsurf + Copilot)"
    Write-Host "7) Cancel"
    
    $opt = Read-Host "Select option [1-7]"
    switch ($opt) {
        "1" { Install-Cursor }
        "2" { Install-Claude }
        "3" { Install-Windsurf }
        "4" { Install-Copilot }
        "5" { Install-Antigravity }
        "6" { Install-All-Local }
        "7" { Write-Host "Cancelled."; exit }
        default { Write-Host "Invalid option."; Start-Sleep -Seconds 1; Show-Menu }
    }
}

switch ($Target) {
    "cursor" { Install-Cursor }
    "claude" { Install-Claude }
    "windsurf" { Install-Windsurf }
    "copilot" { Install-Copilot }
    "antigravity" { Install-Antigravity }
    "all-local" { Install-All-Local }
    "menu" { Show-Menu }
    default { Write-Host "Unknown target: $Target"; Show-Help; exit 1 }
}

Write-Host "Done!" -ForegroundColor Cyan
