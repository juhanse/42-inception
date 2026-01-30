# 🐋 Inception

*This project has been created as part of the 42 curriculum by juhanse.*

## Description

**Inception** is a system administration project that aims to broaden knowledge of system virtualization using **Docker**. The goal is to build a small-scale, high-availability infrastructure consisting of several services, each running in its own dedicated container within a virtual machine.

The project involves setting up a LEMP stack (Linux, Engine -> Nginx, MariaDB, PHP-FPM) and WordPress, while strictly adhering to security best practices, such as using **TLS v1.2**, managing **Docker Secrets**, and ensuring persistent storage through **Named Volumes**.

## Project Description & Technical Choices

This project is built using **Docker Compose** to orchestrate three main services:

1. **NGINX**: The only entry point (Port 443), configured with SSL/TLS.
2. **WordPress + PHP-FPM**: The web application layer.
3. **MariaDB**: The relational database management system.

### Design Choices

* **Base Image**: I chose **Debian Bookworm**. Following the project requirement to use the penultimate stable version of Debian or Alpine, Bookworm (Debian 12) was selected. It provides a highly stable environment and native support for PHP 8.2, ensuring both performance and security.
* **Initialization**: Service startup order is managed via custom shell scripts and `depends_on` to ensure MariaDB is ready before WordPress attempts installation.
* **WP-CLI**: Used to automate the installation of WordPress and the creation of the mandatory second user without manual browser intervention.

### Technical Comparisons

| Topic | Comparison |
| --- | --- |
| **VM vs Docker** | **Virtual Machines** virtualize hardware and include a full OS, making them heavy. **Docker** virtualizes the OS kernel, allowing containers to share the host's resources, making them lightweight and faster to start. |
| **Secrets vs Env Vars** | **Environment Variables** are visible to any process in the container and often logged. **Docker Secrets** are stored in an encrypted raft and mounted as temporary files in `/run/secrets/`, providing much higher security for passwords. |
| **Docker Network vs Host** | **Host Networking** bypasses Docker's network isolation, which is a security risk. A custom **Docker Network (Bridge)** provides isolated, private communication between containers using internal DNS (service names). |
| **Docker Volumes vs Bind Mounts** | **Bind Mounts** depend on the host's file system structure. **Named Volumes** are managed by Docker, providing better abstraction, performance, and portability across different operating systems. |

## Instructions

### Prerequisites

* A Linux environment (Virtual Machine recommended, e.g., Lubuntu/Debian).
* Docker and Docker Compose installed.
* Your user added to the `docker` group.

### Installation & Execution

1. **Clone the repository**:
```bash
git clone git@github.com:juhanse/42-inception.git inception
cd inception
```


2. **Configure Environment**:
Create a `.env` file and a `secrets/` directory with `db_password.txt` and `wp_password.txt` as defined in the project documentation.
3. **Build and Start**:
```bash
sudo make
```


4. **Access the site**:
Add `127.0.0.1 juhanse.42.fr` to your `/etc/hosts` and visit `https://juhanse.42.fr`.

### Commands

* `sudo make`: Setup directories and start containers in detached mode.
* `sudo make down`: Stops and removes the containers and the network, but preserves volumes and images.
* `sudo make clean`: Remove containers and images.
* `sudo make fclean`: Full cleanup, including volumes and local data folders.

## Resources

* [Official Docker Documentation](https://docs.docker.com/)
* [Nginx Documentation (SSL Module)](https://nginx.org/en/docs/http/configuring_https_servers.html)
* [WP-CLI Handbook](https://make.wordpress.org/cli/handbook/)
* [Debian Packages Search](https://packages.debian.org/index)

### Use of AI

**AI (Gemini/ChatGPT)** was used as a collaborative peer during this project for the following tasks:

* **Refactoring shell scripts**: Optimizing the logic to wait for MariaDB and handle Docker Secrets.
* **Debugging**: Resolving `permission denied` errors related to Docker volumes and UID/GID mapping.
* **Clarification**: Explaining the difference between TLS protocols and the mechanics of PID 1 in Docker.
* **Documentation**: Assisting in the clear structuring and drafting of this README.md in English.

---
