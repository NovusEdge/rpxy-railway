#!/bin/sh

echo "Processing rpxy configuration with environment variables..."

# Export all environment variables with defaults
export PORT=${PORT:-8080}
export TLS_PORT=${TLS_PORT:-8443}
export SERVER_NAME=${SERVER_NAME:-*}
export UPSTREAM_URL=${UPSTREAM_URL:-127.0.0.1:3000}
export LOAD_BALANCE=${LOAD_BALANCE:-round_robin}
export LOG_LEVEL=${LOG_LEVEL:-info}
export HEALTH_CHECK_PATH=${HEALTH_CHECK_PATH:-/health}
export UPSTREAM_HEALTH_CHECK=${UPSTREAM_HEALTH_CHECK:-/health}
export HEALTH_CHECK_TIMEOUT=${HEALTH_CHECK_TIMEOUT:-10}
export WORKER_THREADS=${WORKER_THREADS:-0}
export MAX_CLIENTS=${MAX_CLIENTS:-512}
export TCP_LISTEN_BACKLOG=${TCP_LISTEN_BACKLOG:-1024}
export API_PATH=${API_PATH:-/api}
export API_UPSTREAM_URL=${API_UPSTREAM_URL:-127.0.0.1:3001}
export API_LOAD_BALANCE=${API_LOAD_BALANCE:-round_robin}
export ENABLE_HTTP3=${ENABLE_HTTP3:-false}

# Process template with environment variables
envsubst < /etc/rpxy/rpxy.toml.template > /etc/rpxy/rpxy.toml

echo "Generated config:"
cat /etc/rpxy/rpxy.toml

echo "Starting rpxy reverse proxy..."
exec /rpxy/bin/rpxy --config /etc/rpxy/rpxy.toml