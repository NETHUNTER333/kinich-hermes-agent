FROM python:3.11-slim

# Install system dependencies needed for scraping/parsing
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install specific Python tools with explicit extensions
RUN pip install --no-cache-dir "hermes-agent[all]" uvicorn aiohttp fastapi

# Initialize directory structures required by Nous Research core
ENV HERMES_HOME=/opt/data
ENV PATH="/opt/data/.local/bin:${PATH}"
RUN mkdir -p /opt/data/.hermes
VOLUME [ "/opt/data" ]

WORKDIR /app

# Force environment configurations for the internal API framework mapping
ENV PORT=10000
ENV API_SERVER_PORT=10000
ENV API_SERVER_ENABLED=true
ENV GATEWAY_ALLOW_ALL_USERS=true

EXPOSE 10000

# FIX: Import from 'hermes_agent' rather than 'hermes' to resolve ModuleNotFoundError
CMD ["python", "-m", "uvicorn", "hermes_agent.gateway.platforms.api_server:web", "--host", "0.0.0.0", "--port", "10000"]
