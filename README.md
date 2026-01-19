# VS Code Remote-WSL Stability Guide

Fixes for VS Code Remote-WSL disconnects like:
- “WSL distro not found”
- Wsl/Service/0x8007274c
- WebSocket close 1006

Common cause covered here: WSL2 runs out of memory (OOM) when swap is disabled, then VS Code Remote-WSL loses connection.

## Quick confirm

PowerShell (Windows):

    wsl -l -v
    wsl -d Ubuntu -e bash -lc "date; uptime; free -h | head -n 5"

Ubuntu (WSL):

    dmesg -T | egrep -i 'out of memory|oom-kill|killed process' | tail -n 30

## Fix: enable swap via .wslconfig

Create/edit: %UserProfile%\.wslconfig

    [wsl2]
    processors=6
    swap=8GB
    ; omit swapFile (use default managed swap.vhdx)

Restart WSL (PowerShell):

    wsl --shutdown

Verify in Ubuntu:

    free -h
    swapon --show

## Scripts

See scripts/ for copy/pasteable PowerShell scripts.
