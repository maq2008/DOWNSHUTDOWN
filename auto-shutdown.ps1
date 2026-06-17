param(
    [string]$FileName,
    [string]$Path,
    [double]$ExpectedSize,
    [string]$SizeUnit
)

function Get-UserInput {
    if (-not $FileName) {
        Write-Host "Enter file name (or part of name): " -NoNewline -ForegroundColor Cyan
        $script:FileName = Read-Host
    }

    if (-not $Path) {
        Write-Host "Enter folder path to monitor: " -NoNewline -ForegroundColor Cyan
        $script:Path = Read-Host

        while (-not (Test-Path -LiteralPath $script:Path)) {
            Write-Host "Path not found! Enter valid folder path: " -NoNewline -ForegroundColor Red
            $script:Path = Read-Host
        }
    }

    if (-not $ExpectedSize) {
        Write-Host "Enter expected file size: " -NoNewline -ForegroundColor Cyan
        $script:ExpectedSize = [double](Read-Host)

        Write-Host "Enter size unit (KB, MB, GB): " -NoNewline -ForegroundColor Cyan
        $script:SizeUnit = (Read-Host).ToUpper()

        while ($script:SizeUnit -notin @("KB", "MB", "GB")) {
            Write-Host "Invalid! Enter KB, MB, or GB: " -NoNewline -ForegroundColor Red
            $script:SizeUnit = (Read-Host).ToUpper()
        }
    }
}

function Convert-ToBytes {
    param([double]$Size, [string]$Unit)

    switch ($Unit) {
        "KB" { return $Size * 1KB }
        "MB" { return $Size * 1MB }
        "GB" { return $Size * 1GB }
    }
}

Get-UserInput

$ExpectedSizeBytes = Convert-ToBytes -Size $ExpectedSize -Unit $SizeUnit
Write-Host ""
Write-Host "Monitoring: $Path" -ForegroundColor Cyan
Write-Host "Looking for: $FileName" -ForegroundColor Cyan
Write-Host "Expected size: $ExpectedSize $SizeUnit" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to cancel" -ForegroundColor Yellow
Write-Host ""

$found = $false

while ($true) {
    $files = Get-ChildItem -LiteralPath $Path -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$FileName*" }

    if ($files) {
        $file = $files | Select-Object -First 1
        $currentSizeBytes = $file.Length
        $currentSizeDisplay = switch ($SizeUnit) {
            "KB" { [math]::Round($currentSizeBytes / 1KB, 2) }
            "MB" { [math]::Round($currentSizeBytes / 1MB, 2) }
            "GB" { [math]::Round($currentSizeBytes / 1GB, 2) }
        }

        Write-Host "Found: $($file.Name)" -ForegroundColor Green
        Write-Host "Current: $currentSizeDisplay $SizeUnit / $ExpectedSize $SizeUnit" -ForegroundColor Green

        if ($currentSizeBytes -ge $ExpectedSizeBytes) {
            Write-Host "Checking if download is complete (verifying size stability)..." -ForegroundColor Yellow
            Start-Sleep -Seconds 5

            $file.Refresh()
            $newSize = $file.Length

            if ($newSize -eq $currentSizeBytes) {
                Write-Host "Download complete!" -ForegroundColor Green
                Write-Host "Shutting down in 30 seconds..." -ForegroundColor Red

                shutdown /s /t 30 /c "Download complete - Auto shutdown triggered"
                exit
            }
            else {
                Write-Host "File still changing ($newSize bytes), continuing to monitor..." -ForegroundColor Yellow
            }
        }
        else {
            $remaining = switch ($SizeUnit) {
                "KB" { [math]::Round(($ExpectedSizeBytes - $currentSizeBytes) / 1KB, 2) }
                "MB" { [math]::Round(($ExpectedSizeBytes - $currentSizeBytes) / 1MB, 2) }
                "GB" { [math]::Round(($ExpectedSizeBytes - $currentSizeBytes) / 1GB, 2) }
            }
            Write-Host "Downloading... $remaining $SizeUnit remaining" -ForegroundColor Yellow
        }
    }
    else {
        if (-not $found) {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') - Waiting for '$FileName'..." -ForegroundColor Gray
        }
        else {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') - File not found in folder..." -ForegroundColor Gray
        }
    }

    Start-Sleep -Seconds 3
}