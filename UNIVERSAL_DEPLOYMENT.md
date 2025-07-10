# 🌍 Universal Deployment Guide

Your Image-to-Code app now works universally across **all environments**:

## ✅ Supported Platforms

- **GitHub Codespaces** (Auto-detected)
- **Local Desktop/Laptop** (Windows, Mac, Linux)
- **Docker** (Any platform)
- **Gitpod** (Auto-detected)
- **Railway** (Cloud platform)
- **Vercel** (Frontend)
- **Any Cloud VPS**

## 🚀 Quick Start (Universal)

### 1. Clone and Setup
```bash
git clone <your-repo>
cd Image-to-Code

# Run universal setup (works everywhere!)
./scripts/universal-setup.sh
```

### 2. Start Development
```bash
# Works on all platforms
docker-compose up
```

### 3. Access Your App
The app will automatically detect your environment and provide the correct URLs.

## 🔧 How It Works

### **Smart Environment Detection**
The app automatically detects:
- **GitHub Codespaces**: Uses `*.app.github.dev` URLs
- **Gitpod**: Uses `*.gitpod.io` URLs  
- **Local**: Uses `localhost` URLs
- **Docker**: Container-aware networking
- **Others**: Fallback to localhost

### **Auto-Configuration**
```typescript
// Frontend automatically detects backend URLs
export const WS_BACKEND_URL = getBackendUrl('ws');   // Auto-detected
export const HTTP_BACKEND_URL = getBackendUrl('http'); // Auto-detected
```

### **Environment Files**
- **`.env`**: Backend configuration (API keys)
- **`frontend/.env.local`**: Frontend URLs (auto-generated)

## 🌐 Platform-Specific Instructions

### **GitHub Codespaces**
```bash
./scripts/universal-setup.sh  # Auto-detects Codespaces
docker-compose up
# Access: https://<codespace>-5173.app.github.dev
```

### **Local Development**
```bash
./scripts/universal-setup.sh  # Detects local environment
docker-compose up
# Access: http://localhost:5173
```

### **Docker (Any Platform)**
```bash
./scripts/universal-setup.sh
docker-compose up
# Access: http://localhost:5173
```

### **Cloud Platforms (Railway, Vercel, etc.)**
```bash
./scripts/universal-setup.sh  # Platform-aware
# Follow platform-specific deployment instructions
```

## 🔑 API Keys

Add your API keys to `.env`:
```env
# At least one AI provider required
GEMINI_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
ANTHROPIC_API_KEY=your_key_here

# Optional
SCREENSHOT_API_KEY=your_key_here
REPLICATE_API_KEY=your_key_here
```

## 🚨 Troubleshooting

### **Wrong URLs/Port Issues**
```bash
# Re-run setup to fix URLs
./scripts/universal-setup.sh
```

### **Codespaces Port Visibility**
```bash
# Make ports public manually if needed
gh codespace ports visibility 7001:public 5173:public
```

### **Local Connection Issues**
```bash
# Check Docker is running
docker ps

# Restart services
docker-compose down && docker-compose up
```

## 💡 Key Features

- ✅ **Zero Configuration**: Just run the setup script
- ✅ **Universal Compatibility**: Works everywhere
- ✅ **Auto-Detection**: Smart environment detection
- ✅ **Fallback URLs**: Always works, even if detection fails
- ✅ **Port Flexibility**: Configurable ports
- ✅ **Cloud Ready**: Production deployment ready

## 🎯 The Problem This Solves

**Before**: Environment-specific configurations that break when moving between:
- Codespaces ↔ Local development
- Different cloud platforms
- Docker containers
- Development ↔ Production

**After**: One setup that works everywhere, automatically! 🚀

---

*Your app is now truly universal and will work seamlessly across all development and deployment environments.*
