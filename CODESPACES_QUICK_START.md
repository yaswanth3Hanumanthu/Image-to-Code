# 🚀 Image-to-Code - Quick Start Guide

## 🔧 **Quick Setup (Recommended)**

After opening this project in Codespaces, run:

```bash
chmod +x scripts/*.sh
./scripts/start.sh
```

This will automatically:
- ✅ Configure the correct URLs for your Codespace
- ✅ Start Docker containers
- ✅ Attempt to make ports public
- ✅ Check service health

## 🔌 **Port Configuration (IMPORTANT)**

### The Port Visibility Issue
Codespaces ports are **private by default**, which means:
- ❌ Frontend can't connect to backend when accessed via external URLs
- ❌ WebSocket connections fail
- ❌ You see "Error generating code" messages

### ✅ **SOLUTION: Make Ports Public**

**Method 1: Automatic (Recommended)**
The `start.sh` script tries to do this automatically, but if it fails:

**Method 2: Manual Setup**
1. Look at the bottom of VS Code for the **"PORTS"** tab
2. Find these ports:
   - `5173` (Frontend)
   - `7001` (Backend API)
3. **Right-click** each port
4. Select **"Change Port Visibility"**
5. Choose **"Public"**
6. Refresh your browser

### 🎯 **Visual Guide**
```
PORTS Tab (bottom of VS Code):
┌─────────────────────────────────────────┐
│ Port | Running On | Visibility | Origin │
├─────────────────────────────────────────┤
│ 5173 | localhost  | Private ❌  │ User   │ ← Right-click → "Public"
│ 7001 | localhost  | Private ❌  │ User   │ ← Right-click → "Public"
└─────────────────────────────────────────┘
```

## 🌐 **Access URLs**

After making ports public, access your app at:
- **Frontend**: `https://YOUR_CODESPACE_NAME-5173.app.github.dev`
- **Backend**: `https://YOUR_CODESPACE_NAME-7001.app.github.dev`

## 🔑 **API Key Setup**

Add your API keys to `/workspaces/Image-to-Code/.env`:
```bash
GEMINI_API_KEY=your_actual_key_here
# OPENAI_API_KEY=your_openai_key_here
# ANTHROPIC_API_KEY=your_anthropic_key_here
```

## 🐛 **Troubleshooting**

### Problem: "Error generating code"
**Solution**: Make sure ports 5173 and 7001 are **public** (see above)

### Problem: Backend not responding
**Check**: 
```bash
curl http://localhost:7001/health
# Should return: {"status":"ok","message":"Backend is running"}
```

### Problem: Containers not running
**Restart**:
```bash
docker-compose down
docker-compose up --build -d
```

### Problem: Environment variables not updated
**Regenerate**:
```bash
./scripts/setup-codespaces.sh
docker-compose restart frontend
```

## 📋 **Manual Commands**

If scripts don't work, run manually:

```bash
# 1. Setup environment
./scripts/setup-codespaces.sh

# 2. Start containers
docker-compose up --build -d

# 3. Check status
docker-compose ps
docker-compose logs backend

# 4. Test backend
curl http://localhost:7001/health
```

## ⚡ **Features Configured**

- ✅ **Gemini Model Selection**: 4 variants (2.0 Flash, 1.5 Flash, 2.0 Flash, 1.5 Flash)
- ✅ **Health Check Endpoint**: `/health` for monitoring
- ✅ **Auto URL Detection**: Works in both Codespaces and local development
- ✅ **Smart Port Configuration**: Attempts automatic port forwarding
- ✅ **Environment Management**: Auto-generates correct environment files

## 📞 **Need Help?**

1. **Check the PORTS tab** - This solves 90% of connection issues
2. **Run the health check**: `curl http://localhost:7001/health`
3. **Check container logs**: `docker-compose logs backend`
4. **Restart everything**: `./scripts/start.sh`

---

**🎉 Once ports are public, your Image-to-Code app will work perfectly!**
