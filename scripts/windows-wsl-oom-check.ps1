wsl -d Ubuntu -e bash -lc "dmesg -T | egrep -i 'out of memory|oom-kill|killed process' | tail -n 50 || true"
