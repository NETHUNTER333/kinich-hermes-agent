FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    git curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv + hermes-agent (this method works better)
RUN pip install --no-cache-dir uv
RUN uv pip install --system "hermes-agent[web] @ git+https://github.com/NousResearch/hermes-agent.git"

# Hermes setup
ENV HERMES_HOME=/opt/data
RUN mkdir -p /opt/data/.hermes
VOLUME ["/opt/data"]

WORKDIR /app

# Environment variables for gateway on Render
ENV API_HOST=0.0.0.0 \
    API_SERVER_HOST=0.0.0.0 \
    HOST=0.0.0.0 \
    PORT=10000 \
    API_PORT=10000 \
    API_SERVER_PORT=10000 \
    API_SERVER_ENABLED=true \
    GATEWAY_ALLOW_ALL_USERS=true

EXPOSE 10000

# Fixed CMD (single line for Render compatibility)
CMD sh -c "echo '=== Python path ===' && python -c 'import sys; print(sys.path)' && echo '=== Checking hermes_agent ===' && python -c 'import hermes_agent; print(\"✅ Success: hermes_agent imported\")' && echo '=== Starting Gateway ===' && hermes gateway run"
