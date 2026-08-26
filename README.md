# ChatGPT Windows Codex CLI Fix

A community troubleshooting guide for a Windows desktop startup error where ChatGPT/Codex fails with:

> `Unable to locate the Codex CLI binary. Set CODEX_CLI_PATH or ensure the Electron resources include bin/codex.`

This repository documents a workaround that was successfully tested on Windows 11 on **2026-08-26**. A matching upstream bug report exists in `openai/codex` issue **#40752**.

> **Important:** This is an unofficial community workaround, not an official OpenAI fix. Prefer an official app update when one becomes available.

## What happened

A Windows desktop app update may fail to locate its bundled Codex CLI binary. Pointing `CODEX_CLI_PATH` at the npm wrapper `codex.cmd` can also fail with `spawn EINVAL`. The workaround is to point `CODEX_CLI_PATH` directly at the native `codex.exe` inside the globally installed `@openai/codex` package.

Upstream report:
- https://github.com/openai/codex/issues/40752

Official references:
- ChatGPT Windows app: https://help.openai.com/en/articles/9982051-using-the-chatgpt-windows-app
- New ChatGPT desktop app: https://help.openai.com/en/articles/20001276

## Quick fix

### 1. Check Node.js

Open **PowerShell** and run:

```powershell
node --version
```

If you see a version number, continue.

### 2. Use `npm.cmd` if PowerShell blocks `npm.ps1`

Some Windows systems block PowerShell scripts and show a `PSSecurityException` for `npm`. You do **not** need to change your execution policy just for this guide.

```powershell
npm.cmd --version
```

### 3. Install Codex CLI

```powershell
npm.cmd install -g @openai/codex
```

Verify:

```powershell
codex.cmd --version
```

### 4. Find the real native `codex.exe`

```powershell
Get-ChildItem "$(npm.cmd root -g)\@openai" -Recurse -Filter codex.exe -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty FullName
```

Expected path shape:

```text
C:\Users\<YOUR_USERNAME>\AppData\Roaming\npm\node_modules\@openai\codex\node_modules\@openai\codex-win32-x64\vendor\x86_64-pc-windows-msvc\bin\codex.exe
```

### 5. Set `CODEX_CLI_PATH`

Replace the sample path below with the path returned on your PC:

```powershell
[Environment]::SetEnvironmentVariable(
  "CODEX_CLI_PATH",
  "C:\Users\<YOUR_USERNAME>\AppData\Roaming\npm\node_modules\@openai\codex\node_modules\@openai\codex-win32-x64\vendor\x86_64-pc-windows-msvc\bin\codex.exe",
  "User"
)
```

Then **restart Windows** (or fully sign out and sign back in).

### 6. Verify after restart

Open a new PowerShell window:

```powershell
$env:CODEX_CLI_PATH
Test-Path $env:CODEX_CLI_PATH
& $env:CODEX_CLI_PATH --version
```

A healthy result looks like:

```text
True
codex-cli <version>
```

Now launch ChatGPT again.

## Automated helper

This repository includes two small PowerShell helpers:

- `scripts/diagnose.ps1` — read-only checks; changes nothing.
- `scripts/fix.ps1` — finds the native `codex.exe`, asks for confirmation, and sets the **user-level** `CODEX_CLI_PATH`.

Because PowerShell execution policies vary, you can also open the scripts in a text editor and run the commands manually.

## Why not point to `codex.cmd`?

The reported Windows desktop bug can produce `spawn EINVAL` when Electron tries to execute a `.cmd` wrapper directly. Pointing `CODEX_CLI_PATH` at the underlying native `.exe` bypasses that wrapper.

## If this still does not work

1. Check for a newer ChatGPT desktop app release.
2. Confirm `Test-Path $env:CODEX_CLI_PATH` returns `True`.
3. Confirm `& $env:CODEX_CLI_PATH --version` works.
4. If needed, reset the Windows app: **Settings → Apps → Installed apps → ChatGPT → Advanced options → Reset**.
5. Check the upstream issue for a permanent fix.

## Privacy before posting screenshots

Do not publish screenshots containing:

- your real Windows username;
- school/work documents visible on the desktop;
- email addresses, tokens, API keys, cookies, or account identifiers;
- private file names or paths.

Use placeholders such as `C:\Users\<YOUR_USERNAME>\...`.

## Tested environment

- Windows 11 x64
- Node.js installed
- npm available through `npm.cmd`
- Codex CLI `0.149.1` in the original test case
- Date tested: 2026-08-26

## License

MIT. See [LICENSE](LICENSE).
