$wslcfg = Join-Path $env:USERPROFILE ".wslconfig"

if (Test-Path $wslcfg) {
  $bak = "$wslcfg.bak-" + (Get-Date -Format "yyyyMMdd-HHmmss")
  Copy-Item $wslcfg $bak -Force
  Write-Host "Backed up existing .wslconfig to: $bak"
}

@"
[wsl2]
processors=6
swap=8GB
"@ | Set-Content -Path $wslcfg -Encoding ASCII

Write-Host "Wrote: $wslcfg"
Get-Content $wslcfg

wsl --shutdown

wsl -d Ubuntu -e bash -lc "echo '--- free -h ---'; free -h; echo; echo '--- swapon --show ---'; swapon --show || true"
