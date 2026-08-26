# ChatGPT Windows「找不到 Codex CLI」启动错误修复

这是一个社区排障项目，用于处理 Windows 桌面端启动时报错：

> `Unable to locate the Codex CLI binary. Set CODEX_CLI_PATH or ensure the Electron resources include bin/codex.`

本项目记录了一套在 **2026-08-26、Windows 11** 上实际验证成功的临时解决方案。OpenAI 的 `openai/codex` 仓库中已有高度一致的上游 Bug：**Issue #40752**。

> **注意：** 这不是 OpenAI 官方修复，而是社区 workaround。官方版本更新后，应优先使用官方修复。

## 问题原因

某些 Windows 桌面端更新后，应用可能无法找到随应用打包的 Codex CLI。即使手动安装了 Codex CLI，如果把 `CODEX_CLI_PATH` 指向 npm 生成的 `codex.cmd`，还可能出现 `spawn EINVAL`。

当前 workaround 是：

**让 `CODEX_CLI_PATH` 直接指向 npm 包内部真正的原生 `codex.exe`。**

上游 Bug：
- https://github.com/openai/codex/issues/40752

OpenAI 官方参考：
- ChatGPT Windows App：https://help.openai.com/zh-hans-cn/articles/9982051-using-the-chatgpt-windows-app
- 新版 ChatGPT Desktop：https://help.openai.com/en/articles/20001276

## 小白版完整步骤

### 第 1 步：确认 Node.js

打开 **PowerShell**：按 `Win` 键，搜索 `PowerShell`，打开。

输入：

```powershell
node --version
```

如果出现版本号，例如 `v24.x.x`，继续。

### 第 2 步：如果 `npm` 被 PowerShell 拦截，改用 `npm.cmd`

如果输入 `npm --version` 后出现：

```text
因为在此系统上禁止运行脚本
PSSecurityException
```

不需要为了这个教程去修改系统执行策略，直接输入：

```powershell
npm.cmd --version
```

### 第 3 步：安装 Codex CLI

```powershell
npm.cmd install -g @openai/codex
```

安装完成后验证：

```powershell
codex.cmd --version
```

如果出现类似：

```text
codex-cli 0.149.1
```

说明 CLI 已安装。

### 第 4 步：找到真正的 `codex.exe`

```powershell
Get-ChildItem "$(npm.cmd root -g)\@openai" -Recurse -Filter codex.exe -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty FullName
```

通常会得到类似：

```text
C:\Users\<YOUR_USERNAME>\AppData\Roaming\npm\node_modules\@openai\codex\node_modules\@openai\codex-win32-x64\vendor\x86_64-pc-windows-msvc\bin\codex.exe
```

### 第 5 步：设置 `CODEX_CLI_PATH`

把下面示例路径替换成你刚才实际找到的路径：

```powershell
[Environment]::SetEnvironmentVariable(
  "CODEX_CLI_PATH",
  "C:\Users\<YOUR_USERNAME>\AppData\Roaming\npm\node_modules\@openai\codex\node_modules\@openai\codex-win32-x64\vendor\x86_64-pc-windows-msvc\bin\codex.exe",
  "User"
)
```

然后**重启 Windows**，或者注销后重新登录。

### 第 6 步：重启后验证

重新打开 PowerShell：

```powershell
$env:CODEX_CLI_PATH
Test-Path $env:CODEX_CLI_PATH
& $env:CODEX_CLI_PATH --version
```

正常结果应该包含：

```text
True
codex-cli <版本号>
```

此时再启动 ChatGPT。

## 自动辅助脚本

仓库内提供：

- `scripts/diagnose.ps1`：只诊断，不修改电脑。
- `scripts/fix.ps1`：寻找真正的 `codex.exe`，显示路径并询问你是否确认，然后设置“当前用户”的 `CODEX_CLI_PATH`。

如果你的 PowerShell 禁止执行 `.ps1`，可以直接打开脚本查看里面的命令，然后手动复制运行，不必修改 ExecutionPolicy。

## 为什么不能直接用 `codex.cmd`？

上游 Bug 报告指出，Windows Electron 客户端直接 `spawn` `.cmd` wrapper 时可能出现：

```text
spawn EINVAL
```

而真正的原生 `codex.exe` 不需要经过 `.cmd` wrapper，因此可以绕过这一层问题。

## 如果仍然失败

1. 先检查 ChatGPT 是否已有更新。
2. 确认 `Test-Path $env:CODEX_CLI_PATH` 为 `True`。
3. 确认 `& $env:CODEX_CLI_PATH --version` 能正常输出版本。
4. 必要时按官方方法重置 Windows App：**设置 → 应用 → 已安装的应用 → ChatGPT → 高级选项 → 重置**。
5. 查看上游 Issue 是否已经有正式修复。

## 上传截图前一定要脱敏

不要公开：

- 真实 Windows 用户名；
- 桌面上能看到的学校/工作文件；
- 邮箱、Token、API Key、Cookie、账号 ID；
- 私人文件名和路径。

统一使用：

```text
C:\Users\<YOUR_USERNAME>\...
```

## 本次实际验证环境

- Windows 11 x64
- 已安装 Node.js
- `npm.cmd` 可正常使用
- 原始案例 Codex CLI：`0.149.1`
- 验证日期：2026-08-26

## License

MIT，见 [LICENSE](LICENSE)。
