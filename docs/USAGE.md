# Usage guide

This repo contains scripts for diagnosing and fixing a specific Remote-WSL failure mode:
WSL runs out of memory, kills dev processes (often Node), and VS Code Remote-WSL loses the remote extension host.

The scripts are intentionally simple. They do not “repair everything”; they help confirm or apply the known-good fix.

## Where to run scripts

1) PowerShell (Windows)
- Run files in scripts/ that end with .ps1
- These scripts call wsl.exe to query or restart the Ubuntu distro

Example:
    powershell -ExecutionPolicy Bypass -File .\scripts\windows-wsl-health-snapshot.ps1

2) Ubuntu (WSL)
- Run files in scripts/ that end with .sh
- Useful when VS Code is currently broken and you can still open Ubuntu/WSL from Windows Terminal or CMD/PowerShell

Example:
    bash ./scripts/ubuntu-fs-check.sh

## When to use what

### scripts/windows-wsl-ping.ps1
Use when:
- VS Code Remote-WSL is spinning/reconnecting
- You want to know if WSL is responding at all

What it does:
- Lists distros and asks Ubuntu for date, uptime, and free memory

Good signs:
- Commands return quickly
Bad signs:
- Timeouts (for example: Wsl/Service/0x8007274c)

### scripts/windows-wsl-oom-check.ps1
Use when:
- You suspect OOM kills (Node suddenly dies, dev server disappears)
- VS Code Remote-WSL disconnects after starting a dev server

What it does:
- Prints recent kernel log lines about Out Of Memory kills

If you see:
- “Out of memory: Killed process … (node)”
Then:
- Enable swap (see windows-enable-wsl-swap.ps1 and README)

### scripts/windows-enable-wsl-swap.ps1
Use when:
- Swap is 0B inside Ubuntu
- You see OOM kills in dmesg
- You want the known-good fix in a repeatable way

What it does:
- Backs up your existing %UserProfile%\.wslconfig
- Writes a safe .wslconfig with swap enabled (and omits swapFile)
- Runs wsl --shutdown
- Verifies swap from inside Ubuntu

Important:
- WSL only applies .wslconfig changes after the WSL VM restarts

### scripts/windows-wsl-health-snapshot.ps1
Use when:
- You want a single “all-in-one” diagnostic snapshot
- VS Code Remote-WSL is unstable and you want logs for an issue report

What it does:
- Prints WSL status and distro list
- Prints kernel, uptime, memory and swap from inside Ubuntu
- Shows top memory-using processes
- Shows recent OOM-related kernel log lines

Expected:
- If WSL is healthy, this returns quickly and shows non-zero swap (if configured)
- If WSL is unresponsive, you may see timeouts and should try a WSL restart and check for OOM

### scripts/windows-wsl-restart.ps1
Use when:
- You changed .wslconfig
- WSL or VS Code Remote feels “stuck”
- You want a quick restart and swap confirmation

What it does:
- wsl --shutdown
- checks free -h and swapon --show

### scripts/windows-vmmemwsl.ps1
Use when:
- You want to see how much memory the WSL VM is using from Windows
- You want a quick sanity check without opening Task Manager

What it does:
- Prints WorkingSetMB for vmmemWSL (and vmmem if present)

### scripts/ubuntu-fs-check.sh
Use when:
- You’re unsure whether your repo is inside WSL ext4 or under /mnt/c
- You want to confirm best-practice workspace placement

What it does:
- Prints current directory and filesystem type

Guidance:
- Prefer /home/... (ext4) for dev work, especially with file watchers

### scripts/ubuntu-reset-vscode-server.sh
Use when:
- WSL responds fine, but VS Code Remote-WSL cannot connect
- VS Code keeps reinstalling server or hangs on remote extension host

What it does:
- Deletes ~/.vscode-server and ~/.vscode-remote in Ubuntu

Why it helps:
- Forces VS Code to reinstall its server components on next connect

Note:
- This removes the remote server install only; it does not delete your project.
