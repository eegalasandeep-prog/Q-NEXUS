# 🚀 Q-NEXUS: Complete GitHub & Cloud Deployment Guide

Aligned with the **National Quantum Mission (NQM) of India**  
Theme: *Quantum-Assisted 5G/6G RF Optimization & Cellular Digital Twin*

---

## 📌 Quick Summary
The Q-NEXUS platform is fully unified:
- **Backend**: FastAPI + Qiskit 1.0+ QAOA Engine + Classical Greedy Baseline + SQLite + WebSockets
- **Frontend**: React + Vite + Tailwind CSS + Three.js 3D Digital Twin + Demo Project Module
- **Unified Engine**: FastAPI serves both the REST API, WebSockets, and the built React Single-Page Application (SPA) on a single port!

---

## Step 1: Push Your Code to GitHub

Open a terminal (PowerShell, Command Prompt, or Git Bash) in this project folder:

```bash
# 1. Initialize git repository
git init

# 2. Add all project files (node_modules and temporary files are automatically ignored)
git add .

# 3. Commit the cohesive codebase
git commit -m "feat: complete Q-NEXUS quantum-assisted 5G platform with demo module and cloud deployment"

# 4. Set the main branch
git branch -M main

# 5. Link your GitHub repository (replace with your repo URL)
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>.git

# 6. Push to GitHub
git push -u origin main
```

---

## Step 2: Deploy to the Cloud (Choose Your Preferred Method)

### 🥇 Option A: 1-Click Free Deployment on Render (Recommended)

Render connects directly to your GitHub repository and automatically deploys using the included `render.yaml` and `Dockerfile`.

1. Go to [https://render.com](https://render.com) and sign in with GitHub.
2. Click **New +** ➔ **Blueprint** (or **Web Service**).
3. Select your **Q-NEXUS** GitHub repository.
4. Render automatically detects `render.yaml` and the `Dockerfile`:
   - **Environment**: Docker
   - **Health Check Path**: `/api/health`
5. Click **Apply / Create Web Service**.
6. Render builds the React frontend and Python backend, and gives you a free live URL:  
   `https://q-nexus-xxxx.onrender.com`

> **Note**: Both the React UI, 3D Digital Twin, Swagger Docs (`/docs`), and API (`/api/health`) will run seamlessly on this single live URL!

---

### 🥈 Option B: Deploy on Railway

1. Go to [https://railway.app](https://railway.app) and log in with GitHub.
2. Click **New Project** ➔ **Deploy from GitHub repo**.
3. Select your **Q-NEXUS** repository.
4. Railway automatically detects the `Dockerfile` and builds both the React frontend and FastAPI backend.
5. In **Settings** ➔ **Networking**, click **Generate Domain** to get your public HTTPS URL.

---

### 🥉 Option C: 1-Command Local Docker Deployment

If you want to run or test the production container locally or on any Linux VPS:

```bash
# Build and run the entire unified production container
docker compose up --build
```
Open [http://localhost:8000](http://localhost:8000) to view the live platform!

---

### ⚡ Option D: Instant Live Demo via Cloudflare Tunnel or ngrok

Need a public link for judges right from your laptop in 30 seconds?

```bash
# Using Cloudflare Tunnel (no account required)
npx cloudflared tunnel --url http://localhost:8000
```
or with ngrok:
```bash
ngrok http 8000
```
This gives you an instant `https://xxxx.trycloudflare.com` URL to share with hackathon evaluators!

---

## 🛠️ Environment Variables (Optional)

| Variable | Description | Default |
|---|---|---|
| `PORT` | Web server listening port | `8000` |
| `HOST` | Bind host address | `0.0.0.0` |
| `GROQ_API_KEY` | Optional Groq LLM API key for AI explanations | Built-in fallback |
| `IBM_QUANTUM_TOKEN` | Optional IBM Quantum Cloud Token | Local AerSimulator |

---

## 🎯 Verification Checklist Once Deployed

- [ ] Open root URL: `https://your-app.com/` (React Single-Page Application)
- [ ] Open Demo Project: Click **✨ Demo Project** in the sidebar to run the 3-step cellular congestion scenario.
- [ ] Open API Docs: `https://your-app.com/docs` (Interactive Swagger UI)
- [ ] Check System Health: `https://your-app.com/api/health` (Returns `status: "ok"`)
- [ ] Open 3D Digital Twin: View 3D Three.js cell towers and beamforming lines.
