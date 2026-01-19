Get-Process -Name vmmemWSL -ErrorAction SilentlyContinue |
  Select-Object Name,Id,CPU,@{n="WorkingSetMB";e={[math]::Round($_.WorkingSet64/1MB,0)}}

Get-Process -Name vmmem -ErrorAction SilentlyContinue |
  Select-Object Name,Id,CPU,@{n="WorkingSetMB";e={[math]::Round($_.WorkingSet64/1MB,0)}}
