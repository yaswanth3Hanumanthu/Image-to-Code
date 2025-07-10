#!/bin/bash

# Complete startup script for Image-to-Code in GitHub Codespaces
# Run this after Codespaces restart to get everything working

set -e  # Exit on any error

echo "🚀 Starting Image-to-Code setup for Codespaces..."

# 1. Setup environment URLs
./scripts/setup-codespaces.sh

echo ""
echo "🐳 Setting up Docker containers..."

# 2. Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down --remove-orphans || true

# 3. Build and start containers
echo "🔨 Building and starting containers..."
docker-compose up --build -d

# 4. Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# 5. Function to check if we're in Codespaces
is_codespaces() {
    [ -n "$CODESPACE_NAME" ]
}

# 6. Attempt to make ports public automatically
if is_codespaces; then
    echo "🔓 Configuring port visibility for Codespaces..."
    
    # Try multiple methods to make ports public
    {
        echo "📡 Attempting automatic port configuration..."
        
        # Method 1: Use GitHub CLI if available
        if command -v gh &> /dev/null; then
            gh codespace ports visibility 5173:public 7001:public --codespace "$CODESPACE_NAME" 2>/dev/null && echo "✅ Ports configured via GitHub CLI" || echo "⚠️  GitHub CLI method failed"
        fi
        
        # Method 2: Try VS Code commands
        if command -v code &> /dev/null; then
            code --command workbench.action.remote.forwardPort --args '{"port": 5173, "label": "Frontend"}' 2>/dev/null || true
            code --command workbench.action.remote.forwardPort --args '{"port": 7001, "label": "Backend"}' 2>/dev/null || true
        fi
        
    } || echo "⚠️  Automatic port configuration failed - manual setup required"
fi

# 7. Check service status
echo "🔍 Checking service status..."

# Check backend
if curl -s "http://localhost:7001/health" > /dev/null 2>&1; then
    echo "✅ Backend is running"
else
    echo "⚠️  Backend might still be starting..."
fi

# Check frontend
if curl -s "http://localhost:5173" > /dev/null 2>&1; then
    echo "✅ Frontend is running"
else
    echo "⚠️  Frontend might still be starting..."
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📱 Access the app at:"
if is_codespaces; then
    echo "   🌐 Frontend: https://$CODESPACE_NAME-5173.app.github.dev"
    echo "   🔧 Backend:  https://$CODESPACE_NAME-7001.app.github.dev"
    echo ""
    echo "💡 IMPORTANT: If you get connection errors:"
    echo "   1. Go to the 'PORTS' tab in VS Code (bottom panel)"
    echo "   2. Find ports 5173 and 7001"
    echo "   3. Right-click each port → 'Change Port Visibility' → 'Public'"
    echo "   4. Refresh your browser"
else
    echo "   🌐 Frontend: http://localhost:5173"
    echo "   🔧 Backend:  http://localhost:7001"
fi
echo ""
echo "📝 To see logs:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 To stop:"
echo "   docker-compose down"
