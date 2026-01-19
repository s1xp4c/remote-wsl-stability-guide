# 🧯 Error guide (what the messages usually mean)

Remote-WSL disconnects often happen when the **WSL VM becomes unhealthy**
(very commonly **memory pressure / OOM**), which breaks the VS Code remote extension host transport.

📚 Official references:
- docs/REFERENCES.md

---

## 🪟 `Wsl/Service/0x8007274c` (Windows-side timeout)

Typical message:
    A connection attempt failed because the connected party did not properly respond...
    Error code: Wsl/Service/0x8007274c

What it usually means:
- This maps to a Windows networking timeout path (Winsock timeout family).
- In practice: Windows tried to talk to the WSL VM, but the VM did not respond in time
  (stalled, overloaded, or mid-crash/restart).

What to do next:
- Run: `scripts/windows-wsl-health-snapshot.ps1`
- Check swap (`free -h`, `swapon --show`) and OOM lines (`dmesg -T | egrep ...`).
- If swap is 0B → enable swap and restart WSL.

Docs:
- Windows sockets error codes:
  https://learn.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2

---

## 🌐 WebSocket close code `1006` (abnormal closure)

Typical message:
    Failed to connect to the remote extension host server
    (Error: WebSocket close with status code 1006)

What it usually means:
- `1006` is “abnormal closure” (no close frame). It’s a symptom: the connection died unexpectedly.
- In Remote-WSL context: the remote side (VS Code Server / extension host) crashed or the WSL VM stopped responding.

What to do next:
- Check for OOM kills in WSL.
- If WSL is responsive but VS Code can’t connect → reset VS Code server:
  `bash ./scripts/ubuntu-reset-vscode-server.sh`

Docs:
- MDN CloseEvent code list:
  https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/code

---

## 🧠 OOM kills (Node/dev server dies, then VS Code drops)

Typical messages:
    Out of memory: Killed process #### (node) ...
    oom-kill: ... task=node ...
    Free swap  = 0kB
    Total swap = 0kB

What it usually means:
- WSL ran out of RAM and had no (or insufficient) swap, so the kernel killed a process (often Node).
- Once key processes die, VS Code Remote-WSL can lose its server/transport.

What to do next:
- Enable swap (see `scripts/windows-enable-wsl-swap.ps1`)
- Reduce dev-server parallelism / memory usage if needed

Docs:
- WSL advanced config (.wslconfig, including swap):
  https://learn.microsoft.com/en-us/windows/wsl/wsl-config

---

## 🔌 vsock accept timeouts (`accept4 failed 110` / “abnormally long accept”)

Typical messages:
    UtilAcceptVsock: Waiting for abnormally long accept(...)
    accept4 failed 110

What it usually means:
- Linux `110` = `ETIMEDOUT` (“Connection timed out”).
- Often correlates with the WSL VM being stalled/unresponsive while Windows waits for a vsock accept.

What to do next:
- Check for OOM + swap first.
- If it repeats: restart WSL (`wsl --shutdown`), then re-test.

Docs:
- Linux errno (ETIMEDOUT):
  https://man7.org/linux/man-pages/man3/errno.3.html

---

## 🗃️ journald corruption / “unclean shutdown” messages

Typical messages:
    systemd-journald: ... journal corrupted or uncleanly shut down ...
    Time jumped backwards, rotating.

What it usually means:
- WSL was terminated abruptly (crash/OOM/restart), so journald rotates/repairs logs.
- Usually a downstream symptom, not the root cause.

---

## 💽 EXT4 mount/unmount spam (WSL disk reattach)

Typical messages:
    EXT4-fs (sdX): unmounting filesystem ...
    EXT4-fs (sdX): mounted filesystem ... r/w ...

What it usually means:
- WSL’s virtual disk was remounted, often because the VM restarted or the filesystem was reattached after instability.

---

## 🧰 Commands used in this repo (why they’re safe)

- `free -h` (memory summary)
- `swapon --show` (swap status)
- `/proc/swaps` (swap areas in use)
- `ps ... --sort=-%mem` (top memory processes)
- `dmesg -T` (kernel logs with human timestamps)

Docs (man pages):
- https://man7.org/linux/man-pages/man1/free.1.html
- https://man7.org/linux/man-pages/man8/swapon.8.html
- https://man7.org/linux/man-pages/man5/proc_swaps.5.html
- https://man7.org/linux/man-pages/man1/ps.1.html
- https://man7.org/linux/man-pages/man1/dmesg.1.html
