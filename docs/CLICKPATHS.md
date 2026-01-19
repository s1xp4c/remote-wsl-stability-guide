# Windows click paths (so people feel safe)

These are “where do I click” equivalents of what the scripts do.

## 1) Check WSL memory usage (Task Manager)

1. Press Ctrl + Shift + Esc to open Task Manager
2. Go to the Processes tab
3. Find:
   - vmmemWSL (WSL2 VM process)
4. Observe:
   - Memory usage
   - CPU usage
   - Disk usage

Interpretation:
- If vmmemWSL memory climbs near your available RAM and swap is disabled, Linux may OOM-kill processes.
- If disk is extremely high during dev server startup, file watching/build output may be intense.

## 2) Edit .wslconfig (what enables swap)

The file is located at:
- C:\Users\<YOU>\.wslconfig

Easy way:
1. Press Windows key
2. Type: Notepad
3. Open Notepad
4. File -> Open
5. Paste this path in the filename box:
   - %UserProfile%\.wslconfig
6. Set file type to “All Files” if it’s not visible

Recommended contents:
    [wsl2]
    processors=6
    swap=8GB

Important:
- Changes apply only after WSL VM restart (wsl --shutdown)

## 3) Restart WSL (no reboot needed)

Fast restart:
1. Open PowerShell
2. Run:
   - wsl --shutdown

Then start Ubuntu again from:
- Windows Terminal (Ubuntu profile) OR
- Start menu: Ubuntu

## 4) Confirm swap inside Ubuntu

Inside Ubuntu:
1. Run:
   - free -h
2. Run:
   - swapon --show

Expected:
- Swap is non-zero

## 5) If VS Code Remote-WSL is stuck

In VS Code:
1. View -> Command Palette...
2. Type:
   - WSL: Open Log
3. Also useful:
   - Developer: Show Running Extensions
   - Developer: Toggle Developer Tools (Console tab)

If WSL responds but VS Code cannot connect:
- Try resetting the VS Code server install in Ubuntu:
  - scripts/ubuntu-reset-vscode-server.sh
