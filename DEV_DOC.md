# Developer Documentation

This document explains how to set up, build, and maintain the Inception infrastructure.

## 1. Environment Setup

### Prerequisites

* **OS:** Debian Bookworm or Lubuntu (Virtual Machine recommended).
* **Tools:** Docker, Docker Compose, GNU Make.
* **Structure:** Ensure your login matches the paths in the configuration.

### Configuration Files

1. **.env file:** Create a `.env` file at the root containing:
* `MYSQL_DATABASE`, `MYSQL_USER`
* `DOMAIN_NAME=juhanse.42.fr`
* `WP_ADMIN_USER`, `WP_USER`, etc.


2. **Secrets:** Create a `secrets/` directory (outside `srcs/`) containing:
* `db_password.txt`
* `wp_password.txt`



## 2. Build and Launch

The project is orchestrated via a `Makefile` that triggers `docker-compose.yml`.

```bash
sudo make
```

This command:

1. Creates the local volume directories on the host.
2. Builds custom images for each service (No pre-built images from DockerHub).
3. Establishes a dedicated bridge network (`inception`).

## 3. Container Management

| Task | Command |
| --- | --- |
| View Logs | `docker logs <container_name>` |
| Execute Shell | `docker exec -it <container_name> bash` |
| Check DB Connection | `docker exec -it wordpress wp db check --allow-root` |

## 4. Data Persistence

Data is stored using **Docker Named Volumes** mapped to the host's file system for performance and persistence.

* **Path:** `/home/juhanse/data/`
* `.../mysql`: Contains MariaDB raw data files.
* `.../wordpress`: Contains the WordPress core files and uploads.


* **Persistence:** Data survives `docker compose down`. It is only deleted if `sudo make fclean` is executed.
