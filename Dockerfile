FROM jqtype/rpxy:latest

# Create directory for configuration
RUN mkdir -p /etc/rpxy

# Copy startup script
COPY start.sh /usr/local/bin/start-rpxy.sh
RUN chmod +x /usr/local/bin/start-rpxy.sh

# Expose port (will be overridden by Railway's PORT env var)
EXPOSE 8080

# Start rpxy with generated configuration
CMD ["/usr/local/bin/start-rpxy.sh"]