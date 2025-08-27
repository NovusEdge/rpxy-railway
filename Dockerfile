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
    echo 'echo "Trying to start rpxy..."' >> /usr/local/bin/start-rpxy.sh && \
    echo '/usr/local/bin/rpxy --config /etc/rpxy/rpxy.toml 2>&1 || echo "rpxy not at /usr/local/bin/rpxy"' >> /usr/local/bin/start-rpxy.sh && \
    echo '/usr/bin/rpxy --config /etc/rpxy/rpxy.toml 2>&1 || echo "rpxy not at /usr/bin/rpxy"' >> /usr/local/bin/start-rpxy.sh && \
    echo 'rpxy --config /etc/rpxy/rpxy.toml 2>&1 || echo "rpxy not in PATH"' >> /usr/local/bin/start-rpxy.sh && \
    chmod +x /usr/local/bin/start-rpxy.sh

# Expose port (will be overridden by Railway's PORT env var)
EXPOSE 8080

# Health check removed - Railway handles health checking

# Start rpxy with processed configuration
CMD ["/usr/local/bin/start-rpxy.sh"]