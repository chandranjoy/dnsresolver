# DNS Resolver

A Python-based DNS Resolver tool with a web-based user interface built using **Flask**.

## Features

- DNS lookup and resolution using Python.
- Web-based UI powered by Flask.
- Domain information lookup using WHOIS.
- Lightweight Python application.
- Easy deployment using a Python virtual environment.
- Runs on port `5000` by default.

## Prerequisites

- Python 3 (stable version).
- pip3 package manager.
- Git (if cloning from the repository).

## Installation

### 1. Install Python 3

**macOS**

Install Python 3 using Homebrew:

```bash
brew install python3
```

If Homebrew is not installed, refer to: https://brew.sh

**Linux (Ubuntu/Debian)**

```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-venv
```

### 2. Navigate to the Application Directory

```bash
cd /opt/dnsresolver
```

### 3. Configure Environment Variables

Create a secure Flask secret key:

```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

Create the `.env` file:

```bash
nano .env
```

Add the following configuration, replacing the example value with your generated secret key:

```ini
SECRET_KEY=your_generated_secret_key
```

**Important:** Keep your `.env` file private. Do not commit it to your Git repository.

### 4. Create a Python Virtual Environment

```bash
python3 -m venv venv
```

Activate the virtual environment:

```bash
source venv/bin/activate
```

### 5. Install Required Python Packages

Install the application dependencies:

```bash
pip3 install flask dnspython python-whois gunicorn
```

Ensure that all required packages are installed inside the virtual environment.

## Starting the Application

Once the installation and configuration are complete, start the DNS Resolver application:

```bash
./start.sh
```

The application listens on port `5000` by default.

### Access the Web Interface

Open your browser and navigate to:

```text
http://PUBLIC_IP:5000
```

Replace `PUBLIC_IP` with your server's public IP address.

**Note:** Ensure that port `5000` is allowed through your server firewall if accessing the application directly.

## Configure HTTPS Using Nginx

For production environments, it is recommended to access DNS Resolver through a subdomain with HTTPS enabled.

Use **Nginx as a reverse proxy** and configure an SSL certificate using Let's Encrypt.

Example:

```text
https://dnsresolver.example.com
```

For Nginx and Python application deployment guidance, refer to:

- [DigitalOcean – How To Set Up uWSGI and Nginx to Serve Python Apps on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-uwsgi-and-nginx-to-serve-python-apps-on-ubuntu-14-04)

**Recommendation:** Use Gunicorn behind Nginx for production deployments rather than exposing Flask directly to the internet.

## Stopping the Application

To stop the DNS Resolver application:

```bash
./stop.sh
```

## Restarting the Application

To restart the app (e.g. after changing code or `.env`):

```bash
./restart.sh
```

## Start Automatically on Server Boot (systemd)

Make sure `/opt/dnsresolver/.env` contains `SECRET_KEY` and `gunicorn` is installed in the virtual environment, then run:

```bash
sudo ./install-service.sh
```

This installs `dnsresolver.service`, enables it at boot and starts it. Once installed, `start.sh`, `stop.sh` and `restart.sh` hand off to systemctl automatically (run them with `sudo`), or manage the service directly:

```bash
sudo systemctl status dnsresolver
sudo systemctl restart dnsresolver
sudo journalctl -u dnsresolver
```

To remove the service:

```bash
sudo systemctl disable --now dnsresolver
sudo rm /etc/systemd/system/dnsresolver.service
```

## Troubleshooting

### 1. Check Application Logs

If the application fails to start or behaves unexpectedly, check the error log:

```bash
tail -f /var/log/dnsresolver-error.log
```

### 2. Verify Python Dependencies

Make sure the required Python packages are installed inside the active virtual environment.

```bash
source venv/bin/activate
pip3 list
```

Required modules include:

- `flask`
- `dns.resolver` (provided by `dnspython`)
- `whois` (provided by `python-whois`)
- `gunicorn`

### 3. Verify Application Port

Check whether the application is listening on port `5000`:

```bash
sudo ss -lntp | grep :5000
```

### 4. Check Virtual Environment

If Python modules are missing, activate the virtual environment and reinstall the dependencies:

```bash
source /opt/dnsresolver/venv/bin/activate
pip3 install flask dnspython python-whois gunicorn
```

## Compatibility

**Tested Environment:**

- Ubuntu 24.04.x LTS

The application is developed using Python and Flask. Although it has been tested on Ubuntu 24.04.x LTS, it should also work on other Linux distributions and macOS with the required Python dependencies installed.

## License

Refer to the repository's license file for licensing information.
