FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git curl \
    && rm -rf /var/lib/apt/lists/*

# Use uv for reliable installation (this often fixes import issues)
RUN pip install --no-cache-dir uv

# Force a clean install of the package + web extras
RUN uv pip install --system "hermes-agent[web] @ git+https://github.com/NousResearch/hermes-agent.git"

# Setup Hermes
ENV HERMES_HOME=/opt/data
RUN mkdir -p /opt/data/.hermes
VOLUME ["/opt/data"]

WORKDIR /app

# Render + Gateway settings
ENV API_HOST=0.0.0.0 \
    API_SERVER_HOST=0.0.0.0 \
    HOST=0.0.0.0 \
    PORT=10000 \
    API_PORT=10000 \
    API_SERVER_PORT=10000 \
    API_SERVER_ENABLED=true \
    GATEWAY_ALLOW_ALL_USERS=true

EXPOSE 10000

# Strong diagnostic CMD
CMD ["sh", "-c", "
    echo '=== Python path ===' && python -c 'import sys; print(sys.path)' && 
    echo '=== Checking hermes_agent ===' && 
    python -c 'import hermes_agent; print(\"✅ Success: hermes_agent version\", hermes_agent.__version__)' && 
    echo '=== Starting Gateway ===' && 
    hermes gateway run
"]
