# First-time GitHub upload guide (Windows)

This guide assumes you already have a GitHub account but have never uploaded a project.

## Recommended beginner route: GitHub website + upload files

This is the easiest first upload because it does not require installing Git yet.

### Step 1: Sign in

Open https://github.com and sign in.

### Step 2: Create a new repository

1. Click the `+` button in the top-right corner.
2. Choose **New repository**.
3. Repository name: `chatgpt-windows-codex-cli-fix`.
4. Description example: `Community workaround for ChatGPT Windows failing to locate the native Codex CLI binary.`
5. Choose **Public** if you want other users to find it.
6. Do **not** add a README, `.gitignore`, or license on the GitHub form because this project already contains them.
7. Click **Create repository**.

### Step 3: Upload the project files

After GitHub creates the empty repository:

1. Click **uploading an existing file**.
2. Open the local project folder.
3. Drag all files and folders into the GitHub upload area.
4. Confirm that GitHub shows `README.md`, `README_zh-CN.md`, `LICENSE`, `scripts/`, `docs/`, and the other files.
5. In **Commit changes**, enter: `Initial troubleshooting guide`.
6. Click **Commit changes**.

### Step 4: Check the repository homepage

GitHub should automatically render `README.md` on the repository homepage.

Check that:

- code blocks render correctly;
- links work;
- no personal information appears;
- the Chinese README opens normally.

### Step 5: Add repository topics

On the repository homepage, click the gear icon next to **About** and add topics such as:

- `chatgpt`
- `codex`
- `windows`
- `powershell`
- `troubleshooting`
- `openai`

Topics make the repository easier to discover.

### Step 6: Optional — add a screenshot later

Only upload screenshots after redacting personal data. A text-only repository is completely acceptable and safer for the first version.

## The Git way (recommended as your next exercise)

Once you are comfortable with the website upload, learn the normal Git workflow:

```powershell
git init
git add .
git commit -m "Initial troubleshooting guide"
git branch -M main
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/chatgpt-windows-codex-cli-fix.git
git push -u origin main
```

Do not run these commands blindly: first install Git for Windows and configure your Git name/email. This can be learned in a second exercise after the repository is online.
