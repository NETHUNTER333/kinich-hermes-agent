FROM python:3.11-slim

# Install system deps
RUN apt-get update && apt-get install -y \
    git curl nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN pip install --no-cache-dir uv

# Official recommended install method
RUN uv pip install --system ".[web]" git+https://github.com/NousResearch/hermes-agent.git

ENV HERMES_HOME=/opt/data
RUN mkdir -p /opt/data/.hermes
VOLUME ["/opt/data"]

WORKDIR /app

ENV API_HOST=0.0.0.0 \
    API_SERVER_HOST=0.0.0.0 \
    HOST=0.0.0.0 \
    PORT=10000 \
    API_PORT=10000 \
    API_SERVER_PORT=10000 \
    API_SERVER_ENABLED=true \
    GATEWAY_ALLOW_ALL_USERS=true

EXPOSE 10000

CMD ["hermes", "gateway", "run"]
