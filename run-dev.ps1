# One-click PowerShell launcher for development
Set-Location -Path $PSScriptRoot
Write-Host "Installing server and client dependencies (if needed)..."
npm run install-all
Write-Host "Starting server and client..."
npm run dev
