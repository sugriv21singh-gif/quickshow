# QuickShow Setup Script - Windows PowerShell
# This script helps set up QuickShow for local development

Write-Host "🎬 QuickShow Setup Script" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
try {
    $nodeVersion = node -v
    Write-Host "✅ Node.js $nodeVersion detected" -ForegroundColor Green
}
catch {
    Write-Host "❌ Node.js not found. Please install Node.js 18+" -ForegroundColor Red
    exit 1
}

try {
    $npmVersion = npm -v
    Write-Host "✅ npm $npmVersion detected" -ForegroundColor Green
}
catch {
    Write-Host "❌ npm not found" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Install dependencies
Write-Host "📦 Installing dependencies..." -ForegroundColor Cyan

if (Test-Path "package.json") {
    npm run install-all
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "❌ package.json not found in current directory" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Dependencies installed" -ForegroundColor Green
Write-Host ""

# Check environment files
Write-Host "🔑 Checking environment files..." -ForegroundColor Cyan

if (-not (Test-Path "client/.env.local")) {
    Write-Host "⚠️  client/.env.local not found" -ForegroundColor Yellow
    Write-Host "   Creating from example..." -ForegroundColor Yellow
    Copy-Item "client/.env.example" "client/.env.local"
    Write-Host "   ✅ Created (please fill in your API keys)" -ForegroundColor Green
}
else {
    Write-Host "✅ client/.env.local exists" -ForegroundColor Green
}

if (-not (Test-Path "server/.env")) {
    Write-Host "⚠️  server/.env not found" -ForegroundColor Yellow
    Write-Host "   Creating from example..." -ForegroundColor Yellow
    Copy-Item "server/.env.example" "server/.env"
    Write-Host "   ✅ Created (please fill in your API keys)" -ForegroundColor Green
}
else {
    Write-Host "✅ server/.env exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Edit client/.env.local and add your API keys"
Write-Host "   2. Edit server/.env and add your API keys"
Write-Host "   3. See CONFIGURATION.md for detailed setup"
Write-Host ""
Write-Host "🚀 To start development:" -ForegroundColor Cyan
Write-Host "   npm run dev"
Write-Host ""
Write-Host "Visit: http://localhost:5173 (Frontend)" -ForegroundColor Cyan
Write-Host "       http://localhost:3000 (Backend API)" -ForegroundColor Cyan
