FROM jqtype/rpxy:latest

# Install envsubst for environment variable substitution
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Create directory for configuration
RUN mkdir -p /etc/rpxy

# Copy configuration template
COPY rpxy.toml /etc/rpxy/rpxy.toml.template

# Debug: Check what binaries are available everywhere
RUN echo "=== Checking for rpxy binaries ===" && \
    find / -name "*rpxy*" 2>/dev/null || echo "No rpxy found anywhere" && \
    echo "=== Checking PATH ===" && \
    echo $PATH && \
    echo "=== Checking common binary locations ===" && \
    ls -la /usr/local/bin/ 2>/dev/null || echo "/usr/local/bin not found" && \
    ls -la /usr/bin/ | grep rpxy || echo "No rpxy in /usr/bin" && \
    ls -la /bin/ | grep rpxy || echo "No rpxy in /bin" && \
    echo "=== Checking if there's a different entrypoint ===" && \
    ls -la / | grep -E "(start|run|entry)" || echo "No startup scripts found"

# Create startup script that processes environment variables
RUN echo '#!/bin/sh' > /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Processing rpxy configuration with environment variables..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export PORT=${PORT:-8080}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export TLS_PORT=${TLS_PORT:-8443}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export SERVER_NAME=${SERVER_NAME:-*}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export UPSTREAM_URL=${UPSTREAM_URL:-127.0.0.1:3000}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export LOAD_BALANCE=${LOAD_BALANCE:-round_robin}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export LOG_LEVEL=${LOG_LEVEL:-info}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export HEALTH_CHECK_PATH=${HEALTH_CHECK_PATH:-/health}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export UPSTREAM_HEALTH_CHECK=${UPSTREAM_HEALTH_CHECK:-/health}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export HEALTH_CHECK_TIMEOUT=${HEALTH_CHECK_TIMEOUT:-10}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export WORKER_THREADS=${WORKER_THREADS:-0}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export MAX_CLIENTS=${MAX_CLIENTS:-512}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export TCP_LISTEN_BACKLOG=${TCP_LISTEN_BACKLOG:-1024}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export API_PATH=${API_PATH:-/api}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export API_UPSTREAM_URL=${API_UPSTREAM_URL:-127.0.0.1:3001}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export API_LOAD_BALANCE=${API_LOAD_BALANCE:-round_robin}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'export ENABLE_HTTP3=${ENABLE_HTTP3:-false}' >> /usr/local/bin/start-rpxy.sh && \
    echo 'envsubst < /etc/rpxy/rpxy.toml.template > /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Generated config:"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'cat /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "=== Runtime Debug Info ==="' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Looking for rpxy binary..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'find / -name "*rpxy*" 2>/dev/null || echo "No rpxy found anywhere"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Checking common paths:"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'ls -la /usr/local/bin/ | grep rpxy || echo "No rpxy in /usr/local/bin"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'ls -la /usr/bin/ | grep rpxy || echo "No rpxy in /usr/bin"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'which rpxy || echo "rpxy not in PATH"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Starting rpxy from /rpxy/bin/rpxy..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'exec /rpxy/bin/rpxy --config /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    chmod +x /usr/local/bin/start-rpxy.sh

# Expose port (will be overridden by Railway's PORT env var)
EXPOSE 8080

# Health check removed - Railway handles health checking

# Start rpxy with processed configuration
CMD ["/usr/local/bin/start-rpxy.sh"]