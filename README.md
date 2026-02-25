# *This project has been created as part of the 42 curriculum by asalmi.*

# Inception

## 📌 Overview

Inception is a System Administration project focused on containerization using Docker and Docker Compose. The goal is to design and deploy a secure, modular web infrastructure composed of multiple interconnected services, each running in its own isolated container.

The infrastructure includes NGINX as a secure web server, WordPress as the web application, and MariaDB as the database. These services communicate through a dedicated Docker network and use persistent volumes to ensure data durability.

This project demonstrates key concepts such as containerization, service isolation, secure communication using TLS, and multi-container orchestration with Docker Compose.

---

# 🐳 What is Containerization?

Containerization is a lightweight virtualization method that allows applications and their dependencies to run in isolated environments called containers.

Unlike virtual machines, containers share the host operating system kernel, making them:

* Faster
* Lightweight
* Efficient
* Easy to deploy

Each container runs one service independently.

---

# 🐳 What is Docker?

Docker is a platform used to create, run, and manage containers.

Docker allows developers to package applications with all dependencies into standardized units called Docker images.

Docker ensures that applications run the same way on any system.

---

# ⚙️ Docker Components Explained

## Docker Engine

Docker Engine is the core service that runs and manages containers.

It includes:

* Docker daemon (dockerd)
* REST API
* Container runtime

It is responsible for:

* Building images
* Running containers
* Managing networks and volumes

---

## Docker CLI

Docker CLI is the command-line interface used to interact with Docker Engine.

Examples:

```bash
docker build
docker run
docker ps
docker compose up
```

It sends commands to Docker Engine.

---

## Docker Image

A Docker image is a blueprint used to create containers.

It contains:

* Application code
* Dependencies
* Configuration
* Runtime environment

Images are built using Dockerfile.

---

## Docker Container

A container is a running instance of a Docker image.

Each container:

* Is isolated
* Runs one service
* Has its own filesystem
* Uses shared host kernel

---

## Dockerfile

A Dockerfile is a script used to build Docker images.

Example:

```Dockerfile
FROM debian:bullseye
RUN apt update
```

---

## Docker Compose

Docker Compose is used to manage multi-container applications.

It allows defining services, networks, and volumes in one file:

```bash
docker-compose.yml
```

---

## Docker Volume

Docker volumes store persistent data.

They ensure data is not lost when containers stop.

Used for:

* WordPress files
* MariaDB database

---

## Docker Network

Docker network allows containers to communicate securely.

Example:

* WordPress connects to MariaDB
* NGINX connects to WordPress

---

# 🏗️ Project Architecture

This project consists of multiple containers:

```
NGINX
WordPress (PHP-FPM)
MariaDB
```

All containers communicate through a Docker network.

NGINX is the only public entry point.

---

# 📦 Mandatory Services

## 1. NGINX Container

Purpose:

* Web server
* Handles HTTPS connections
* Uses TLSv1.2 or TLSv1.3
* Reverse proxy to WordPress

Port:

```
443
```

---

## 2. WordPress Container

Purpose:

* Hosts WordPress application
* Uses PHP-FPM
* Communicates with MariaDB

Does NOT include nginx.

---

## 3. MariaDB Container

Purpose:

* Database server
* Stores WordPress data
* User accounts
* Website content

---

## 4. Docker Volumes

Two volumes are used:

Volume 1:

```
WordPress database
```

Volume 2:

```
WordPress website files
```

---

## 5. Docker Network

Purpose:

* Connect containers securely
* Allows internal communication

---

# 🔒 Security Features

* TLS encryption (HTTPS)
* Environment variables (.env)
* No passwords in Dockerfiles
* Container isolation
* Dedicated network

---

# 🎁 Bonus Services

The following bonus services were implemented:

## Redis Container

Purpose:

* Cache WordPress data
* Improve performance

---

## Adminer Container

Purpose:

* Database management tool
* Web interface for MariaDB

Access example:

```
https://login.42.fr/adminer
```

---

## Static Website Container

Purpose:

* Simple static website
* Built using HTML/CSS/JS
* Served using NGINX

---

## Additional Service (example: Portainer)

Purpose:

* Docker management interface
* Monitor containers
* Manage volumes and networks

---

# 🚀 Installation and Usage

## Requirements

* Docker
* Docker Compose
* Virtual Machine
* Make

---

## Run the project

```bash
make
```

or

```bash
docker compose up --build
```

---

## Stop the project

```bash
docker compose down
```

---

## Check running containers

```bash
docker ps
```

---

# 📁 Project Structure

```
.
├── Makefile
├── secrets/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       ├── wordpress/
│       ├── mariadb/
│       └── bonus/
```

---

# 🧠 Key Concepts Learned

* Docker containerization
* Docker networking
* Docker volumes
* Infrastructure design
* Service isolation
* Secure web server configuration
* System administration

---

# 📚 Resources

Docker documentation:

https://docs.docker.com/

NGINX documentation:

https://nginx.org/

WordPress documentation:

https://wordpress.org/

---

# ✅ Conclusion

This project demonstrates how to build a complete, secure, and scalable infrastructure using Docker. It highlights best practices in containerization, networking, security, and system administration.

Each service runs independently in its own container, ensuring modularity, isolation, and maintainability.
