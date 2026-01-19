# Error guide (what the messages usually mean)

This repo is about one specific failure mode: VS Code Remote-WSL disconnects because the WSL VM gets unhealthy (most commonly memory pressure / OOM), which then breaks the VS Code “remote extension host” transport.

This page maps common errors → what they *typically* indicate → where to read the underlying docs.

---

## Wsl/Service/0x8007274c
**Typical message**
    A connection attempt failed because the connected party did not properly respond...
    Error code: Wsl/Service/0x8007274c

**What it usually means**
- `0x8007274C` maps to Winsock timeout `WSAETIMEDOUT (10060)`.
- In practice for Remote-WSL: Windows tried to talk to the WSL VM (vsock channel), but the VM didn’t respond in time (VM is stalled, overloaded, or mid-crash/restart).

**Docs**
- Winsock error codes (WSAETIMEDOUT 10060):
  https://learn.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2
- 0x8007274C → 10060 mapping example (Windows troubleshooting doc, same HRESULT):
  https://learn.microsoft.com/en-us/troubleshoot/windows-server/virtualization/troubleshoot-live-migration-issues

---

## WebSocket close with status code 1006
**Typical message**
    Failed to connect to the remote extension host server
    (Error: WebSocket close with status code 1006)

**What it usually means**
- `1006` is “abnormal closure” (no close frame). It’s not a meaningful “reason”, it’s a symptom: the connection died unexpectedly.
- In Remote-WSL context, this often appears when the VS Code remote side (VS Code Server / extension host) crashed or the WSL VM temporarily stopped responding.

**Docs**
- RFC 6455 (WebSocket) meaning of 1006:
  https://datatracker.ietf.org/doc/html/rfc6455
- MDN CloseEvent code list (1006 = Abnormal Closure):
  https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/code

---

## Out of memory: Killed process (node) / oom-kill
**Typical messages**
    oom-kill: ... task=node ...
    Out of memory: Killed process #### (node) ...
    Free swap  = 0kB
    Total swap = 0kB

**What it usually means**
- WSL ran out of memory and had no (or insufficient) swap, so the kernel killed a process (often Node / dev server).
- Once key processes die, VS Code Remote-WSL can lose its server/transport and then you see 1006 / “distro not found” / timeout loops.

**Docs**
- WSL advanced config (.wslconfig, including `swap`, `swapFile`, `memory`, `processors`):
  https://learn.microsoft.com/en-us/windows/wsl/wsl-config

---

## UtilAcceptVsock… accept4 failed 110 / “Waiting for abnormally long accept”
**Typical messages**
    WSL (...) ERROR: UtilAcceptVsock:... Waiting for abnormally long accept(...)
    WSL (...) ERROR: ... accept4 failed 110

**What it usually means**
- `110` is Linux `ETIMEDOUT` (“Connection timed out”).
- For Remote-WSL this usually correlates with the WSL VM being stalled/unresponsive while Windows is waiting for a vsock accept.

**Docs**
- Linux errno (ETIMEDOUT):
  https://man7.org/linux/man-pages/man3/errno.3.html

---

## systemd-journald: journal corrupted or uncleanly shut down / rotating
**Typical messages**
    File /var/log/journal/.../system.journal corrupted or uncleanly shut down, renaming and replacing.
    Time jumped backwards, rotating.

**What it usually means**
- WSL was terminated abruptly (crash/OOM/restart) so journald sees an unclean shutdown and rotates/repairs logs.
- This is usually a downstream symptom, not the root cause.

---

## EXT4-fs (sdX): unmounting/mounted filesystem… (WSL disk)
**Typical messages**
    EXT4-fs (sdc): unmounting filesystem ...
    EXT4-fs (sdc): mounted filesystem ... r/w ...

**What it usually means**
- WSL’s virtual disk was remounted, often because the VM restarted or the filesystem was reattached after instability.

---

## Helpful commands referenced in this repo (Linux man pages)
- `free -h` (memory summary)
- `swapon --show` (swap status)
- `/proc/swaps` (swap areas in use)
- `ps ... --sort=-%mem` (top memory processes)
- `dmesg -T` (kernel log timestamps)

Docs:
- swapon(8): https://man7.org/linux/man-pages/man8/swapon.8.html
- /proc/swaps (proc_swaps(5)): https://man7.org/linux/man-pages/man5/proc_swaps.5.html
- ps(1): https://man7.org/linux/man-pages/man1/ps.1.html
- dmesg(1): https://man7.org/linux/man-pages/man1/dmesg.1.html
