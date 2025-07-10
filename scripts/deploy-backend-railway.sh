#!/bin/bash

echo "🚀 Deploying Backend to Railway..."

# Create backend deployment folder
mkdir -p backend-deploy
cp -r backend/* backend-deploy/

# Create Railway-specific files
cat > backend-deploy/railway.toml << EOF
[build]
  builder = "DOCKERFILE"
  dockerfilePath = "Dockerfile"

[deploy]
  restartPolicyType = "ON_FAILURE"
  restartPolicyMaxRetries = 10
EOF

cd backend-deploy

# Install Railway CLI if not installed
if ! command -v railway &> /dev/null; then
    echo "Installing Railway CLI..."
    curl -fsSL https://railway.app/install.sh | sh
fi

# Login and deploy
echo "🔐 Login to Railway..."
railway login

echo "📦 Creating Railway project..."
railway link --new

echo "🌐 Deploying backend..."
railway up

echo "✅ Backend deployment complete!"
echo ""
echo "🔧 Set these environment variables in Railway dashboard:"
echo "   - GEMINI_API_KEY=${GEMINI_API_KEY}"
echo "   - OPENAI_API_KEY (optional)"
echo "   - ANTHROPIC_API_KEY (optional)"
echo ""
echo "📝 Copy the Railway backend URL for frontend configuration"

cd ..
