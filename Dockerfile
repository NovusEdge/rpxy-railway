FROM jqtype/rpxy:latest

# Install envsubst for environment variable substitution
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Create directory for configuration
RUN mkdir -p /etc/rpxy

# Copy configuration template
COPY rpxy.toml /etc/rpxy/rpxy.toml.template

# Debug: Check what binaries are available
RUN find /usr -name "*rpxy*" 2>/dev/null || true
RUN which rpxy || echo "rpxy not in PATH"
RUN ls -la /usr/local/bin/ || true

# Create startup script that processes environment variables
RUN echo '#!/bin/sh' > /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Processing rpxy configuration with environment variables..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'envsubst < /etc/rpxy/rpxy.toml.template > /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Generated config:"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'cat /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Looking for rpxy binary..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'find /usr -name "*rpxy*" 2>/dev/null || echo "No rpxy found in /usr"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'which rpxy || echo "rpxy not in PATH"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Starting rpxy reverse proxy..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'exec rpxy --config /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    chmod +x /usr/local/bin/start-rpxy.sh

# Expose port (will be overridden by Railway's PORT env var)
EXPOSE 8080

# Health check removed - Railway handles health checking

# Start rpxy with processed configuration
CMD ["/usr/local/bin/start-rpxy.sh"]