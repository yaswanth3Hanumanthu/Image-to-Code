#!/bin/bash

# Universal setup script for Image-to-Code
# Works on: Codespaces, local development, Docker, and other cloud platforms

echo "🚀 Setting up Image-to-Code for universal deployment..."

# Function to detect environment
detect_environment() {
    if [ -n "$CODESPACE_NAME" ]; then
        echo "codespaces"
    elif [ -n "$DOCKER_CONTAINER" ] || [ -f /.dockerenv ]; then
        echo "docker"
    elif [ -n "$RAILWAY_ENVIRONMENT" ]; then
        echo "railway"
    elif [ -n "$VERCEL" ]; then
        echo "vercel"
    else
        echo "local"
    fi
}

# Function to get backend URLs based on environment
get_backend_urls() {
    local env=$(detect_environment)
    local backend_port=${BACKEND_PORT:-7001}
    
    case $env in
        "codespaces")
            if [ -n "$CODESPACE_NAME" ]; then
                echo "https://$CODESPACE_NAME-$backend_port.app.github.dev|wss://$CODESPACE_NAME-$backend_port.app.github.dev"
            else
                echo "http://localhost:$backend_port|ws://localhost:$backend_port"
            fi
            ;;
        "docker")
            echo "http://localhost:$backend_port|ws://localhost:$backend_port"
            ;;
        "railway"|"vercel")
            # For cloud platforms, use relative URLs or environment-specific URLs
            echo "http://localhost:$backend_port|ws://localhost:$backend_port"
            ;;
        *)
            echo "http://localhost:$backend_port|ws://localhost:$backend_port"
            ;;
    esac
}

# Create frontend environment file
FRONTEND_ENV="/workspaces/Image-to-Code/frontend/.env.local"
BACKEND_URLS=$(get_backend_urls)
HTTP_URL=$(echo $BACKEND_URLS | cut -d'|' -f1)
WS_URL=$(echo $BACKEND_URLS | cut -d'|' -f2)

echo "📝 Creating universal frontend environment configuration..."
cat > "$FRONTEND_ENV" << EOF
# Universal environment configuration
# Works on Codespaces, local development, Docker, and cloud platforms
# Generated on: $(date)
# Environment: $(detect_environment)

VITE_WS_BACKEND_URL=$WS_URL
VITE_HTTP_BACKEND_URL=$HTTP_URL

# Optional: Set to true for production deployments
# VITE_IS_DEPLOYED=false
EOF

# Create backend environment file if it doesn't exist
BACKEND_ENV="/workspaces/Image-to-Code/.env"
if [ ! -f "$BACKEND_ENV" ]; then
    echo "📝 Creating backend environment configuration..."
    cat > "$BACKEND_ENV" << EOF
# Backend environment configuration
# Add your API keys here

# Required: At least one AI provider API key
# OPENAI_API_KEY=your_openai_key_here
# ANTHROPIC_API_KEY=your_anthropic_key_here


# Optional: Screenshot service


# Optional: Image generation
# REPLICATE_API_KEY=your_replicate_key_here

# Optional: Custom backend port
# BACKEND_PORT=7001

# Optional: Development flags
# MOCK=false
# IS_DEBUG_ENABLED=false
EOF
fi

# Make ports public in Codespaces
if [ "$(detect_environment)" = "codespaces" ]; then
    echo "🔧 Configuring Codespaces ports..."
    gh codespace ports visibility 7001:public 5173:public 2>/dev/null || echo "Note: Could not set port visibility (you may need to do this manually)"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "🌍 Environment: $(detect_environment)"
echo "📡 Backend URL: $HTTP_URL"
echo "🔌 WebSocket URL: $WS_URL"
echo ""

case $(detect_environment) in
    "codespaces")
        echo "🚀 To start development in Codespaces:"
        echo "   docker-compose up"
        echo ""
        echo "📱 Access your app:"
        echo "   Frontend: https://$CODESPACE_NAME-5173.app.github.dev"
        echo "   Backend: $HTTP_URL"
        ;;
    "local")
        echo "🚀 To start development locally:"
        echo "   docker-compose up"
        echo ""
        echo "📱 Access your app:"
        echo "   Frontend: http://localhost:5173"
        echo "   Backend: http://localhost:7001"
        ;;
    *)
        echo "🚀 To start development:"
        echo "   docker-compose up"
        echo ""
        echo "📱 Frontend will be available on port 5173"
        echo "📱 Backend will be available on port 7001"
        ;;
esac

echo ""
echo "📝 Configuration files created:"
echo "   - frontend/.env.local (Frontend environment)"
echo "   - .env (Backend environment)"
echo ""
echo "💡 Tip: This setup works universally across all platforms!"
