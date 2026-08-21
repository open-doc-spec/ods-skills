# Open Document Spec skill bootstrap for Windows (PowerShell 5.1+)
# Installs `ods`, ensures ODS workspace service, runs doctor.
#
# Usage:
#   .\bootstrap.ps1                 # default: install -> check . -> ensure . -> doctor
#   .\bootstrap.ps1 install
#   .\bootstrap.ps1 update
#   .\bootstrap.ps1 ensure [path]
#   .\bootstrap.ps1 status [path]
#   .\bootstrap.ps1 doctor [path]
#   .\bootstrap.ps1 check [path]
#
# Env:
#   ODS_PREFIX                install dir (default: %LOCALAPPDATA%\Programs\ods)
#   ODS_VERSION               pin a release tag
#   GH_TOKEN                  required for private repos

[CmdletBinding()]
param(
    [string]$Command = "default",
    [string]$Path = "."
)
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SrcInstallScript = Join-Path $ScriptDir "install.ps1"

function Write-Step { Write-Host "==> $($args -join ' ')" }
function Write-Warn { Write-Warning $($args -join ' ') }
function Write-Fatal { Write-Error $($args -join ' '); exit 1 }

function Get-CliCommand {
    return (Get-Command ods -ErrorAction SilentlyContinue)
}

function Have-Cli {
    if (Get-CliCommand) { return $true }
    $prefix = $env:ODS_PREFIX
    if (-not $prefix) { $prefix = $env:ODC_PREFIX }
    if (-not $prefix) { $prefix = Join-Path $env:LOCALAPPDATA "Programs\ods" }
    return (Test-Path (Join-Path $prefix "ods.exe"))
}

function Get-CliPath {
    $cmd = Get-CliCommand
    if ($cmd) { return $cmd.Source }
    $prefix = $env:ODS_PREFIX
    if (-not $prefix) { $prefix = $env:ODC_PREFIX }
    if (-not $prefix) { $prefix = Join-Path $env:LOCALAPPDATA "Programs\ods" }
    $candidate = Join-Path $prefix "ods.exe"
    if (Test-Path $candidate) { return $candidate }
    return $null
}

function Get-CliVersion {
    $bin = Get-CliPath
    if ($bin) { return (& $bin --version 2>$null) }
    return "unknown"
}

function Invoke-Cli {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$CliArgs)
    $bin = Get-CliPath
    if (-not $bin) { Write-Fatal "ods not on PATH; run install first" }
    & $bin @CliArgs
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Invoke-Install {
    if (Test-Path $SrcInstallScript) {
        & $SrcInstallScript
    } else {
        irm https://raw.githubusercontent.com/open-doc-spec/ods/main/src/scripts/install.ps1 | iex
    }
}

function Find-WorkspaceRoot {
    param([string]$TargetDir)
    $dir = Resolve-Path $TargetDir -ErrorAction SilentlyContinue
    if (-not $dir) { return $null }
    $current = $dir.Path
    while ($current) {
        $tomlPath = Join-Path $current "ods.toml"
        if (Test-Path $tomlPath) {
            return $current
        }
        $parent = Split-Path $current -Parent
        if ($parent -eq $current) { break }
        $current = $parent
    }
    return $null
}

function Invoke-Default {
    Write-Step "Open Document Spec bootstrap (Windows)"
    if (-not (Have-Cli)) {
        Write-Step "Installing ods..."
        Invoke-Install
    } else {
        Write-Step "CLI present: $(Get-CliVersion)"
    }
    $ws = Find-WorkspaceRoot -TargetDir $Path
    if ($ws) {
        Write-Step "ODS workspace: $ws"
        Invoke-Cli setup $ws
        Invoke-Cli doctor $ws
    } else {
        Write-Step "No root ods.toml under $Path (ok — use 'ods init' to create)"
    }
    if (Have-Cli) {
        Write-Step "Running ods update..."
        Invoke-Cli update
    }
    Write-Host ""
    Write-Host "Open Document Spec is installed."
    Write-Host "  $(Get-CliVersion)"
    Write-Host "  ods lint .     # ODS"
    Write-Host "  ods lint --okf .     # OKF"
}

switch ($Command.ToLower()) {
    "install" { Invoke-Install; Write-Host (Get-CliVersion) }
    "update" {
        if (Have-Cli) { Invoke-Cli update }
        else { Invoke-Install }
        $ws = Find-WorkspaceRoot -TargetDir $Path
        if ($ws) {
            Write-Step "Running workspace setup check (ods setup)..."
            Invoke-Cli setup $ws
        }
    }
    "ensure" {
        $ws = Find-WorkspaceRoot -TargetDir $Path
        if (-not $ws) { $ws = (Resolve-Path $Path).Path }
        Invoke-Cli setup $ws
        Invoke-Cli start $ws
    }
    "status" {
        $ws = Find-WorkspaceRoot -TargetDir $Path
        if (-not $ws) { $ws = (Resolve-Path $Path).Path }
        Invoke-Cli start --status $ws
    }
    "doctor" {
        $ws = Find-WorkspaceRoot -TargetDir $Path
        if (-not $ws) { $ws = (Resolve-Path $Path).Path }
        Invoke-Cli doctor $ws
    }
    "check" {
        $ws = Find-WorkspaceRoot -TargetDir $Path
        if ($ws) {
            Write-Host "ODS workspace: $ws"
            Invoke-Cli lint $ws
        } else {
            Write-Host "No ODS workspace at $Path (missing root ods.toml)"
            exit 1
        }
    }
    default { Invoke-Default }
}
