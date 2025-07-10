#!/bin/bash

# Smart setup script for Codespaces and local development
# This script automatically detects the environment and sets up URLs correctly

echo "� Setting up Image-to-Code environment..."

# Function to detect if we're in Codespaces
is_codespaces() {
    [ -n "$CODESPACE_NAME" ]
}

# Function to get current Codespace URL
get_codespace_url() {
    if is_codespaces; then
        echo "https://$CODESPACE_NAME-$1.app.github.dev"
    else
        echo "http://localhost:$1"
    fi
}

# Function to get WebSocket URL
get_ws_url() {
    if is_codespaces; then
        echo "wss://$CODESPACE_NAME-$1.app.github.dev"
    else
        echo "ws://localhost:$1"
    fi
}

# Create frontend environment file
FRONTEND_ENV="/workspaces/Image-to-Code/frontend/.env.local"
BACKEND_HTTP_URL=$(get_codespace_url 7001)
BACKEND_WS_URL=$(get_ws_url 7001)

echo "📝 Creating frontend environment configuration..."
cat > "$FRONTEND_ENV" << EOF
# Auto-generated environment configuration
# Generated on: $(date)
VITE_WS_BACKEND_URL=$BACKEND_WS_URL
VITE_HTTP_BACKEND_URL=$BACKEND_HTTP_URL
EOF

# Create backend environment file if it doesn't exist
BACKEND_ENV="/workspaces/Image-to-Code/.env"
if [ ! -f "$BACKEND_ENV" ]; then
    echo "📝 Creating backend environment configuration..."
    cat > "$BACKEND_ENV" << EOF
# Backend environment configuration
# Add your API keys here
GEMINI_API_KEY=your_gemini_api_key_here
# OPENAI_API_KEY=your_openai_api_key_here
# ANTHROPIC_API_KEY=your_anthropic_api_key_here
EOF
    echo "⚠️  Please add your API keys to $BACKEND_ENV"
fi

# Function to make ports public in Codespaces
make_ports_public() {
    if is_codespaces; then
        echo "🔓 Making ports public in Codespaces..."
        
        # Use GitHub CLI to make ports public if available
        if command -v gh &> /dev/null; then
            echo "📡 Using GitHub CLI to configure ports..."
            gh codespace ports visibility 5173:public 7001:public --codespace "$CODESPACE_NAME" 2>/dev/null || echo "⚠️  Manual port configuration may be needed"
        fi
        
        # Also try using the VS Code command if available
        if command -v code &> /dev/null; then
            echo "🔧 Attempting to configure VS Code port forwarding..."
            code --command workbench.action.remote.forwardPort --args '5173' 2>/dev/null || true
            code --command workbench.action.remote.forwardPort --args '7001' 2>/dev/null || true
        fi
    fi
}

# Make ports public
make_ports_public

# Display environment info
echo ""
echo "🌐 Environment Configuration:"
if is_codespaces; then
    echo "   📍 Environment: GitHub Codespaces"
    echo "   🎯 Codespace: $CODESPACE_NAME"
    echo "   🌐 Frontend URL: $(get_codespace_url 5173)"
    echo "   🔧 Backend URL: $BACKEND_HTTP_URL"
    echo "   🔌 WebSocket URL: $BACKEND_WS_URL"
    echo ""
    echo "💡 If you get connection errors:"
    echo "   1. Go to 'Ports' tab in VS Code"
    echo "   2. Right-click ports 5173 and 7001"
    echo "   3. Select 'Change Port Visibility' → 'Public'"
else
    echo "   📍 Environment: Local Development"
    echo "   🌐 Frontend URL: http://localhost:5173"
    echo "   🔧 Backend URL: http://localhost:7001"
    echo "   🔌 WebSocket URL: ws://localhost:7001"
fi

echo ""
echo "✅ Environment setup complete!"
echo "🚀 Run './scripts/start.sh' to start the application"
