FROM jqtype/rpxy:latest

# Install envsubst for environment variable substitution
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Create directory for configuration
RUN mkdir -p /etc/rpxy

# Copy configuration template and startup script
COPY rpxy.toml /etc/rpxy/rpxy.toml.template
COPY start.sh /usr/local/bin/start-rpxy.sh
RUN chmod +x /usr/local/bin/start-rpxy.sh

# Expose port (will be overridden by Railway's PORT env var)
EXPOSE 8080

# Start rpxy with processed configuration
CMD ["/usr/local/bin/start-rpxy.sh"]