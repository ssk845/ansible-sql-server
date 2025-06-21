$isoPath = "C:\Temp\SQLServer.iso"

if (Test-Path $isoPath) {
    $diskImage = Get-DiskImage -ImagePath $isoPath -ErrorAction SilentlyContinue
    if ($diskImage -and $diskImage.Attached) {
        Dismount-DiskImage -ImagePath $isoPath
        Write-Host "ISO successfully unmounted."
    } else {
        Write-Host "ISO not attached. Nothing to unmount."
    }
} else {
    Write-Host "ISO file not found at $isoPath"
}
