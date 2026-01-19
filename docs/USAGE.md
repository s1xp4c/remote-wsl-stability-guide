# 🧭 Usage guide

This repo targets a common Remote-WSL failure mode:
**WSL gets unhealthy (often memory pressure / OOM)** → VS Code Remote-WSL loses the extension host → reconnect loops.

📚 Official sources for the exact commands/settings used:
- docs/REFERENCES.md

---

## 🧷 Where to run scripts

### 🪟 PowerShell (Windows) — `.ps1`
Run the scripts in `scripts/` that end with `.ps1`.
They call `wsl.exe` to query or restart your Ubuntu distro.

Example:
    powershell -ExecutionPolicy Bypass -File .\scripts\windows-wsl-health-snapshot.ps1

### 🐧 Ubuntu (WSL) — `.sh`
Run the scripts in `scripts/` that end with `.sh`.
Useful when VS Code is broken but WSL still opens in Windows Terminal.

Example:
    bash ./scripts/ubuntu-fs-check.sh

---

## 🧪 Scripts (what + when)

### scripts/windows-wsl-ping.ps1
Docs:
- wsl.exe commands: docs/REFERENCES.md#wsl-command-line-wslexe

Use when:
- 🔌 Remote-WSL spinner/reconnect loop
- ✅ You just want to know if WSL responds

What it does:
- Lists distros and queries Ubuntu for time, uptime, and memory

Bad signs:
- Timeouts / `Wsl/Service/0x8007274c`

---

### scripts/windows-wsl-oom-check.ps1
Docs:
- Linux dmesg: docs/REFERENCES.md#linux-commands-used-by-scripts-man-pages

Use when:
- 🧠 Node/dev server dies suddenly
- 🔌 Remote-WSL disconnects after starting a dev server

What it does:
- Prints recent OOM-kill lines from kernel logs

If you see:
- “Out of memory: Killed process … (node)”
Then:
- Enable swap + restart WSL

---

### scripts/windows-enable-wsl-swap.ps1
Docs:
- WSL .wslconfig settings: docs/REFERENCES.md#wsl-configuration-wslconfig
- wsl.exe commands: docs/REFERENCES.md#wsl-command-line-wslexe

Use when:
- 💾 Swap is `0B` inside Ubuntu
- 🧠 OOM kills appear in `dmesg`

What it does:
- Backs up `%UserProfile%\.wslconfig`
- Writes a safe `.wslconfig` with swap enabled (and avoids forcing `swapFile`)
- Runs `wsl --shutdown`
- Verifies swap from inside Ubuntu

Note:
- `.wslconfig` changes apply only after WSL VM restart

---

### scripts/windows-wsl-health-snapshot.ps1
Docs:
- wsl.exe commands: docs/REFERENCES.md#wsl-command-line-wslexe
- Linux commands (free, dmesg, ps, swapon): docs/REFERENCES.md#linux-commands-used-by-scripts-man-pages

Use when:
- 📎 You want a single “attach-to-issue” diagnostic dump
- 🔍 You need a quick high-signal overview

What it does:
- WSL status + distro list
- Ubuntu kernel, uptime, memory, swap
- Top memory processes
- Recent OOM lines

---

### scripts/windows-wsl-restart.ps1
Docs:
- wsl.exe commands: docs/REFERENCES.md#wsl-command-line-wslexe

Use when:
- 🔄 You changed `.wslconfig`
- 🧱 WSL/Remote feels “stuck”
- ✅ You want a clean WSL VM restart without rebooting Windows

What it does:
- `wsl --shutdown`
- Shows `free -h` and `swapon --show`

---

### scripts/windows-vmmemwsl.ps1
Docs:
- PowerShell Get-Process:
  https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-process

Use when:
- 📈 You want a quick Windows-side view of WSL memory usage
- 🧪 You’re comparing “before/after swap enabled”

What it does:
- Prints working set MB for `vmmemWSL` (and `vmmem` if present)


### scripts/ubuntu-fs-check.sh
Docs:
- File placement & performance: docs/REFERENCES.md#file-placement--performance-why-home-on-ext4-matters

Use when:
- 📁 You’re unsure if your repo lives on `/mnt/c` or WSL ext4
- 🐢 File watchers/dev server feel slow or flaky

What it does:
- Shows your current path + filesystem type

Guidance:
- Prefer `/home/...` (ext4) for dev work

---

### scripts/ubuntu-reset-vscode-server.sh
Docs:
- VS Code Remote-WSL model & troubleshooting: docs/REFERENCES.md#vs-code-remote---wsl

Use when:
- 🔌 WSL responds, but VS Code can’t connect
- ♻️ VS Code keeps reinstalling server / hangs on extension host

What it does:
- Deletes `~/.vscode-server` and `~/.vscode-remote` in Ubuntu

Why it helps:
- Forces a clean server reinstall on next Remote-WSL connect

