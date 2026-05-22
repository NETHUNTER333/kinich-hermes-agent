FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install from Git (most reliable) + extras needed for gateway
RUN pip install --no-cache-dir \
    "git+https://github.com/NousResearch/hermes-agent.git#egg=hermes-agent[web]" \
    uvicorn \
    aiohttp

# Hermes environment
ENV HERMES_HOME=/opt/data
ENV PATH="/opt/data/.local/bin:${PATH}"
RUN mkdir -p /opt/data/.hermes

VOLUME ["/opt/data"]
WORKDIR /app

# Important Render + gateway settings
ENV API_HOST=0.0.0.0 \
    API_SERVER_HOST=0.0.0.0 \
    HOST=0.0.0.0 \
    PORT=10000 \
    API_PORT=10000 \
    API_SERVER_PORT=10000 \
    API_SERVER_ENABLED=true \
    GATEWAY_ALLOW_ALL_USERS=true

EXPOSE 10000

# Test import before running
CMD ["sh", "-c", "python -c 'import hermes_agent; print(\"hermes_agent imported OK\")' && hermes gateway run"]
