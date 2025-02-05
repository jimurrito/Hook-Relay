# Hook Relay
Lite webhook request proxy. Allows apps to reduce their attack surface by using this service as a proxy just for WebHooks.


**Table of Contents**
- [Hook Relay](#hook-relay)
- [Features](#features)
- [Deployment methods](#deployment-methods)
  - [Docker](#docker)
    - [Docker CLI](#docker-cli)
    - [Docker Compose](#docker-compose)
  - [Linux](#linux)
  - [Windows](#windows)
  - [Source](#source)


# Features
- Blazingly fast!
- Handles all requests in parallel for maximum throughput.
- Native Live reloading - never need to restart the server for configuration changes!
- TOML configuration files.
- Optional async mode for request relaying.
- Small compute foot print.
- Highly scalable.
- Supports vertical and horizontal scaling.
- Multi-Architecture Support.
- Supports Windows and Linux.


# Deployment methods
- Docker
- Linux
- Windows
- Source

## Docker
The Alpine Linux based image was built to have the smallest footprint possible.

### Docker CLI
```bash
docker run \
  --name hook-relay \
  -p 4000:4000 \
  -v path/to/config/dir:/config \
  jimurrito/hookrelay:latest
```

### Docker Compose
```yaml
services:
  hook-relay:
    image: jimurrito/hook-relay:latest
    container_name: hook-relay
    ports:
      - 4000:4000
    volumes:
      - path/to/config/dir:/config
    env_file: ".env"
```




## Linux


## Windows


## Source
