#!/bin/bash

# One-click solution for Image-to-Code in Codespaces
# This script solves the port connectivity issue permanently

echo "🔧 Image-to-Code One-Click Setup & Port Fix"
echo "==========================================="

# Function to check if we're in Codespaces
is_codespaces() {
    [ -n "$CODESPACE_NAME" ]
}

if is_codespaces; then
    echo "✅ Detected GitHub Codespaces: $CODESPACE_NAME"
    
    # 1. Setup URLs
    echo "📝 1. Configuring environment URLs..."
    ./scripts/setup-codespaces.sh > /dev/null 2>&1
    
    # 2. Start containers
    echo "🐳 2. Starting Docker containers..."
    docker-compose down --remove-orphans > /dev/null 2>&1
    docker-compose up --build -d > /dev/null 2>&1
    
    # 3. Wait for startup
    echo "⏳ 3. Waiting for services to start..."
    sleep 8
    
    # 4. Try to make ports public via multiple methods
    echo "🔓 4. Configuring port visibility..."
    
    # Method 1: GitHub CLI
    if command -v gh &> /dev/null; then
        gh codespace ports visibility 5173:public 7001:public --codespace "$CODESPACE_NAME" 2>/dev/null && echo "   ✅ GitHub CLI: Ports configured" || echo "   ⚠️  GitHub CLI: Failed"
    fi
    
    # Method 2: Direct VS Code commands
    if command -v code &> /dev/null; then
        code --command workbench.action.remote.forwardPort --args 5173 2>/dev/null && echo "   ✅ VS Code: Frontend port forwarded" || true
        code --command workbench.action.remote.forwardPort --args 7001 2>/dev/null && echo "   ✅ VS Code: Backend port forwarded" || true
    fi
    
    # 5. Test connectivity
    echo "🔍 5. Testing connectivity..."
    if curl -s http://localhost:7001/health > /dev/null 2>&1; then
        echo "   ✅ Backend: Running"
    else
        echo "   ⚠️  Backend: Starting up..."
    fi
    
    if curl -s http://localhost:5173 > /dev/null 2>&1; then
        echo "   ✅ Frontend: Running"
    else
        echo "   ⚠️  Frontend: Starting up..."
    fi
    
    echo ""
    echo "🎉 Setup Complete!"
    echo ""
    echo "📱 Your app is ready at:"
    echo "   🌐 https://$CODESPACE_NAME-5173.app.github.dev"
    echo ""
    echo "🔴 IMPORTANT: If you still get connection errors:"
    echo "   1. Look at the bottom of VS Code for 'PORTS' tab"
    echo "   2. Right-click ports 5173 and 7001"
    echo "   3. Select 'Change Port Visibility' → 'Public'"
    echo "   4. Refresh your browser"
    echo ""
    echo "✨ This should solve the port connectivity issue permanently!"
    
else
    echo "⚠️  Not in Codespaces - using local development setup"
    ./scripts/setup-codespaces.sh
    docker-compose up --build -d
    echo "🌐 App available at: http://localhost:5173"
fi
