$isoPath = "C:\Temp\SQLServer.iso"

# Check if the ISO exists
if (-not (Test-Path $isoPath)) {
    Write-Host "ISO file not found at $isoPath"
    exit 1
}

# Get the DiskImage object
$diskImage = Get-DiskImage -ImagePath $isoPath -ErrorAction Stop

# Mount it if not already mounted
if (-not $diskImage.Attached) {
    Mount-DiskImage -ImagePath $isoPath -ErrorAction Stop | Out-Null
    Start-Sleep -Seconds 2
}

# Get the mounted CD-ROM volumes
$volumes = Get-Volume | Where-Object {
    $_.DriveType -eq 'CD-ROM'
}

if ($volumes.Count -eq 0) {
    Write-Host "No mounted CD-ROM volumes found"
    exit 1
}

# Output only the drive letter for Ansible to capture
$volumes[0].DriveLetter