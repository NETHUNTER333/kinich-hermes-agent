FROM python:3.11-slim

# Install system dependencies needed for scraping/parsing
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes Agent core via pip
RUN pip install --no-cache-dir hermes-agent

# Set data directory and home environment required by the Nous Research core
ENV HERMES_HOME=/opt/data
ENV PATH="/opt/data/.local/bin:${PATH}"
RUN mkdir -p /opt/data
VOLUME [ "/opt/data" ]

WORKDIR /app

# Force the container proxy to listen on Render's required internal network port
ENV PORT=10000
ENV API_SERVER_PORT=10000
ENV API_SERVER_ENABLED=true

EXPOSE 10000

# OFFICIAL COMMAND: Run the gateway server in foreground mode
CMD ["hermes", "gateway", "run"]
