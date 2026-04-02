# stop_container.ps1
# Script to stop and remove the persistent MiKTeX build container.

$CONTAINER_NAME = "miktex-server"

Write-Host ">>> Stopping and removing $CONTAINER_NAME..." -ForegroundColor Yellow
docker rm -f $CONTAINER_NAME

if ($LASTEXITCODE -eq 0) {
    Write-Host ">>> Container stopped and removed successfully." -ForegroundColor Green
} else {
    Write-Host ">>> Container $CONTAINER_NAME is not running or already removed."
}
