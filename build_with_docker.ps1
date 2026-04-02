# build_with_docker.ps1
# Script to build IEEE-conference-template-062824.tex using Docker MiKTeX with dual volumes for persistence

$FILE_NAME = "IEEE-conference-template-062824.tex"
$IMAGE = "miktex/miktex:essential"
$VOL_DATA = "miktex-data"
$VOL_CACHE = "miktex-cache"

Write-Host ">>> Ensuring persistent volumes (if not exist)..." -ForegroundColor Cyan
docker volume create $VOL_DATA
docker volume create $VOL_CACHE

Write-Host ">>> Building $FILE_NAME using Docker MiKTeX..." -ForegroundColor Green
docker run --rm `
    -v "${VOL_DATA}:/var/lib/miktex" `
    -v "${VOL_CACHE}:/miktex/.miktex" `
    -v "${PSScriptRoot}:/workdir" `
    -w /workdir `
    $IMAGE pdflatex -synctex=1 -interaction=nonstopmode $FILE_NAME

if ($LASTEXITCODE -eq 0) {
    Write-Host ">>> Build successful!" -ForegroundColor Green
} else {
    Write-Host ">>> Build failed with exit code $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Note: If this is the first run, it might still be downloading packages. Please wait and try again." -ForegroundColor Yellow
}
