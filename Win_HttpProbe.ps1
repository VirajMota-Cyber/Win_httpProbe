[Console]::ForegroundColor = "White"
[Console]::BackgroundColor = "Black"

[System.String]$culture = (Get-Culture).Name
$PSVersion = $PSVersionTable.PSVersion.Major
[int]$systemRoleID = (Get-WmiObject -Class Win32_ComputerSystem).DomainRole

# Map system roles for better understanding
$systemRoles = @{
    0 = "Standalone Workstation"
    1 = "Member Workstation"
    2 = "Standalone Server"
    3 = "Member Server"
    4 = "Backup Domain Controller"
    5 = "Primary Domain Controller"
}
# Initialize audit function
function ports_scan {
    Clear-Host
    
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "       System Audit Live IP's Scan Initialization     " -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Cyan
   
    # Capture start time
    $start = Get-Date
    Write-Host "Port_Scan initiated by Viraj K Mota" -ForegroundColor White
    Write-Host "Starting PS at: $start" -ForegroundColor Yellow
    Write-Host "`n-------------------------------------`n"

    Write-Host "[?] Checking for System Info - Summary..`n" -ForegroundColor Black -BackgroundColor White

    # Collect and display system information
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    Write-Host "[!] OS Version: $($os.Caption) $($os.Version)" -ForegroundColor Green
    Write-Host "[!] System Role: $($systemRoles[$systemRoleID])" -ForegroundColor Green
    Write-Host "[!] Culture: $culture" -ForegroundColor Green
    Write-Host "[!] PowerShell Version: $PSVersion" -ForegroundColor Green
    Write-Host "`n-------------------------------------`n"
}
ports_scan
# Prompt the user to input target IPs or Hostnames
$target = Read-Host "Enter the IPs or Hostnames (comma-separated, e.g., 192.168.1.1, example.com)"
$targetList = $target -split ',' | ForEach-Object { $_.Trim() }

# Define the ports to check
#$ports = @(22, 80, 443, 445)
$port = Read-Host "Enter the port to scan (e.g., 80 or 443)"
$portList = $port -split ',' | ForEach-Object { $_.Trim() }

# Initialize an array to store results
$results = @()

# Function to test a target's port
function Test-Port {
    param (
        [string]$target,   # IP or Hostname
        [int]$port         # Port to test
    )

    try {
        # Test connection to the specified port
        $connection = Test-NetConnection -ComputerName $target -Port $port -WarningAction SilentlyContinue

        if ($connection.TcpTestSucceeded) {
            # If the port is open, add a success result
            Write-Host "Target: $target | Port: $port | Status: OPEN" -ForegroundColor Green
            return [PSCustomObject]@{
                Target = $target
                Port   = $port
                Status = "OPEN"
            }
        } else {
            # If the port is closed, add a failure result
            Write-Host "Target: $target | Port: $port | Status: CLOSED" -ForegroundColor Red
            return [PSCustomObject]@{
                Target = $target
                Port   = $port
                Status = "CLOSED"
            }
        }
    } catch {
        # Handle errors gracefully
        Write-Host "Error testing Target: $target | Port: $port" -ForegroundColor Yellow
        return [PSCustomObject]@{
            Target = $target
            Port   = $port
            Status = "ERROR"
        }
    }
}

# Scan each target and port
foreach ($target in $targetList) {
    foreach ($port in $portList) {
        $results += Test-Port -target $target -port $port
    }
}

$results 
# Output the results in a table
$csvPath = "PortScanResults-$((Get-Date).ToString('yyyyMMdd-HHmmss')).csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Host "Results saved to $csvPath" 