param(
    [string]$OutputDir = "dist",
    [switch]$NoZip
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $Root

$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

$VenvPython = Join-Path $Root ".venv_paddle\Scripts\python.exe"
if (-not (Test-Path $VenvPython)) {
    throw "Missing .venv_paddle. Run 首次安装环境.cmd first."
}

Write-Host "Checking portable CPU environment..."
& $VenvPython -c "import ultralytics, paddleocr, paddlex, cv2, PIL, numpy; print('portable imports ok')"
if ($LASTEXITCODE -ne 0) {
    throw "The local .venv_paddle is incomplete. Run 首次安装环境.cmd again, then rerun this script."
}

$Weight = Join-Path $Root "models\weights\yolo-captcha-detector.pt"
if (-not (Test-Path $Weight)) {
    throw "Missing model weight: $Weight"
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutRoot = Join-Path $Root $OutputDir
$PackageName = "glm-coding-helper-portable-cpu-$Stamp"
$PackageDir = Join-Path $OutRoot $PackageName

if (Test-Path $PackageDir) {
    Remove-Item -LiteralPath $PackageDir -Recurse -Force
}
New-Item -ItemType Directory -Path $PackageDir | Out-Null

$Include = @(
    "glm-coding-helper.user.js",
    "scripts\userscripts\glm-coding-captcha-direct.user.js",
    "start-backend.cmd",
    "install-env.cmd",
    "one-click-start.cmd",
    "启动后端.cmd",
    "首次安装环境.cmd",
    "README.md",
    "CHANGELOG.md",
    "LICENSE",
    "requirements-backend-cpu.txt",
    "scripts",
    "models",
    ".venv_paddle",
    ".paddlex_cache_cpu",
    ".paddle_home"
)

foreach ($Item in $Include) {
    $Src = Join-Path $Root $Item
    if (-not (Test-Path $Src)) { continue }
    $Dst = Join-Path $PackageDir $Item
    Write-Host "Copying $Item"
    if ((Get-Item $Src).PSIsContainer) {
        robocopy $Src $Dst /E /XD __pycache__ /XF *.pyc *.pyo /NFL /NDL /NJH /NJS /NP | Out-Null
        if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $Item with exit code $LASTEXITCODE" }
    } else {
        $DstParent = Split-Path -Parent $Dst
        if ($DstParent) { New-Item -ItemType Directory -Path $DstParent -Force | Out-Null }
        Copy-Item -LiteralPath $Src -Destination $Dst -Force
    }
}

New-Item -ItemType Directory -Path (Join-Path $PackageDir "dataset") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $PackageDir "logs") -Force | Out-Null

$Guide = @"
GLM Coding Helper portable CPU package

1. Install or update Tampermonkey script from glm-coding-helper.user.js.
2. Double-click start-backend.cmd or 启动后端.cmd.
3. Open https://www.bigmodel.cn/glm-coding?ic=9GXWL9KCGZ.

This package includes the CPU Python environment and local model files.
"@
Set-Content -LiteralPath (Join-Path $PackageDir "PORTABLE_README.txt") -Value $Guide -Encoding UTF8

$Size = (Get-ChildItem $PackageDir -Recurse -Force -File | Measure-Object Length -Sum).Sum
Write-Host ("Portable folder ready: {0}" -f $PackageDir)
Write-Host ("Uncompressed size: {0:N1} MB" -f ($Size / 1MB))

if (-not $NoZip) {
    $ZipPath = Join-Path $OutRoot "$PackageName.zip"
    if (Test-Path $ZipPath) { Remove-Item -LiteralPath $ZipPath -Force }
    Write-Host "Creating zip: $ZipPath"
    $SevenZip = Get-Command 7z -ErrorAction SilentlyContinue
    $SevenZipA = Get-Command 7za -ErrorAction SilentlyContinue
    if ($SevenZip) {
        & $SevenZip.Source a -tzip $ZipPath $PackageDir | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "7z failed with exit code $LASTEXITCODE" }
    } elseif ($SevenZipA) {
        & $SevenZipA.Source a -tzip $ZipPath $PackageDir | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "7za failed with exit code $LASTEXITCODE" }
    } else {
        Push-Location $OutRoot
        try {
            tar -a -cf "$PackageName.zip" $PackageName
            if ($LASTEXITCODE -ne 0) { throw "tar zip failed with exit code $LASTEXITCODE" }
        } finally {
            Pop-Location
        }
    }
    $ZipSize = (Get-Item $ZipPath).Length
    Write-Host ("Zip size: {0:N1} MB" -f ($ZipSize / 1MB))
}
