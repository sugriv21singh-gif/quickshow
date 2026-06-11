#!/bin/bash
# QuickShow Setup Script - Linux/Mac
# This script helps set up QuickShow for local development

echo "🎬 QuickShow Setup Script"
echo "=========================="
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 18+"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ required (you have v$NODE_VERSION)"
    exit 1
fi

echo "✅ Node.js $(node -v) detected"
echo "✅ npm $(npm -v) detected"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm run install-all

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"
echo ""

# Check environment files
echo "🔑 Checking environment files..."

if [ ! -f "client/.env.local" ]; then
    echo "⚠️  client/.env.local not found"
    echo "   Creating from example..."
    cp client/.env.example client/.env.local
    echo "   ✅ Created (please fill in your API keys)"
fi

if [ ! -f "server/.env" ]; then
    echo "⚠️  server/.env not found"
    echo "   Creating from example..."
    cp server/.env.example server/.env
    echo "   ✅ Created (please fill in your API keys)"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Edit client/.env.local and add your API keys"
echo "   2. Edit server/.env and add your API keys"
echo "   3. See CONFIGURATION.md for detailed setup"
echo ""
echo "🚀 To start development:"
echo "   npm run dev"
echo ""
echo "Visit: http://localhost:5173 (Frontend)"
echo "       http://localhost:3000 (Backend API)"
