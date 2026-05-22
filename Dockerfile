FROM python:3.11-slim

# Install system tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes Agent AND the required server dependencies explicitly
# This fixes the "API Server: aiohttp not installed" error
RUN pip install --no-cache-dir hermes-agent aiohttp uvicorn

# Setup required directories
ENV HERMES_HOME=/opt/data
ENV PATH="/opt/data/.local/bin:${PATH}"
RUN mkdir -p /opt/data/.hermes
VOLUME [ "/opt/data" ]

WORKDIR /app

# NETWORK CONFIGURATION
# 1. Force the internal server to listen on 0.0.0.0 (not localhost)
ENV API_HOST=0.0.0.0
ENV API_SERVER_HOST=0.0.0.0
ENV HOST=0.0.0.0

# 2. Force the port to 10000 to match Render
ENV PORT=10000
ENV API_PORT=10000
ENV API_SERVER_PORT=10000

# 3. Allow external connections
ENV API_SERVER_ENABLED=true
ENV GATEWAY_ALLOW_ALL_USERS=true

EXPOSE 10000

# OFFICIAL ENTRYPOINT: Uses the CLI which handles the imports correctly
CMD ["hermes", "gateway", "run"]
