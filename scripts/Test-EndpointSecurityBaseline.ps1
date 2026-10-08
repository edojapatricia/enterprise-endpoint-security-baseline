#Requires -Version 5.1
<#
.SYNOPSIS
Read-only local Windows endpoint security baseline assessment.
.DESCRIPTION
Reports BitLocker, Defender and Firewall posture without recovery keys.
Local results do not establish Intune tenant compliance.
#>
[CmdletBinding()]
param(
    [string]$OutputPath
)
$ErrorActionPreference = 'Stop'
$checks = [System.Collections.Generic.List[object]]::new()
function Add-Check {
    param([string]$Control,[string]$Status,[string]$Detail)
    $checks.Add([pscustomobject]@{Control=$Control;Status=$Status;Detail=$Detail})
}
if (-not $IsWindows -and $PSVersionTable.PSEdition -eq 'Core') {
    throw 'This script requires Windows.'
}
try {
    $os = Get-CimInstance Win32_OperatingSystem
    Add-Check 'OperatingSystem' 'Info' ($os.Caption + ' ' + $os.Version)
} catch { Add-Check 'OperatingSystem' 'Unknown' 'Unable to query OS' }
try {
    $drive = $env:SystemDrive
    $volume = Get-BitLockerVolume -MountPoint $drive -ErrorAction Stop
    $encrypted = $volume.VolumeStatus -eq 'FullyEncrypted'
    $protected = $volume.ProtectionStatus -eq 'On'
    Add-Check 'BitLocker' $(if ($encrypted -and $protected) {'Pass'} else {'Fail'}) ("VolumeStatus={0};ProtectionStatus={1}" -f $volume.VolumeStatus,$volume.ProtectionStatus)
} catch { Add-Check 'BitLocker' 'Unknown' 'BitLocker status unavailable or insufficient permissions' }
try {
    $defender = Get-MpComputerStatus -ErrorAction Stop
    $healthy = $defender.AntivirusEnabled -and $defender.RealTimeProtectionEnabled
    Add-Check 'Defender' $(if ($healthy) {'Pass'} else {'Fail'}) ("AntivirusEnabled={0};RealTimeProtectionEnabled={1}" -f $defender.AntivirusEnabled,$defender.RealTimeProtectionEnabled)
} catch { Add-Check 'Defender' 'Unknown' 'Defender status unavailable' }
try {
    $profiles = @(Get-NetFirewallProfile -ErrorAction Stop)
    foreach ($profile in $profiles) {
        Add-Check ("Firewall-" + $profile.Name) $(if ($profile.Enabled) {'Pass'} else {'Fail'}) ("Enabled={0};Inbound={1}" -f $profile.Enabled,$profile.DefaultInboundAction)
    }
} catch { Add-Check 'Firewall' 'Unknown' 'Firewall profiles unavailable' }
$report = [pscustomobject]@{
    TimestampUtc = (Get-Date).ToUniversalTime().ToString('o')
    Hostname = $env:COMPUTERNAME
    Scope = 'Local verification only; not Intune compliance or recovery escrow verification'
    Checks = @($checks.ToArray())
}
$json = $report | ConvertTo-Json -Depth 5
if ($OutputPath) {
    $resolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
    [System.IO.File]::WriteAllText($resolved,$json,[System.Text.UTF8Encoding]::new($false))
}
$json
