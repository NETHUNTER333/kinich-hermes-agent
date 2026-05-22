FROM python:3.11-slim

# Install core system dependencies required for background utilities and scraping
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# CRITICAL FIX: Explicitly install the core along with its asynchronous API server extensions
RUN pip install --no-cache-dir "hermes-agent[all]" uvicorn aiohttp fastapi

# Initialize internal directory trees required by Nous Research configuration standards
ENV HERMES_HOME=/opt/data
ENV PATH="/opt/data/.local/bin:${PATH}"
RUN mkdir -p /opt/data/.hermes
VOLUME [ "/opt/data" ]

WORKDIR /app

# RENDER BINDING PARAMETERS: Map global routing proxies to container environments
ENV PORT=10000
ENV API_SERVER_PORT=10000
ENV API_SERVER_ENABLED=true
ENV GATEWAY_ALLOW_ALL_USERS=true

EXPOSE 10000

# BYPASS CLI CORES: Force direct web module initialization to expose port 10000 immediately
CMD ["python", "-m", "uvicorn", "hermes.gateway.platforms.api_server:web", "--host", "0.0.0.0", "--port", "10000"]
