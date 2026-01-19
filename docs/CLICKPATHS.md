# 🪟 Windows click paths (so people feel safe)

These are “where do I click” equivalents of what the scripts do.

---

## 🧠 1) Check WSL memory usage (Task Manager)

1. Press **Ctrl + Shift + Esc** to open Task Manager
2. Go to **Processes**
3. Find:
   - **vmmemWSL** (WSL2 VM process)
4. Observe:
   - Memory
   - CPU
   - Disk

Interpretation:
- If **vmmemWSL memory** climbs near your available RAM and **swap is disabled**, Linux may **OOM-kill** processes (Node is a common victim).
- If **Disk** is extremely high during dev server startup, file watching/build output may be intense.

---

## 💾 2) Edit `.wslconfig` (enables swap)

File location:
- `C:\Users\<YOU>\.wslconfig`

Easy path:
1. Press **Windows key**
2. Type **Notepad** and open it
3. **File → Open**
4. Paste into the filename box:
   - `%UserProfile%\.wslconfig`
5. Set file type dropdown to **All Files** if it’s not visible

Recommended contents:
    [wsl2]
    processors=6
    swap=8GB

Important:
- Changes apply only after a WSL VM restart:
  - `wsl --shutdown`

---

## 🔄 3) Restart WSL (no reboot needed)

1. Open **PowerShell**
2. Run:
   - `wsl --shutdown`

Then start Ubuntu again from:
- **Windows Terminal** (Ubuntu profile), or
- **Start menu → Ubuntu**

---

## ✅ 4) Confirm swap inside Ubuntu

Inside Ubuntu:
1. Run:
   - `free -h`
2. Run:
   - `swapon --show`

Expected:
- Swap is **non-zero** (not `0B`)

---

## 🧩 5) If VS Code Remote-WSL is stuck

In VS Code:
1. **View → Command Palette…**
2. Run:
   - `WSL: Open Log`

Also useful:
- `Developer: Show Running Extensions`
- `Developer: Toggle Developer Tools` (Console tab)

If WSL responds but VS Code cannot connect:
- 🧹 Reset VS Code Server inside Ubuntu:
  - `bash ./scripts/ubuntu-reset-vscode-server.sh`
