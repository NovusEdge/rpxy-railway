# rpxy Railway Template

A high-performance Rust-based HTTP reverse proxy template for Railway deployment. rpxy is 30-60% faster than NGINX and provides seamless reverse proxy functionality with automatic Railway domain handling and IPv6 support.

## About rpxy

rpxy is a simple and ultrafast HTTP reverse proxy serving multiple domain names and terminating TLS for HTTP/1.1, 2, and 3, written in Rust. Perfect for API gateways, load balancing, and microservices routing on Railway.

## Features

- **High Performance**: 30-60% faster than NGINX in reverse proxy scenarios
- **Railway Optimized**: Automatic Railway domain matching and IPv6 support
- **Simple Configuration**: Just set `UPSTREAM_URL` and deploy
- **HTTP/1.1, 2, 3 Support**: Full modern HTTP protocol support
- **Zero Configuration**: Works out of the box with Railway services
- **Production Ready**: Handles high-traffic workloads efficiently

## Quick Deploy to Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/4ZJq89?referralCode=dF1nvZ&utm_medium=integration&utm_source=template&utm_campaign=generic)

## Setup (2 steps)

1. **Deploy this template** to Railway
2. **Set your backend service URL**:
   ```bash
   UPSTREAM_URL=your-backend.railway.internal:3000
   ```

That's it! Your reverse proxy is now running and will route all requests to your backend service.

## Configuration

### Required Environment Variable

- `UPSTREAM_URL` - Your backend service URL (e.g., `api.railway.internal:8080`)

### Optional Environment Variables

| Variable      | Default | Description                           |
| ------------- | ------- | ------------------------------------- |
| `SERVER_NAME` | `*`     | Specific domain to match (optional)   |
| `PORT`        | `8080`  | Port for the proxy (Railway manages) |

## How It Works

The template automatically:
1. **Detects your Railway domain** using `RAILWAY_STATIC_URL`
2. **Handles IPv6 networking** required by Railway infrastructure  
3. **Routes all requests** from `https://your-app.up.railway.app/*` to `http://your-backend:port/*`
4. **Provides high performance** with Rust-based rpxy proxy

## Example Usage

### Basic API Proxy
```bash
UPSTREAM_URL=my-api.railway.internal:8080
```
Routes `https://your-proxy.up.railway.app/api/users` → `http://my-api.railway.internal:8080/api/users`

### Frontend + API Setup  
```bash
UPSTREAM_URL=my-frontend.railway.internal:3000
```
Perfect for routing a custom domain to your frontend service.

### Microservice Gateway
```bash
UPSTREAM_URL=gateway-service.railway.internal:4000
```
Centralizes routing for multiple microservices behind one domain.

## Common Use Cases

- **Custom Domain Routing**: Point custom domains to Railway services
- **API Gateway**: Single entry point for multiple backend services  
- **Load Distribution**: High-performance alternative to traditional proxies
- **SSL Termination**: Let Railway handle HTTPS, proxy to HTTP backends
- **Development**: Test production routing setups locally

## Performance

rpxy delivers exceptional performance:
- **1.5x faster** than NGINX in simple reverse proxy scenarios
- **Built with Rust** for memory safety and speed
- **HTTP/3 ready** for next-generation web performance
- **Automatic optimization** for Railway's infrastructure

## Troubleshooting

### 503 Service Unavailable
- Check that your `UPSTREAM_URL` service is running
- Verify the internal Railway service name and port
- Ensure the backend service is healthy

### 404 Not Found  
- The proxy is working! Your backend doesn't have that endpoint
- Check your backend service logs

## Local Development

```bash
git clone <this-repo>
cd rpxy-railway

# Test locally
export UPSTREAM_URL=localhost:3000
docker build -t rpxy .
docker run -p 8080:8080 rpxy
```

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
