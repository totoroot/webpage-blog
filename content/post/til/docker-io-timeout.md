---
title: "Strange error - Docker i/o Timeout"
date: 2025-08-21T00:59:38+02:00
draft: false
description: "Docker i/o timeout when using Docker Compose with BuildKit"
categories: TIL
tags: [
    "Docker",
    "Containerisation",
    "Docker Compose",
    "Containers",
    "Kubernetes",
    "BuildKit"
]
slug: "docker-io-timeout"
---

# Strange error - Docker i/o timeout

## How we got there?

In my dayjob, as a Senior DevOps Engineer, I am, among other things, responsible for containerising applications so that they can later on get deployed to Kubernetes clusters.

The application might be a data streaming application written in Python, perhaps using `poetry` or `uv` for package management. Or it might be a JavaScript or TypeScript microservice. Whatever it is, I will try to containerise it.

Usually it goes like this:

1. Application is developed by team (Frontend, Backend, Data Science)
1. I am consulted on how to get this thing on the friggin Kubernetes cluster
1. ???
1. Profit!

### Containerisation workflow

For step 3 I mostly stick to the following workflow:

- Get application to build locally
- If it's a frontend project, get annoyed that it is using yet another JS framework or different tooling
  - Last time it was yarn, this other person likes to stick to npm, but this person is using pnpm (which is actually pretty neat 👀)
- Put together a simple Dockerfile (often copy-pasting from related projects I've containerised before)
- Use a simple Docker Compose setup to build and run the application in case external services have to be accessed (this could be a Kafka cluster, a PostgreSQL database or even something like a BigTable emulator)
- Iterate to get it working
- Make it as slim as possible, often by employing multi-stage builds
- Improve on caching

## The problem - Docker i/o timeout

I recently did that for another TypeScript project. It worked fine when I put it all together on Monday. However, when I ran `docker compose build` today, it failed with a strange error:

```
λ BUILDKIT_PROGRESS=plain docker compose build --no-cache
WARN[0000] Docker Compose is configured to build using Bake, but buildx isn't installed
#0 building with "multiarch-builder" instance using docker-container driver

#1 [frontend-thingy internal] load build definition from Dockerfile
#1 transferring dockerfile: 3.00kB done
#1 DONE 0.0s

#2 [frontend-thingy internal] load metadata for docker.io/library/node:24-alpine
#2 ERROR: failed to do request: Head "https://registry-1.docker.io/v2/library/node/manifests/24-alpine": dial tcp: lookup registry-1.docker.io on 192.168.1.41:53: read udp 172.17.0.2:53782->192.168.1.41:53: i/o timeout
------
 > [frontend-thingy internal] load metadata for docker.io/library/node:24-alpine:
------
failed to solve: node:24-alpine: failed to resolve source metadata for docker.io/library/node:24-alpine: failed to do request: Head "https://registry-1.docker.io/v2/library/node/manifests/24-alpine": dial tcp: lookup registry-1.docker.io on 192.168.1.41:53: read udp 172.17.0.2:53782->192.168.1.41:53: i/o timeout
```

Notice something strange about this error message?

Why would it try to lookup `docker.io` on the local network range? 🤔
Maybe it's DNS...it' always DNS, right?

Checked `/etc/resolv.conf`. Seems fine.

```
curl -v https://registry-1.docker.io/v2/library/node/manifests/24-alpine
```

Hmm, seems to resolve fine.

Restart stuff:

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Issue persists, but nothing seems to be out of the ordinary.

Run `docker ps`:

```
CONTAINER ID   IMAGE                             COMMAND                  CREATED         STATUS        PORTS   NAMES
e85b31a01978   moby/buildkit:buildx-stable-1                             "buildkitd"              16 months ago   Up 3 weeks   buildx_buildkit_multiarch-builder0
```

```
#2 [reports-graphql-translator internal] load metadata for docker.io/library/node:24-alpine
#2 ERROR: failed to do request: Head "https://registry-1.docker.io/v2/library/node/manifests/24-alpine":dial tcp: lookup registry-1.docker.io on 8.8.4.4:53: read udp 172.17.0.2:55175->8.8.4.4:53: i/o timeout
------
 > [reports-graphql-translator internal] load metadata for docker.io/library/node:24-alpine:
------
failed to solve: node:24-alpine: failed to resolve source metadata for docker.io/library/node:24-alpine:failed to do request: Head "https://registry-1.docker.io/v2/library/node/manifests/24-alpine": dial tcp:lookup registry-1.docker.io on 8.8.4.4:53: read udp 172.17.0.2:55175->8.8.4.4:53: i/o timeout
```

## The fix

For local builds, I use Docker's BuildKit, as this usually speeds things up and sometimes I want to build for other architectures like aarch64.

This time, this was my downfall, as apparently the buildkit container sets the network configuration when initially started, but does not update it.

So all I had to do was stop the buildkit container:

```sh
docker stop buildx_buildkit_multiarch-builder0
```

When re-running `docker compose up` it recreates the buildkit container anyways and it should work again.

## The why

Not sure to be honest, but I thought it'd be a good idea to document the fix in case someone else runs into this.

Or much more likely...in case I run into it again and need a reminder of how I fixed it last time 😁
