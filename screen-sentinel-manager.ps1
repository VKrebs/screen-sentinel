param (
    [string]$Action,
    [string]$ExecutablePath = ".\ScreenSentinel.WindowsService\bin\Release\net8.0-windows\publish\ScreenSentinel.WindowsService.exe"
)

$ServiceName = "ScreenSentinel"

function Ensure-Admin {
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
    if (-not $currentPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "[ERROR] This script must be run as Administrator!" -ForegroundColor Red
        exit 1
    }
}

function Install-Service {

    Ensure-Admin

    if (-not ([System.IO.Path]::IsPathRooted($ExecutablePath)))
    {
        $WorkingDirectory = Get-Location
        $ExecutablePath = Join-Path -Path $WorkingDirectory -ChildPath $ExecutablePath
        $ExecutablePath = [System.IO.Path]::GetFullPath($ExecutablePath)
    }

    Write-Host "[SETUP] Resolved Service Path: $ExecutablePath" -ForegroundColor Cyan

    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Write-Host "[SETUP] Service '$ServiceName' is already installed. Stopping and removing..." -ForegroundColor Cyan
        try {
            Stop-Service -Name $ServiceName -Force
            sc.exe delete $ServiceName | Out-Null
            Write-Host "[OK] Service '$ServiceName' is stopped and removed." -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Failed to stop and remove service '$ServiceName': $_" -ForegroundColor Red
        }
    }

    if ([System.Diagnostics.EventLog]::SourceExists($ServiceName)) {
        Write-Host "[OK] Event Log Source '$ServiceName' already exists." -ForegroundColor Green
    } else {
        Write-Host "[SETUP] Creating Event Log Source '$ServiceName'..." -ForegroundColor Cyan
        
        try {
            New-EventLog -LogName $LogName -Source $ServiceName -Force
            Write-Host "[OK] Event Log Source '$ServiceName' created." -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Failed to create Event Log Source '$ServiceName': $_" -ForegroundColor Red 
            exit 1
        }
    }

    Write-Host "[SETUP] Installing service '$ServiceName'..." -ForegroundColor Cyan
    
    try {
        New-Service -Name "ScreenSentinel" -BinaryPathName "`"$ExecutablePath`"" -DisplayName "Screen Sentinel" -StartupType Automatic | Out-Null
    } catch {
        Write-Host "[ERROR] Failed to install service '$ServiceName': $_" -ForegroundColor Red
        exit 1
    }

    Start-Sleep -Seconds 2 
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Start-Service -Name $ServiceName
        Write-Host "[OK] Service '$ServiceName' installed and started." -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Service '$ServiceName' was not found after installation." -ForegroundColor Red
        exit 1
    }
}

function Uninstall-Service {
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Write-Host "Stopping and removing service '$ServiceName'..."
        Stop-Service -Name $ServiceName -Force
        sc.exe delete $ServiceName
        Write-Host "Service '$ServiceName' removed."
    } else {
        Write-Host "Service '$ServiceName' is not installed."
    }
}

function Restart-Service {
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Write-Host "Restarting service '$ServiceName'..."
        Stop-Service -Name $ServiceName -Force
        Start-Service -Name $ServiceName
        Write-Host "Service '$ServiceName' restarted."
    } else {
        Write-Host "Service '$ServiceName' is not installed."
    }
}

function Check-Service-Status {
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Get-Service -Name $ServiceName | Select-Object DisplayName, Status, StartType
    } else {
        Write-Host "Service '$ServiceName' is not installed."
    }
}

switch ($Action) {
    "install" { Install-Service }
    "uninstall" { Uninstall-Service }
    "restart" { Restart-Service }
    "status" { Check-Service-Status }
    default { Write-Host "Invalid action. Use 'install', 'uninstall', 'restart', or 'status'." }
}