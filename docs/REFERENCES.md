# References (official docs)

Also see:
- docs/ERRORS.md

This repo uses standard WSL + VS Code Remote-WSL commands. Links below explain the exact settings/commands.

## WSL configuration (.wslconfig)

- Advanced settings configuration in WSL (.wslconfig: processors, swap, swapFile, autoMemoryReclaim):
  https://learn.microsoft.com/en-us/windows/wsl/wsl-config

## WSL command-line (wsl.exe)

- Basic commands for WSL (wsl --status, wsl -l -v, wsl --shutdown, wsl -d <Distro> -e <cmd>):
  https://learn.microsoft.com/en-us/windows/wsl/basic-commands

## VS Code Remote - WSL

- Developing in WSL (Remote-WSL):
  https://code.visualstudio.com/docs/remote/wsl
- Remote troubleshooting (includes VS Code Server cleanup guidance):
  https://code.visualstudio.com/docs/remote/troubleshooting
- Remote development in WSL tutorial:
  https://code.visualstudio.com/docs/remote/wsl-tutorial

## File placement & performance (why /home on ext4 matters)

- VS Code performance note (store source code in WSL2 file system):
  https://code.visualstudio.com/docs/remote/troubleshooting#_improving-performance
- Microsoft dev environment overview (Linux file system hosts project files):
  https://learn.microsoft.com/en-us/linux/install

## Linux commands used by scripts (man pages)

- free(1):
  https://man7.org/linux/man-pages/man1/free.1.html
- dmesg(1):
  https://man7.org/linux/man-pages/man1/dmesg.1.html
- ps(1):
  https://man7.org/linux/man-pages/man1/ps.1.html
- swapon(8):
  https://man7.org/linux/man-pages/man8/swapon.8.html
- proc_swaps(5) (/proc/swaps):
  https://man7.org/linux/man-pages/man5/proc_swaps.5.html

## Error code references

- WebSocket close code 1006 meaning (MDN):
  https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/code
- Windows Sockets error codes (WSAGetLastError list):
  https://learn.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2
