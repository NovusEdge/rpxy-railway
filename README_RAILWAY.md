# Deploy and Host rpxy on Railway

rpxy is a blazingly fast HTTP reverse proxy written in Rust that outperforms NGINX by 30-60% in reverse proxy scenarios. This Railway template provides zero-configuration deployment with automatic Railway domain handling, IPv6 support, and seamless backend service routing.

## About Hosting rpxy

Hosting rpxy on Railway gives you a production-ready reverse proxy in seconds. Simply deploy the template and set your backend service URL - rpxy automatically handles Railway's domain routing, IPv6 networking, and high-performance request forwarding. Perfect for API gateways, custom domains, and microservices routing with minimal configuration overhead.

## Common Use Cases

- **API Gateway**: Single entry point for multiple backend services on Railway
- **Custom Domain Routing**: Point your custom domain to any Railway service  
- **Frontend Proxy**: Route production domains to your Railway-hosted frontend
- **Microservices Gateway**: Centralize routing for distributed Railway services
- **High-Performance Proxy**: 30-60% faster than NGINX for Railway workloads
- **Development Proxy**: Test production routing setups with Railway preview deployments

## Simple 2-Step Setup

1. **Deploy this template** on Railway
2. **Set your backend service**:
   ```bash
   UPSTREAM_URL=your-backend.railway.internal:8000
   ```

That's it! Your high-performance reverse proxy is now routing traffic.

## Template Features

✅ **Zero Configuration** - Works immediately after deployment  
✅ **Railway Optimized** - Automatic domain detection and IPv6 support  
✅ **High Performance** - 30-60% faster than NGINX  
✅ **Production Ready** - Handles enterprise-level traffic  
✅ **Simple Management** - Just one environment variable to configure

### Implementation Details

This template uses a lightweight shell script that generates optimal rpxy configuration:

```bash
# Automatic Railway domain detection
RAILWAY_STATIC_URL=${RAILWAY_STATIC_URL:-*}

# Generate optimized rpxy config
cat > /etc/rpxy/rpxy.toml << EOF
listen_port = ${PORT}
listen_ipv6 = true

[apps.railway]
server_name = '${RAILWAY_STATIC_URL}'
reverse_proxy = [{ upstream = [{ location = '${UPSTREAM_URL}' }] }]

[apps.catchall]
server_name = '*'
reverse_proxy = [{ upstream = [{ location = '${UPSTREAM_URL}' }] }]
EOF
```

### Key Technical Features

- **Automatic IPv6 Support** - Required for Railway's infrastructure
- **Dual Domain Matching** - Handles both Railway domains and wildcards  
- **Optimized Configuration** - Minimal overhead, maximum performance
- **Production Hardened** - No unsupported fields or configuration warnings

### Links

- [rpxy Official Repository](https://github.com/junkurihara/rust-rpxy) - ⭐ High-performance Rust proxy
- [Template Source Code](https://github.com/NovusEdge/rpxy-railway) - ⭐ Star this repo if it helps you!
- [Railway Documentation](https://docs.railway.com/) - Platform documentation

## Why Deploy rpxy on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with IPv6 networking configuration, container orchestration, or scaling concerns, while allowing you to vertically and horizontally scale your proxy layer with automatic health monitoring.

By deploying rpxy on Railway, you are one step closer to supporting a complete full-stack application with minimal operational burden and maximum performance. The combination of Railway's developer experience with rpxy's performance advantages creates an ideal solution for modern web applications requiring high-throughput reverse proxy capabilities.

Host your reverse proxy, backend services, databases, AI agents, and more on Railway with the confidence that rpxy will efficiently route traffic at speeds that significantly outperform traditional solutions.