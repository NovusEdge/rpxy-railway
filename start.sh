#!/bin/sh

echo "Generating rpxy configuration..."

# Set defaults
PORT=${PORT:-8080}
SERVER_NAME=${SERVER_NAME:-*}
UPSTREAM_URL=${UPSTREAM_URL:-127.0.0.1:3000}

# Generate correct rpxy config based on official examples
cat > /etc/rpxy/rpxy.toml << EOF
# rpxy Configuration for Railway
listen_port = ${PORT}

[apps.default]
server_name = '${SERVER_NAME}'
reverse_proxy = [{ upstream = [{ location = '${UPSTREAM_URL}' }] }]

# Catch-all app for any hostname
[apps.catchall]  
server_name = '*'
reverse_proxy = [{ upstream = [{ location = '${UPSTREAM_URL}' }] }]
EOF

echo "Generated config:"
cat /etc/rpxy/rpxy.toml

echo "Starting rpxy reverse proxy..."
exec /rpxy/bin/rpxy --config /etc/rpxy/rpxy.toml