$RootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$Python = Join-Path $RootDir ".venv\Scripts\python.exe"

if (-not (Test-Path -LiteralPath $Python -PathType Leaf)) {
    Write-Error "Ambiente virtual .venv não encontrado. Crie-o com: py -m venv .venv"
    exit 1
}

& $Python (Join-Path $RootDir "main.py") setup
exit $LASTEXITCODE
