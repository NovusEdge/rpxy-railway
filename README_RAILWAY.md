# Deploy and Host rpxy on Railway

rpxy is a simple and ultrafast HTTP reverse proxy serving multiple domain names and terminating TLS for HTTP/1.1, 2, and 3, written in Rust. Built for high performance and reliability, rpxy automatically routes traffic to backend services with advanced load balancing, health checking, and TLS termination, making it perfect for microservices architectures and API gateways.

## About Hosting rpxy

Hosting rpxy on Railway involves deploying a high-performance reverse proxy that can route traffic to your backend services with exceptional speed and reliability. This template provides a fully configured rpxy instance with environment variable customization, automatic health checks, path-based routing, and optimized performance settings. Railway's infrastructure handles IPv6 networking and scaling while rpxy manages intelligent traffic distribution at speeds 30-60% faster than traditional solutions like NGINX.

## Common Use Cases

- **API Gateway**: Route incoming requests to multiple backend services based on URL paths and server names
- **Load Balancing**: Distribute traffic across multiple instances of your application with round-robin or random strategies
- **Microservices Routing**: Centralize routing logic for complex microservices architectures with advanced path matching
- **TLS Termination**: Handle HTTPS traffic with automatic certificate management via ACME/Let's Encrypt
- **High-Performance Proxy**: Replace slower reverse proxies with rpxy's Rust-powered performance advantages
- **Multi-Domain Hosting**: Serve multiple applications from a single proxy instance with server name matching

## Dependencies for rpxy Hosting

- **Backend Services**: At least one backend service that rpxy can route traffic to
- **Health Check Endpoints**: Backend services should provide health check endpoints for optimal routing and monitoring

### Deployment Dependencies

- [rpxy Official Repository](https://github.com/junkurihara/rust-rpxy)
- [Railway Platform Documentation](https://docs.railway.com/)
- [Docker Hub - rpxy Images](https://hub.docker.com/r/jkrhb/rpxy)
- [Template Source Code](https://github.com/NovusEdge/rpxy-railway) - ⭐ Star this repo if it helps you!

### Implementation Details

This template uses a startup script with `envsubst` for dynamic configuration:

```bash
# Generate configuration from template
envsubst < /etc/rpxy/rpxy.toml.template > /etc/rpxy/rpxy.toml

# Start rpxy with generated config
exec rpxy -c /etc/rpxy/rpxy.toml
```

Key environment variables for configuration:
```bash
UPSTREAM_URL=your-service.railway.internal:3000
SERVER_NAME=your-domain.com
LOAD_BALANCE=round_robin    # or 'random'
LOG_LEVEL=info             # Default log verbosity
HEALTH_CHECK_PATH=/health   # Health check endpoint
```

Advanced routing configuration:
```bash
# Path-based routing for APIs
API_PATH=/api
API_UPSTREAM_URL=api-service.railway.internal:8080

# Multiple domain support
CUSTOM_SERVER_NAME=api.example.com
CUSTOM_UPSTREAM_URL=api-backend.railway.internal:4000
```

Performance optimization settings:
```bash
WORKER_THREADS=0           # Auto-detect CPU cores
MAX_CLIENTS=512           # Concurrent connection limit
ENABLE_HTTP3=false        # HTTP/3 protocol support
```

TLS and ACME configuration:
```bash
ACME_EMAIL=admin@example.com
ACME_STAGING=false
TLS_PORT=8443
```

## Why Deploy rpxy on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with IPv6 networking configuration, container orchestration, or scaling concerns, while allowing you to vertically and horizontally scale your proxy layer with automatic health monitoring.

By deploying rpxy on Railway, you are one step closer to supporting a complete full-stack application with minimal operational burden and maximum performance. The combination of Railway's developer experience with rpxy's performance advantages creates an ideal solution for modern web applications requiring high-throughput reverse proxy capabilities.

Host your reverse proxy, backend services, databases, AI agents, and more on Railway with the confidence that rpxy will efficiently route traffic at speeds that significantly outperform traditional solutions.