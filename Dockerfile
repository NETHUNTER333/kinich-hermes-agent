FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git curl \
    && rm -rf /var/lib/apt/lists/*

# Install using uv (much more reliable for this package)
RUN pip install --no-cache-dir uv
RUN uv pip install --system "hermes-agent[web] @ git+https://github.com/NousResearch/hermes-agent.git"

# Hermes paths
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

# Stronger test
CMD ["sh", "-c", "python -c \"import hermes_agent; print('✅ hermes_agent imported successfully')\" && hermes gateway run"]
