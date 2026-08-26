Write-Host "=== ChatGPT / Codex CLI Diagnostic ==="
Write-Host "This script is read-only and does not change your system."
Write-Host ""

function Run-VersionCheck($label, $command, $arguments) {
    try {
        $output = & $command @arguments 2>&1
        Write-Host "[OK] $label: $output"
    } catch {
        Write-Host "[FAIL] $label: $($_.Exception.Message)"
    }
}

Run-VersionCheck "Node.js" "node" @("--version")
Run-VersionCheck "npm.cmd" "npm.cmd" @("--version")
Run-VersionCheck "codex.cmd" "codex.cmd" @("--version")

Write-Host ""
Write-Host "CODEX_CLI_PATH: $env:CODEX_CLI_PATH"
if ($env:CODEX_CLI_PATH) {
    $exists = Test-Path $env:CODEX_CLI_PATH
    Write-Host "Path exists: $exists"
    if ($exists) {
        try {
            $version = & $env:CODEX_CLI_PATH --version 2>&1
            Write-Host "Native Codex version: $version"
        } catch {
            Write-Host "[FAIL] Native codex.exe could not run: $($_.Exception.Message)"
        }
    }
}

Write-Host ""
try {
    $root = & npm.cmd root -g 2>$null
    Write-Host "Global npm root: $root"
    $matches = Get-ChildItem "$root\@openai" -Recurse -Filter codex.exe -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty FullName
    if ($matches) {
        Write-Host "Native codex.exe candidate(s):"
        $matches | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "No native codex.exe found under the global @openai package tree."
    }
} catch {
    Write-Host "Could not search the global npm tree: $($_.Exception.Message)"
}
