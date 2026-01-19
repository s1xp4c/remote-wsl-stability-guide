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

## Decision tree (fast)

1) Does PowerShell `wsl -d Ubuntu -e bash -lc "uptime"` time out with `0x8007274c`?
   - Yes → WSL VM is not responding. Check memory pressure and OOM logs.
   - No → WSL responds; issue may be VS Code server/extension layer (open an issue with logs).

2) In Ubuntu, is swap zero?
   - Run: `free -h`
   - If Swap is `0B` → enable swap via `.wslconfig` and restart WSL.

3) Any OOM kills?
   - Run: `dmesg -T | egrep -i 'out of memory|oom-kill|killed process' | tail -n 30`
   - If you see OOM kills (often Node) → enable swap and/or reduce dev-server memory load.

4) Is your repo on `/mnt/c`?
   - Run: `df -T . | tail -n 1`
   - If it shows `9p`/`drvfs` → move the repo into `/home/...` (ext4) for better watcher performance.

## Extra troubleshooting scripts

PowerShell (Windows):
- scripts/windows-wsl-ping.ps1 : quick “is WSL responding?” check
- scripts/windows-wsl-oom-check.ps1 : show recent OOM kills from dmesg
- scripts/windows-vmmemwsl.ps1 : show vmmemWSL / vmmem working set in MB

Ubuntu (WSL):
- scripts/ubuntu-reset-vscode-server.sh : remove VS Code Server folders in WSL
- scripts/ubuntu-fs-check.sh : confirm workspace filesystem type (ext4 vs /mnt/c)

## More documentation

- docs/USAGE.md : when to use each script, what it does, and expected outcomes
- docs/CLICKPATHS.md : Windows click paths for the same actions (Task Manager, .wslconfig, restart)

## If VS Code is down (still troubleshoot safely)

If VS Code can’t connect to WSL right now, you can still run the Ubuntu scripts from a normal shell:
- Windows Terminal -> Ubuntu
- Or from PowerShell/CMD using: wsl -d Ubuntu -e bash -lc "<command>"

Examples (Ubuntu):
    bash ./scripts/ubuntu-fs-check.sh
    bash ./scripts/ubuntu-reset-vscode-server.sh

Note:
- PowerShell scripts (.ps1) are meant to run in Windows PowerShell.
- Bash scripts (.sh) are meant to run inside Ubuntu (WSL).

## References (official docs)

For the exact settings and commands used here, see:
- docs/REFERENCES.md

## Error explanations

See docs/ERRORS.md for what common messages mean (0x8007274c, WebSocket 1006, OOM kills, vsock timeouts).
