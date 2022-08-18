function Cmd([string] $What, [scriptblock] $Action) {
  $LASTEXITCODE = 0

  Write-Host "--- $What ---" -ForegroundColor Green
  & $Action

  if ($LASTEXITCODE -ne 0) {
    throw "$What failed with exit code $LASTEXITCODE."
  }
}

<# Delete a file or directory and all its conents #>
function Remove-Dir([string] $Path) {
  if (Test-Path $Path) {
    Remove-Item $Path -Force -Recurse
  }
}

# Variables
$root = $PSScriptRoot
$srcPath = "$root\src"
$buildPath = "$srcPath\build"
$distPath = "$root\dist"
$skiaPath = "$root\deps\skia"

<# Create distribution archive #>
function CreateArchive([string] $ArchiveName, [string] $Path) {
  Push-Location $Path
  try {
    $archivePath = "$distPath\$ArchiveName.7z"

    # Compress archive
    Cmd "Compressing archive" { 7z a -mx9 $archivePath * }

    # Generate checksum for archive
    $checksum = (Get-FileHash -Path $archivePath -Algorithm SHA256).Hash.ToString()
    Set-Content -Path "$archivePath.sha256.txt" -Encoding utf8NoBOM -Value $checksum -NoNewline
  } finally {
    Pop-Location
  }
}

try {
  if (-not (Test-Path "$srcPath\CMakeLists.txt")) {
    throw "No Aseprite source found."
  }

  if (-not (Test-Path $skiaPath)) {
    throw "Skia dependency not found."
  }

  $vsDevCmdPath = (Get-ChildItem "C:\Program Files\Microsoft Visual Studio\2022\*\Common7\Tools\VsDevCmd.bat").FullName
  if (-not $vsDevCmdPath -or -not (Test-Path $vsDevCmdPath)) {
    throw "No Visual Studio developer prompt found."
  }

  # Delete old output directories
  Cmd "Clean" {
    Remove-Dir $buildPath
    Remove-Dir $distPath
  }

  # Create output directories
  New-Item $buildPath -ItemType Directory -Force
  New-Item $distPath -ItemType Directory -Force

  # Set current working directory to build path
  Push-Location $buildPath
  try {
    # Build Aseprite
    Cmd "Build Aseprite" {
      $env:SKIA_DIR = $skiaPath
      $env:VSDEVCMD_PATH = $vsDevCmdPath

      & "$root\scripts\build-aseprite.cmd"
    }
  } finally {
    Pop-Location
  }

  # Create archive
  CreateArchive "aseprite" "$buildPath\bin"
}
catch {
  Write-Host $_.Exception.Message -ForegroundColor Red
}
