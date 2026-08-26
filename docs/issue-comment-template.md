# Upstream issue comment template

Use this as a starting point if you want to add your independent reproduction to:
https://github.com/openai/codex/issues/40752

## English

I independently reproduced this on Windows 11 x64 on 2026-08-26.

Symptoms:
- The desktop app had worked earlier the same day.
- A later launch failed with: `Unable to locate the Codex CLI binary`.
- Installing `@openai/codex` globally was not enough by itself.

What worked for me:
1. Install/verify Codex CLI with `npm.cmd install -g @openai/codex`.
2. Locate the native `codex.exe` under the global npm package tree.
3. Set the user-level `CODEX_CLI_PATH` directly to that native `.exe` (not `codex.cmd`).
4. Restart Windows.
5. Verify the path exists and the binary runs, then relaunch the desktop app.

Verification commands:

```powershell
Test-Path $env:CODEX_CLI_PATH
& $env:CODEX_CLI_PATH --version
```

After this, the desktop app launched normally again.

## 中文

我在 Windows 11 x64 上于 2026-08-26 独立复现了同类问题。

现象：
- 当天较早时候桌面端仍能正常使用；
- 之后再次启动时报 `Unable to locate the Codex CLI binary`；
- 单纯全局安装 `@openai/codex` 仍不足以恢复启动。

最终有效的方法：
1. 使用 `npm.cmd install -g @openai/codex` 安装/确认 Codex CLI；
2. 在全局 npm 包目录中找到真正的原生 `codex.exe`；
3. 将用户级 `CODEX_CLI_PATH` 直接指向这个 `.exe`，而不是 `codex.cmd`；
4. 重启 Windows；
5. 确认路径存在且 binary 可执行后，再启动桌面端。

验证命令：

```powershell
Test-Path $env:CODEX_CLI_PATH
& $env:CODEX_CLI_PATH --version
```

完成后桌面端恢复正常启动。
