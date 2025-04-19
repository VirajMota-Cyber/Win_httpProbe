[System.String]$culture = (Get-Culture).Name 
$PSVersion = $PSVersionTable.PSVersion.Major 
[int]$systemRoleID = (Get-WmiObject -Class Win32_ComputerSystem).DomainRole


# Initialize audit function
function ports_scan {
    Clear-Host
    
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "       System Audit Live IP's Scan Initialization     " -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Cyan
   
    # Capture start time
    $start = Get-Date
    Write-Host "Port_Scan initiated" -ForegroundColor White
    Write-Host "Starting V_PS script at: $start" -ForegroundColor Yellow
    Write-Host "`n-------------------------------------`n"

    Write-Host "[?] Checking for System Info - Summary..`n" -ForegroundColor Black -BackgroundColor White

    # Collect and display system information
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    Write-Host "[!] OS Version: $($os.Caption) $($os.Version)" -ForegroundColor Green
    Write-Host "[!] Culture: $culture" -ForegroundColor Green
    Write-Host "[!] PowerShell Version: $PSVersion" -ForegroundColor Green
    Write-Host "`n-------------------------------------`n"
}
ports_scan

function Test-Port {
    param (
        [string]$target,
        [int]$port
    )

    try {
        $connection = Test-NetConnection -ComputerName $target -Port $port -WarningAction SilentlyContinue
        if ($connection.TcpTestSucceeded) {
            Write-Host "Target: $target | Port: $port | Status: OPEN" -ForegroundColor Green
            return @{ URL = "$target`:$port"; Status = "OPEN" }
        } else {
            Write-Host "Target: $target | Port: $port | Status: CLOSED" -ForegroundColor Red
            return @{ URL = "$target`:$port"; Status = "CLOSED" }
        }
    }
    catch {
        Write-Host "Error testing $target on port $port" -ForegroundColor Yellow
        return @{ URL = "$target`:$port"; Status = "ERROR" }
    }
}

# User input for targets and ports
$targetInput = Read-Host "Enter target(s) separated by comma (e.g., google.com,localhost)"
$portInput = Read-Host "Enter port(s) separated by comma (e.g., 80,443)"

$targets = $targetInput -split "," | ForEach-Object { $_.Trim() }
$ports = $portInput -split "," | ForEach-Object { [int]$_.Trim() }

# Run scans
$results = @()
foreach ($target in $targets) {
    foreach ($port in $ports) {
        $result = Test-Port -target $target -port $port
        $results += "$($result.URL),$($result.Status)"
    }
}

# Output to CSV
$header = "URL,Status"
$csvPath = "$PSScriptRoot\ScanResults.csv"
$csvData = $header + "`n" + ($results -join "`n")
$csvData | Out-File -FilePath $csvPath -Encoding UTF8

Write-Host "`nScan complete. Results saved to: $csvPath" -ForegroundColor Cyan
