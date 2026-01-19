wsl --shutdown
wsl -d Ubuntu -e bash -lc "free -h; swapon --show || true"
