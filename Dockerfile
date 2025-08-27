FROM jqtype/rpxy:latest

# Install envsubst for environment variable substitution
RUN apk add --no-cache gettext

# Create directory for configuration
RUN mkdir -p /etc/rpxy

# Copy configuration template
COPY rpxy.toml /etc/rpxy/rpxy.toml.template

# Create startup script that processes environment variables
RUN echo '#!/bin/sh' > /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Processing rpxy configuration with environment variables..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'envsubst < /etc/rpxy/rpxy.toml.template > /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    echo 'echo "Starting rpxy reverse proxy..."' >> /usr/local/bin/start-rpxy.sh && \
    echo 'exec rpxy -c /etc/rpxy/rpxy.toml' >> /usr/local/bin/start-rpxy.sh && \
    chmod +x /usr/local/bin/start-rpxy.sh

# Expose port (will be overridden by Railway's PORT env var)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT:-8080}${HEALTH_CHECK_PATH:-/health} || exit 1

# Start rpxy with processed configuration
CMD ["/usr/local/bin/start-rpxy.sh"]