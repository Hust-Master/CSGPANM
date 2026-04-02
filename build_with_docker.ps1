# build_with_docker.ps1
# Optimized script to build LaTeX using a persistent Docker container for speed.

$FILE_NAME = "IEEE-conference-template-062824.tex"
$IMAGE = "miktex/miktex:essential"
$CONTAINER_NAME = "miktex-server"
$VOL_DATA = "miktex-data"
$VOL_CACHE = "miktex-cache"

# Ensure volumes exist
Write-Host ">>> Ensuring persistent volumes..." -ForegroundColor Cyan
docker volume create $VOL_DATA | Out-Null
docker volume create $VOL_CACHE | Out-Null

# Check if the container is already running
$running = docker ps -q --filter "name=$CONTAINER_NAME"
if (-not $running) {
    Write-Host ">>> Starting persistent MiKTeX container ($CONTAINER_NAME)..." -ForegroundColor Cyan
    
    # Remove any existing container with the same name that might be stopped
    docker rm -f $CONTAINER_NAME 2>$null | Out-Null
    
    # Start container in background
    docker run -d --name $CONTAINER_NAME `
        -v "${VOL_DATA}:/var/lib/miktex" `
        -v "${VOL_CACHE}:/miktex/.miktex" `
        -v "${PSScriptRoot}:/workdir" `
        -w /workdir `
        -t $IMAGE tail -f /dev/null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "!!! Failed to start Docker container." -ForegroundColor Red
        exit 1
    }

    # Initialize MiKTeX (Check for updates to satisfy the administrator requirement)
    Write-Host ">>> Initializing MiKTeX inside container..." -ForegroundColor Yellow
    docker exec $CONTAINER_NAME mpm --admin --update-db
}

Write-Host ">>> Building $FILE_NAME inside running container..." -ForegroundColor Green
# Using -f in pdflatex if needed, but normally pdflatex is fine.
# Note: we use -synctex=1 and -interaction=nonstopmode for VS Code integration.
docker exec $CONTAINER_NAME pdflatex -synctex=1 -interaction=nonstopmode $FILE_NAME

if ($LASTEXITCODE -eq 0) {
    Write-Host ">>> Build successful!" -ForegroundColor Green
} else {
    Write-Host ">>> Build failed with exit code $LASTEXITCODE" -ForegroundColor Red
    Write-Host "Note: If this is the first run, it might still be downloading packages. Please wait and try again." -ForegroundColor Yellow
}
