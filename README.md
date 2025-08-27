# rpxy Railway Template

A high-performance Rust-based HTTP reverse proxy template for Railway deployment. This template provides a fully configured rpxy instance with environment variable customization, automatic health checks, and optimized performance settings.

## About rpxy

rpxy is a simple and ultrafast HTTP reverse proxy serving multiple domain names and terminating TLS for HTTP/1.1, 2, and 3, written in Rust. It significantly outperforms NGINX and Caddy in simple reverse proxy scenarios.

## Features

- **High Performance**: 30-60% faster than NGINX in simple reverse proxy scenarios
- **HTTP/3 Support**: Full support for HTTP/1.1, HTTP/2, and HTTP/3
- **Load Balancing**: Round-robin and random load balancing strategies
- **Health Checks**: Automatic upstream health monitoring
- **TLS Termination**: Built-in TLS support with ACME/Let's Encrypt integration
- **Path-based Routing**: Route requests based on URL paths
- **Environment Variable Configuration**: Fully configurable via environment variables

## Quick Deploy to Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/4ZJq89?referralCode=dF1nvZ&utm_medium=integration&utm_source=template&utm_campaign=generic)

## Manual Deployment

1. Clone this repository
2. Set your environment variables (see Configuration section)
3. Deploy to Railway or run locally with Docker

## Configuration

### Required Environment Variables

- `UPSTREAM_URL` - The backend service URL to proxy to (e.g., `your-app.railway.internal:3000`)

### Optional Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8080` | Port for HTTP traffic |
| `TLS_PORT` | `8443` | Port for HTTPS traffic |
| `SERVER_NAME` | `*` | Server name to match (use `*` for all) |
| `LOAD_BALANCE` | `round_robin` | Load balancing strategy (`round_robin` or `random`) |
| `LOG_LEVEL` | `info` | Log level (`error`, `warn`, `info`, `debug`, `trace`) |
| `HEALTH_CHECK_PATH` | `/health` | Health check endpoint path |
| `UPSTREAM_HEALTH_CHECK` | `/health` | Upstream health check path |
| `HEALTH_CHECK_TIMEOUT` | `10` | Health check timeout in seconds |

### Advanced Configuration

| Variable | Description |
|----------|-------------|
| `API_PATH` | Path prefix for API routing (e.g., `/api`) |
| `API_UPSTREAM_URL` | Separate upstream for API requests |
| `CUSTOM_SERVER_NAME` | Additional server name for custom domain |
| `CUSTOM_UPSTREAM_URL` | Upstream for custom domain |
| `WORKER_THREADS` | Number of worker threads (0 = auto) |
| `MAX_CLIENTS` | Maximum concurrent connections |
| `ENABLE_HTTP3` | Enable HTTP/3 support (`true`/`false`) |

### TLS/ACME Configuration

| Variable | Description |
|----------|-------------|
| `TLS_CERT_PATH` | Path to TLS certificate file |
| `TLS_KEY_PATH` | Path to TLS private key file |
| `ACME_EMAIL` | Email for Let's Encrypt registration |
| `ACME_STAGING` | Use Let's Encrypt staging (`true`/`false`) |
| `ACME_DIR_URL` | ACME directory URL |

## Example Configurations

### Simple Proxy Setup

```bash
UPSTREAM_URL=myapp.railway.internal:3000
SERVER_NAME=myapp.example.com
```

### API Gateway with Path Routing

```bash
UPSTREAM_URL=frontend.railway.internal:3000
API_PATH=/api
API_UPSTREAM_URL=backend.railway.internal:8080
SERVER_NAME=myapp.example.com
```

### Multiple Domain Setup

```bash
# Default app
UPSTREAM_URL=app1.railway.internal:3000
SERVER_NAME=app1.example.com

# Custom domain
CUSTOM_SERVER_NAME=app2.example.com
CUSTOM_UPSTREAM_URL=app2.railway.internal:4000
```

## Health Checks

rpxy includes built-in health checking for upstream services. Configure health checks using:

- `UPSTREAM_HEALTH_CHECK`: Path to check on upstream services
- `HEALTH_CHECK_TIMEOUT`: Timeout for health check requests
- `HEALTH_CHECK_PATH`: Path for rpxy's own health check endpoint

## Performance Tuning

### Worker Threads
Set `WORKER_THREADS` to optimize for your workload:
- `0` (default): Auto-detect based on CPU cores
- `1-N`: Specific number of worker threads

### Connection Limits
- `MAX_CLIENTS`: Maximum concurrent connections (default: 512)
- `TCP_LISTEN_BACKLOG`: TCP listen backlog size (default: 1024)

## Local Development

```bash
# Clone the repository
git clone <this-repo-url>
cd rpxy-railway

# Set environment variables
export UPSTREAM_URL=localhost:3000
export PORT=8080

# Build and run with Docker
docker build -t rpxy-proxy .
docker run -p 8080:8080 rpxy-proxy
```

## Load Balancing

rpxy supports multiple load balancing strategies:

- `round_robin`: Distribute requests evenly across upstreams
- `random`: Randomly select upstream for each request

Configure multiple upstreams by separating them with commas:
```bash
UPSTREAM_URL=app1.railway.internal:3000,app2.railway.internal:3000,app3.railway.internal:3000
```

## Troubleshooting

### Common Issues

1. **502 Bad Gateway**: Check that `UPSTREAM_URL` is correct and reachable
2. **Health Check Failures**: Verify `UPSTREAM_HEALTH_CHECK` path exists
3. **IPv6 Issues**: rpxy is configured for IPv6 support required by Railway

### Debug Mode

Enable debug logging:
```bash
LOG_LEVEL=debug
```

### Connection Issues

Check upstream connectivity:
- Ensure upstream services are running
- Verify Railway internal networking setup
- Check firewall and port configurations

## Contributing

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- [rpxy Documentation](https://github.com/junkurihara/rust-rpxy)
- [Railway Documentation](https://docs.railway.app)
- [Issues](https://github.com/your-username/rpxy-railway/issues)