# 🚀 Universal Setup Guide

This Image-to-Code project works on **any system** - Codespaces, local desktop, or cloud platforms.

## 📦 What's Included

✅ **Backend**: FastAPI with Gemini AI integration  
✅ **Frontend**: React + TypeScript + Vite  
✅ **Docker**: Multi-container setup  
✅ **Environment**: Smart environment detection  
✅ **APIs**: Screenshot capture & multi-LLM support  

## 🏃‍♂️ Quick Start (Any System)

### Option 1: Docker (Recommended)
```bash
# 1. Extract the zip file
unzip Image-to-Code-Universal.zip
cd Image-to-Code

# 2. Build and run
docker-compose up --build
```

### Option 2: Local Development
```bash
# 1. Extract and setup
unzip Image-to-Code-Universal.zip
cd Image-to-Code

# 2. Backend setup
cd backend
pip install poetry
poetry install
poetry run uvicorn main:app --host 0.0.0.0 --port 7001

# 3. Frontend setup (in new terminal)
cd frontend
yarn install
yarn dev
```

## 🌐 Access Your App

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:7001
- **Health Check**: http://localhost:7001/health

## 🔑 API Keys Setup

Add your API keys to `backend/.env`:

```env
# Required (at least one)
GEMINI_API_KEY=your_gemini_key_here
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here

# Optional
SCREENSHOT_API_KEY=your_screenshot_key_here
REPLICATE_API_KEY=your_replicate_key_here
```

## 🎯 Current Configuration

Your project comes pre-configured with:
- ✅ **Gemini API Key**: Ready to use
- ✅ **Screenshot API Key**: Ready to use
- ✅ **Universal Environment**: Works anywhere
- ✅ **Smart URL Detection**: Auto-detects Codespaces/localhost

## 🚀 Features

- **Multi-LLM Support**: Gemini, OpenAI, Claude
- **Real-time Streaming**: WebSocket-based AI responses
- **Screenshot Capture**: URL to image conversion
- **Multi-variant Generation**: 4 parallel AI outputs
- **Modern UI**: React + shadcn/ui components
- **Type Safety**: Full TypeScript support

## 🔧 Environment Detection

The app automatically detects:
- **GitHub Codespaces**: Uses Codespaces URLs
- **Local Development**: Uses localhost
- **Other Platforms**: Configurable URLs

## 📝 Notes

- **Docker**: Simplest setup, works everywhere
- **Node.js 18+**: Required for local development
- **Python 3.10+**: Required for backend
- **Ports**: Frontend (5173), Backend (7001)

Happy coding! 🎉
