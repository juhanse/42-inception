### File 1: `USER_DOC.md`

# User Documentation

This guide provides the necessary information to operate and manage the Inception web infrastructure.

## 1. Services Provided

The stack provides a fully functional, containerized WordPress website secured by an Nginx reverse proxy.

* **Web Server (Nginx):** Handles secure HTTPS traffic (TLS 1.2).
* **Website (WordPress):** The content management system powered by PHP 8.2.
* **Database (MariaDB):** Stores all website content, users, and configurations.

## 2. Starting and Stopping the Project

All operations must be performed from the root of the project directory using `make`.

* **To Start:** `sudo make`
* **To Stop:** `sudo make down`
* **To Restart everything (reset):** `sudo make re`

## 3. Accessing the Website

Before accessing the site, ensure your local `hosts` file redirects the domain to your machine.

1. Open your browser.
2. **Public Website:** Navigate to `https://juhanse.42.fr`
3. **Admin Dashboard:** Navigate to `https://juhanse.42.fr/wp-admin`

## 4. Managing Credentials

Credentials are not stored in the code for security reasons.

* **Database & WP User:** Managed via Docker Secrets in the `secrets/` directory.
* **Admin User:** Defined during the first launch via environment variables in the `.env` file.
* **Location:** Check the `.env` file at the project root for usernames and email addresses.

## 5. Checking Service Status

To verify that all components are running correctly, use the following command:

```bash
sudo docker ps
```

All three containers (`nginx`, `wordpress`, `mariadb`) should show a status of **Up**.
