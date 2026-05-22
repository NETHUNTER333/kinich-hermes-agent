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

# Set work directory
WORKDIR /app

# Expose the API server port
EXPOSE 8642

# Enable the API server mode and define startup
ENV API_SERVER_ENABLED=true
ENV API_SERVER_PORT=8642

# Start Hermes in API server mode
CMD  hermes gateway  --dev
