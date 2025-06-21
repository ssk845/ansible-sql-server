$found = $false
$versions = 16..11  # SQL Server 2022 to 2012

foreach ($v in $versions) {
    $namespace = "root\Microsoft\SqlServer\ComputerManagement$v"
    try {
        $tcp = Get-WmiObject -Namespace $namespace -Class ServerNetworkProtocol -ErrorAction Stop |
               Where-Object { $_.ProtocolName -eq "Tcp" }

        if ($tcp.IsEnabled -ne $true) {
            $tcp.SetEnable() | Out-Null
            Write-Host "TCP/IP protocol enabled via $namespace"
        } else {
            Write-Host "TCP/IP already enabled via $namespace"
        }

        $found = $true
        break
    } catch {
        # Try next version if this one fails
    }
}

if (-not $found) {
    Write-Host "Failed to find a working WMI namespace for SQL Server."
}
