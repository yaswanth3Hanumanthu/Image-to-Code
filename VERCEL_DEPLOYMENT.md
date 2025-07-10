# 🚀 Complete Vercel Deployment Guide

## The Problem
Vercel can't easily host Python backends, so we'll deploy:
- **Frontend** → Vercel (free, fast)
- **Backend** → Railway (free tier, supports Python/Docker)

## Step 1: Deploy Backend to Railway

```bash
chmod +x scripts/deploy-backend-railway.sh
./scripts/deploy-backend-railway.sh
```

**What this does:**
1. Creates Railway account (if needed)
2. Deploys your Python backend
3. Gives you a backend URL like: `https://your-app-name.up.railway.app`

**Set these environment variables in Railway dashboard:**
- `OPENAI_API_KEY` (optional)
- `ANTHROPIC_API_KEY` (optional)

## Step 2: Update Frontend Configuration

1. Copy your Railway backend URL
2. Update frontend environment:

```bash
# Edit frontend/.env.production
VITE_WS_BACKEND_URL=wss://your-railway-url.up.railway.app
VITE_HTTP_BACKEND_URL=https://your-railway-url.up.railway.app
```

## Step 3: Deploy Frontend to Vercel

### Option A: Through Vercel Dashboard
1. Go to [vercel.com](https://vercel.com)
2. Click "Import Project"
3. Connect your GitHub repo
4. Set **Root Directory** to: `frontend`
5. Set **Build Command** to: `npm run vercel-build`
6. Set **Output Directory** to: `dist`
7. Deploy!

### Option B: Through CLI
```bash
cd frontend
npx vercel --prod
```

## Step 4: Test Your Deployment

1. Open your Vercel URL
2. Upload an image
3. Generate code with Gemini!

## Troubleshooting

### If Vercel build fails:
- Check that **Root Directory** is set to `frontend`
- Verify **Build Command** is `npm run vercel-build`
- Check **Output Directory** is `dist`

### If backend connection fails:
- Verify Railway backend is running
- Check environment variables in Railway
- Ensure frontend `.env.production` has correct URLs

### If API calls fail:
- Verify `GEMINI_API_KEY` is set in Railway
- Check Railway logs for errors
- Test backend health: `https://your-railway-url.up.railway.app/health`

## Your Final URLs:
- **Frontend**: `https://your-project.vercel.app`
- **Backend**: `https://your-app.up.railway.app`

## Cost:
- **Vercel**: Free (hobby plan)
- **Railway**: Free tier (500 hours/month)
- **Total**: $0/month for moderate usage
