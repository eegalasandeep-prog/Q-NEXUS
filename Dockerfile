# ==============================================================================
# Q-NEXUS: MULTI-STAGE PRODUCTION DOCKERFILE
# Stage 1: Build React/Vite Frontend
# Stage 2: Unified Python 3.11 + FastAPI + Qiskit Runtime
# ==============================================================================

# STAGE 1: FRONTEND BUILD
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build

# STAGE 2: PRODUCTION RUNTIME
FROM python:3.11-slim AS production

WORKDIR /app

# Install minimal OS dependencies for numerical/scientific libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY backend/ ./backend/
COPY qnexus_quantum.py .
COPY main.py .
COPY preview.html .
COPY data/ ./data/

# Copy built frontend assets from Stage 1
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Default Environment Variables
ENV PORT=8000 \
    HOST=0.0.0.0 \
    PYTHONUNBUFFERED=1

EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:${PORT}/api/health || exit 1

# Start the unified Q-Nexus server (FastAPI serves both API and React SPA)
CMD ["python", "main.py"]
