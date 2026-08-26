Write-Host "=== ChatGPT / Codex CLI Workaround ==="
Write-Host "This script will only set the current user's CODEX_CLI_PATH after asking for confirmation."
Write-Host ""

try {
    $root = & npm.cmd root -g 2>$null
} catch {
    Write-Host "npm.cmd is not available. Install Node.js/npm first."
    exit 1
}

$matches = @(Get-ChildItem "$root\@openai" -Recurse -Filter codex.exe -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName)

if ($matches.Count -eq 0) {
    Write-Host "No native codex.exe was found."
    Write-Host "Try: npm.cmd install -g @openai/codex"
    exit 1
}

if ($matches.Count -gt 1) {
    Write-Host "Multiple codex.exe files were found:"
    for ($i = 0; $i -lt $matches.Count; $i++) {
        Write-Host "[$i] $($matches[$i])"
    }
    $selection = Read-Host "Enter the number to use"
    if ($selection -notmatch '^\d+$' -or [int]$selection -ge $matches.Count) {
        Write-Host "Invalid selection. No changes made."
        exit 1
    }
    $codexExe = $matches[[int]$selection]
} else {
    $codexExe = $matches[0]
}

Write-Host ""
Write-Host "Candidate: $codexExe"
try {
    $version = & $codexExe --version 2>&1
    Write-Host "Version check: $version"
} catch {
    Write-Host "The candidate exists but could not be executed. No changes made."
    exit 1
}

$answer = Read-Host "Set user-level CODEX_CLI_PATH to this file? (y/N)"
if ($answer -notin @('y','Y','yes','YES','Yes')) {
    Write-Host "Cancelled. No changes made."
    exit 0
}

[Environment]::SetEnvironmentVariable("CODEX_CLI_PATH", $codexExe, "User")
Write-Host ""
Write-Host "Done. CODEX_CLI_PATH was set for the current user."
Write-Host "Restart Windows (or sign out and sign back in), then launch ChatGPT again."
